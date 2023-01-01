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
        let paragraphs = try document
            .select("article.entry-body")
            .flatMap { try $0.getElementsByTag("p") }

        return paragraphs
            .compactMap { try? $0.outerHtml() }
            .joined(separator: "\n")
    }
}
