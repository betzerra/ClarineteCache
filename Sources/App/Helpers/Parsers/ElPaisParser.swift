//
//  ElPaisParser.swift
//  
//
//  Created by Ezequiel Becerra on 06/04/2023.
//

import Foundation
import SwiftSoup

class ElPaisParser: BaseParser {
    override func body(document: Document) throws -> String {
        let article = try document
            .select(".Page-content")

        let allElements: [Element] = article.array()

        let rejectClasses = ["contenido-exclusivo-nota", "Page-footer", "Page-tags", "Page-aside"]
        allElements.forEach { $0.remove(classNames: rejectClasses) }

        let elements = try sanitizeBody(elements: allElements)

        return elements
            .compactMap { try? $0.outerHtml() }
            .joined(separator: "\n")
    }
}
