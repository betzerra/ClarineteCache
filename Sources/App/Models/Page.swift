//
//  Page.swift
//  
//
//  Created by Ezequiel Becerra on 30/12/2022.
//

import Foundation

struct Page: Codable {
    let url: URL
    let title: String
    let description: String
    let thumbnail: Thumbnail?
    let body: String
    let html: String
}
