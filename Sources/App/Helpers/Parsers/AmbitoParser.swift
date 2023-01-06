//
//  AmbitoParser.swift
//  
//
//  Created by Ezequiel Becerra on 30/12/2022.
//

import Foundation
import SwiftSoup

class AmbitoParser: BaseParser {
    override func body(document: Document) throws -> String {
        let article = try document
            .select("section.detail-body")

        let elements = try sanitizeBody(elements: article.array())

        return elements
            .compactMap { try? $0.outerHtml() }
            .joined(separator: "\n")
    }
}
