//
//  RSSItem.swift
//  
//
//  Created by Ezequiel Becerra on 08/04/2023.
//

import Foundation

struct RSSItem: Codable {
    let title: String
    let link: String
    let description: String
    let guid: RSSItemGUID
    let category: [String]
}
