//
//  ElMundoParser.swift
//  
//
//  Created by Ezequiel Becerra on 11/04/2023.
//

import Foundation
import SwiftSoup

class ElMundoParser: BaseParser {
    override func body(document: Document) throws -> String {
        let article = try document
            .select("div.ue-l-article__body.ue-c-article__body")

        let elements = try sanitizeBody(elements: article.array())

        return elements
            .compactMap { try? $0.outerHtml() }
            .joined(separator: "\n")
    }
}
