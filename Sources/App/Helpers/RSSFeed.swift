//
//  RSSFeed.swift
//  
//
//  Created by Ezequiel Becerra on 08/04/2023.
//

import Foundation
import CSFeedKit

let title = "Clarinete RSS Feed"
let link = "https://clarinetecache.apps.betzerra.dev/rss"
let description = "Noticias, pero que apestan menos"

class RSSFeed {
    let feed: CSRSSFeed

    init(trends: Trends) {
        feed = RSSFeed.feed(from: trends)
    }

    static func feed(from trends: Trends) -> CSRSSFeed {
        let channel = CSRSSFeedChannel(
            title: title,
            link: link,
            description: description
        )

        let items = trends.trends.map {
            let link = "https://clarinetecache.apps.betzerra.dev/unpaywall/\($0.url.absoluteString)"

            return CSRSSFeedItem(
                title: $0.title,
                link: link,
                description: $0.title
            )
        }

        channel.items = items

        let feed = CSRSSFeed()
        feed.channels = [channel]
        return feed
    }

    var feedString: String {
        feed.xmlElement().xmlString(options: .nodePrettyPrint)
    }
}
