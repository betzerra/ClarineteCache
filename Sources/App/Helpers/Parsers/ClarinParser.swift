//
//  ClarinParser.swift
//  
//
//  Created by Ezequiel Becerra on 31/12/2022.
//

import Foundation
import SwiftSoup

class ClarinParser: BaseParser {
    override func page() throws -> Page {
        do {
            return Page(
                url: url,
                title: "Foo",
                description: "Bar",
                thumbnail: thumbnail(document: document),
                body: try body(document: document),
                html: html
            )
        } catch let error {
            print("Error: \(error)")
            throw error
        }
    }

    override func body(document: Document) throws -> String {
        return "Baz"
    }

    override func thumbnail(document: Document) -> Thumbnail? {
        return nil
    }
}
