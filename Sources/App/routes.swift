import Redis
import Vapor

enum ClarineteError: Error {
    case wrongRedisURL
}

func routes(_ app: Application) throws {
    app.get("api", "trends") { req async throws -> [Trend] in
        let refresh = req.query["refresh"] ?? false

        return try await ClarineteCache.trends(req.application, refresh: refresh).trends
    }

    app.get("") { req async throws -> View in
        let refresh = req.query["refresh"] ?? false
        let cache = try await ClarineteCache.trends(req.application, refresh: refresh)

        return try await req.view.render("clarinete", ["cache": cache])
    }

    app.get("redis") { req -> EventLoopFuture<String> in
        return req.redis.ping()
    }
}
