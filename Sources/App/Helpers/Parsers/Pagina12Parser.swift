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
        let article = try document.select("div.section-2-col.article-main-content")

        let allElements: [Element] = article.array()

        let rejectClasses: [String] = []
        allElements.forEach { $0.remove(classNames: rejectClasses) }

        let elements = try sanitizeBody(elements: allElements)

        return elements
            .compactMap { try? $0.outerHtml() }
            .joined(separator: "\n")
    }
}
