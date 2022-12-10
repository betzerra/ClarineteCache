//
//  Trend.swift
//  
//
//  Created by Ezequiel Becerra on 17/11/2022.
//

import Foundation
import Vapor

struct Trend: Content {
    let id: Int
    let name: String
    let relatedTopics: [String]
    let title: String
    let url: URL
    var category: Category?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case relatedTopics = "related_topics"
        case title
        case url
        case category
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.relatedTopics = try container.decode([String].self, forKey: .relatedTopics)
        self.title = try container.decode(String.self, forKey: .title)
        self.url = try container.decode(URL.self, forKey: .url)
        self.category = Category.from(url: self.url)
    }

    init(
        id: Int,
        name: String,
        relatedTopics: [String],
        title: String,
        url: URL,
        category: Category?
    ) {
        self.id = id
        self.name = name
        self.relatedTopics = relatedTopics
        self.title = title
        self.url = url
        self.category = category
    }
}
