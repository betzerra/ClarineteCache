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
        return try await ClarineteCache.trends(req: req).trends
    }

    app.get("") { req async throws -> View in
        let cache = try await ClarineteCache.trends(req: req)
        return try await req.view.render("clarinete", ["cache": cache])
    }

    app.get("redis") { req -> EventLoopFuture<String> in
        return req.redis.ping()
    }
}
