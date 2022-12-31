//
//  BaseParser.swift
//  
//
//  Created by Ezequiel Becerra on 31/12/2022.
//

import Foundation
import SwiftSoup

class BaseParser: Parser {
    let url: URL
    let html: String
    let document: Document

    init(url: URL) throws {
        self.url = url
        self.html = try String(contentsOf: url, encoding: .utf8)
        self.document = try SwiftSoup.parse(html)
    }

    // MARK: - Parser
    func page() throws -> Page {
        fatalError("Subclasses need to implement this method")
    }

    func thumbnail(document: SwiftSoup.Document) -> Thumbnail? {
        return nil
    }

    func body(document: Document) throws -> String {
        fatalError("Subclasses need to implement this method")
    }
}
