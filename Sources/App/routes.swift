import Redis
import Vapor

func routes(_ app: Application) throws {
    app.get("api", "trends") { req async throws -> [Trend] in
        let refresh = req.query["refresh"] ?? false

        req.logger.info("GET api/trends - refresh: \(refresh)")
        return try await ClarineteCache.trends(req.application, refresh: refresh).trends
    }

    app.get("") { req async throws -> View in
        let refresh = req.query["refresh"] ?? false

        req.logger.info("GET / - refresh: \(refresh)")
        let cache = try await ClarineteCache.trends(req.application, refresh: refresh)

        return try await req.view.render("clarinete", ["cache": cache])
    }

    app.get("redis") { req -> EventLoopFuture<String> in
        req.logger.info("GET redis")
        return req.redis.ping()
    }
}
