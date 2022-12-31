//
//  Parser.swift
//  
//
//  Created by Ezequiel Becerra on 31/12/2022.
//

import Foundation
import SwiftSoup

enum ParserError: Error {
    case missingData
    case parserNotFound
}

protocol Parser {
    func page() throws -> Page
    func thumbnail(document: Document) -> Thumbnail?
    func body(document: Document) throws -> String
}
