//
//  Pagina12Parser.swift
//  
//
//  Created by Ezequiel Becerra on 11/04/2023.
//

import Foundation
import SwiftSoup

class Pagina12Parser: BaseParser {
    override func body(document: Document) throws -> String {
        let article = try document
            .select("div.section-2-col.article-main-content")

        let elements = try sanitizeBody(elements: article.array())

        return elements
            .compactMap { try? $0.outerHtml() }
            .joined(separator: "\n")
    }
}
