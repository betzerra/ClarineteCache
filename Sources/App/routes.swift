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
        // Substract the first path component so we get the URL
        // we want to scrap
        let prefix = "/unpaywall/"
        let websiteRange = prefix.endIndex ..< req.url.path.endIndex
        let website = String(req.url.path[websiteRange])

        guard let url = URL(string: website) else {
            print("Error: \(website) doesn't seem to be a valid URL")
            throw ParserError.missingData
        }

        req.logger.info("GET unpaywall - URL: \(url)")

        guard let parser = try ParserFactory.parser(from: url) else {
            throw ParserError.parserNotFound
        }

        let page = try parser.page()
        return try await req.view.render("page", page)
    }

    app.get("redis") { req -> EventLoopFuture<String> in
        req.logger.info("GET redis")
        return req.redis.ping()
    }
}
