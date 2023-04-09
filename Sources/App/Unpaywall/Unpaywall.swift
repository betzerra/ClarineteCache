//
//  Unpaywall.swift
//  
//
//  Created by Ezequiel Becerra on 09/04/2023.
//

import Foundation
import Redis
import Vapor

class Unpaywall {
    static func page(req: Request) async throws -> Page {
        // Substract the first path component so we get the URL
        // we want to scrap
        let prefix = "/unpaywall/"
        let websiteRange = prefix.endIndex ..< req.url.path.endIndex
        let website = String(req.url.path[websiteRange])

        guard let url = URL(string: website) else {
            req.logger.error("Error: \(website) doesn't seem to be a valid URL")
            throw ParserError.missingData
        }

        req.logger.info("GET unpaywall - URL: \(req.url)")

        guard let page = try await page(url: url, req: req) else {
            return try fetchPage(url: url)
        }

        return page
    }

    private static func fetchPage(url: URL) throws -> Page {
        guard let parser = try ParserFactory.parser(from: url) else {
            throw ParserError.parserNotFound
        }

        return try parser.page()
    }

    private static func page(url: URL, req: Request) async throws -> Page? {
        // get cached Page
        let redisKey = RedisKey(url.absoluteString)
        let redis = req.application.redis

        guard let page = try await req.application.redis.get(redisKey, asJSON: Page.self) else {
            // if cached page doesn't exist, fetch the page
            let fetchedPage = try fetchPage(url: url)
            try await redis.setex(redisKey, toJSON: fetchedPage, expirationInSeconds: 300)
            return fetchedPage
        }
        return page
    }
}
