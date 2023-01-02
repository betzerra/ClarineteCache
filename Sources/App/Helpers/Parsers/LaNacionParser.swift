//
//  LaNacionParser.swift
//  
//
//  Created by Ezequiel Becerra on 31/12/2022.
//

import Foundation
import SwiftSoup

class LaNacionParser: BaseParser {
    override func body(document: Document) throws -> String {
        let article = try document
            .select("section.cuerpo__nota")

        let elements = try sanitizeBody(elements: article.array())

        return elements
            .compactMap { try? $0.outerHtml() }
            .joined(separator: "\n")
    }
}
