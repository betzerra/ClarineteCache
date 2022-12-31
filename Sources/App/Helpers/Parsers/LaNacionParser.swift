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
        let paragraphs = try document
            .select("section.cuerpo__nota")
            .flatMap { try $0.getElementsByTag("p") }

        return paragraphs
            .compactMap { try? $0.html() }
            .map { "<p>\($0)</p>" }
            .joined(separator: "\n")
    }
}
