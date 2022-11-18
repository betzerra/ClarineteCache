import Redis
import Vapor

enum ClarineteError: Error {
    case wrongRedisURL
}

func routes(_ app: Application) throws {
    app.get("api", "trends") { req async throws -> [Trend] in
        return try await ClarineteCache.trends(from: req.redis).trends
    }

    app.get("") { req async throws -> View in
        let cache = try await ClarineteCache.trends(from: req.redis)
        return try await req.view.render("clarinete", ["cache": cache])
    }

    app.get("redis") { req -> EventLoopFuture<String> in
        return req.redis.ping()
    }
}
