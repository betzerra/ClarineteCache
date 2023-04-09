//
//  RSSGenerator.swift
//  
//
//  Created by Ezequiel Becerra on 08/04/2023.
//

import Foundation
import XMLCoder

class RSSGenerator {
    let feed: RSSFeed

    init(trends: Trends) {
        feed = RSSGenerator.channel(from: trends.trends)
    }

    static func channel(from trends: [Trend]) -> RSSFeed {
        let channel = RSSChannel(
            title: "Clarinete RSS Feed",
            link: "https://clarinetecache.apps.betzerra.dev/rss",
            description: "Noticias, pero menos peores",
            lastBuildDate: Date(),
            pubDate: Date(),
            language: "es-AR",
            ttl: 3600,
            item: RSSGenerator.items(from: trends)
        )

        return RSSFeed(channel: [channel])
    }

    static func items(from trends: [Trend]) -> [RSSItem] {
        trends.map {
            var tags = $0.relatedTopics
            if let category = $0.category?.rawValue {
                tags.append(category)
            }

            return RSSItem.init(
                title: $0.title,
                link: "https://clarinetecache.apps.betzerra.dev/unpaywall/\($0.url.absoluteString)",
                description: $0.title,
                guid: RSSItemGUID(value: $0.url.absoluteString, isPermalink: true),
                category: tags
            )
        }
    }

    var feedString: String {
        let encoder = XMLEncoder()
        encoder.dateEncodingStrategy = .iso8601

        let data = try! encoder.encode(
            feed,
            withRootKey: "rss",
            rootAttributes: [
                "version": "2.0",
                "xmlns:content": "http://purl.org/rss/1.0/modules/content/",
                "xmlns:wfw": "http://wellformedweb.org/CommentAPI/",
                "xmlns:dc": "http://purl.org/dc/elements/1.1/"
            ]
        )
        return String(data: data, encoding: .utf8)!
    }
}
