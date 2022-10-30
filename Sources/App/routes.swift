import Redis
import Vapor

enum ClarineteError: Error {
    case wrongRedisURL
}

func routes(_ app: Application) throws {
    guard let redisURL: String = Environment.get("REDIS_URL") else {
        throw ClarineteError.wrongRedisURL
    }

    app.redis.configuration = try RedisConfiguration(url: redisURL)

    app.get("api", "trends") { req async throws -> [Trend] in
        return try await clarineteData(req: req).trends
    }

    app.get("") { req async throws -> View in
        let cache = try await clarineteData(req: req)
        return try await req.view.render("clarinete", ["cache": cache])
    }

    app.get("redis") { req -> EventLoopFuture<String> in
        return req.redis.ping()
    }
}

struct CachedClarinete: Codable {
    let timestamp: Date
    let trends: [Trend]
}

struct Trend: Content {
    let id: Int
    let name: String
    let relatedTopics: [String]
    let title: String
    let url: URL

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case relatedTopics = "related_topics"
        case title
        case url
    }
}

func clarineteData(req: Request) async throws -> CachedClarinete {
    guard let trends = try? await fetchClarineteTrends(req: req) else {
        return await fallbackData(req: req)
    }

    return trends
}

func fallbackData(req: Request) async -> CachedClarinete {
    let backupKey = RedisKey("clarinete_trends_backup")

    guard let trends = try? await req.redis.get(backupKey, asJSON: CachedClarinete.self) else {
        return CachedClarinete(timestamp: Date(), trends: [])
    }

    return trends
}

func fetchClarineteTrends(req: Request) async throws -> CachedClarinete {
    let redisKey = RedisKey("clarinete_trends")
    let backupKey = RedisKey("clarinete_trends_backup")

    guard let cached = try await req.redis.get(redisKey, asJSON: CachedClarinete.self) else {
        // Fetch fresh data from source
        let uri = URI("https://clarinete.seppo.com.ar/api/trends")
        let trends = try await req.client.get(uri).content.decode([Trend].self)

        // Sort trends
        let sortedTrends = trends.sorted { lhs, rhs in
            lhs.name.lowercased() < rhs.name.lowercased()
        }

        // Create a cache object (trends + timestamp)
        let fresh = CachedClarinete(timestamp: Date(), trends: sortedTrends)

        // Cache response
        try await req.redis.setex(redisKey, toJSON: fresh, expirationInSeconds: 300)

        // Cache it without expiration, this will be used later if:
        // 1. Key above is expired, and...
        // 2. Request above to Seppo's server is unavailable
        try await req.redis.set(backupKey, toJSON: fresh)
        return fresh
    }

    return cached
}
