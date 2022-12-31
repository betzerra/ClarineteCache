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
        let paragraphs = try document
            .select("section.detail-body")
            .flatMap { try $0.getElementsByTag("p") }

        return paragraphs
            .compactMap { try? $0.html() }
            .map { "<p>\($0)</p>" }
            .joined(separator: "\n")
    }
}
