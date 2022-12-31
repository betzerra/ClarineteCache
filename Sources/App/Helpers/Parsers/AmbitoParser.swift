//
//  AmbitoParser.swift
//  
//
//  Created by Ezequiel Becerra on 30/12/2022.
//

import Foundation
import SwiftSoup

class AmbitoParser: BaseParser {
    var meta = [String: String]()

    override func page() throws -> Page {
        do {
            meta = try meta(document: document)

            guard let title = meta["og:title"],
                  let description = meta["og:description"],
                  let thumbnail = thumbnail(document: document) else {
                throw ParserError.missingData
            }

            return Page(
                url: url,
                title: title,
                description: description,
                thumbnail: thumbnail,
                body: try body(document: document),
                html: html
            )
        } catch let error {
            print("Error: \(error)")
            throw error
        }
    }

    override func body(document: Document) throws -> String {
        let paragraphs = try document
            .select("section.detail-body")
            .flatMap { try $0.getElementsByTag("p") }

        return paragraphs
            .compactMap { try? $0.html() }
            .map { "<p>\($0)</p>" }
            .joined(separator: "\n")
    }

    override func thumbnail(document: Document) -> Thumbnail? {
        guard let URLString = meta["og:image"],
              let URL = URL(string: URLString),
              let widthString = meta["og:image:width"],
              let witdh: Float = Float(widthString),
              let heightString = meta["og:image:height"],
              let height: Float = Float(heightString) else {
            return nil
        }

        return Thumbnail(url: URL, width: witdh, height: height)
    }

    private func meta(document: Document) throws -> [String: String] {
        var attributes = [String: String]()

        for element in try document.select("meta").array() {
            let property: String = try element.attr("property")
            let content: String = try element.attr("content")

            guard !property.isEmpty else {
                continue
            }

            attributes[property] = content
        }

        return attributes
    }
}
