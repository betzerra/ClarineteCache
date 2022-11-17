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

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case relatedTopics = "related_topics"
        case title
        case url
    }
}
