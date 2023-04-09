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

        let allElements: [Element] = article.array()

        let rejectClasses = ["box-article", "box-articles  ", "mod-themes ", "mod-article"]
        allElements.forEach { $0.remove(classNames: rejectClasses) }

        let elements = try sanitizeBody(elements: allElements)

        return elements
            .compactMap { try? $0.outerHtml() }
            .joined(separator: "\n")
    }
}
