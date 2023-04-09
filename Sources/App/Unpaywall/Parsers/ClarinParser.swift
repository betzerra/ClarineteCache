//
//  ClarinParser.swift
//  
//
//  Created by Ezequiel Becerra on 31/12/2022.
//

import Foundation
import SwiftSoup

class ClarinParser: BaseParser {
    override func body(document: Document) throws -> String {
        let article = try document
            .select("article.entry-body")

        let allElements: [Element] = article.array()

        let rejectClasses = ["related", "related ", "noticiaIndividual"]
        allElements.forEach { $0.remove(classNames: rejectClasses) }

        let elements = try sanitizeBody(elements: allElements)

        return elements
            .compactMap { try? $0.outerHtml() }
            .joined(separator: "\n")
    }
}
