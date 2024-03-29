import Redis
import Vapor

struct HomeContent: Content {
    let timestamp: Date
    let groups: [GroupedTrends]

    init(timestamp: Date, groups: [GroupedTrends]) {
        self.timestamp = timestamp
        self.groups = groups
    }
}

struct PageContent: Content {
    let page: Page

    init(page: Page) {
        self.page = page
    }
}

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
        let content = HomeContent(timestamp: cache.timestamp, groups: cache.grouped)

        return try await req.view.render("clarinete", content)
    }

    app.get("unpaywall", "**") { req async throws -> View in
        let page = try await Unpaywall.page(req: req)
        return try await req.view.render("page", page)
    }

    app.get("redis") { req -> EventLoopFuture<String> in
        req.logger.info("GET redis")
        return req.redis.ping()
    }

    app.get("rss") { req async throws -> String in
        req.logger.info("GET rss")
        let cache = try await ClarineteCache.trends(req.application, refresh: false)
        let feed = RSSGenerator(trends: cache)
        return feed.feedString
    }
}
