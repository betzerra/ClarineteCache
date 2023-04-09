//
//  RSSChannel.swift
//  
//
//  Created by Ezequiel Becerra on 08/04/2023.
//

import Foundation

struct RSSChannel: Codable {
    let title: String
    let link: String
    let description: String
    let lastBuildDate: Date
    let pubDate: Date
    let language: String
    let ttl: Int

    let item: [RSSItem]
}
