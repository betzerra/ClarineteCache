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
        let article = try document.select("div.ue-l-article__body.ue-c-article__body")

        let allElements: [Element] = article.array()

        let rejectClasses: [String] = []
        allElements.forEach { $0.remove(classNames: rejectClasses) }

        let elements = try sanitizeBody(elements: allElements)

        return elements
            .compactMap { try? $0.outerHtml() }
            .joined(separator: "\n")
    }
}
