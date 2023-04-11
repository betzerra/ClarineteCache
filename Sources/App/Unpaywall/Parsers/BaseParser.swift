//
//  BaseParser.swift
//  
//
//  Created by Ezequiel Becerra on 31/12/2022.
//

import Foundation
import SwiftSoup

#if canImport(FoundationNetworking)
// Fixes "Fatal error: You must link or load module FoundationNetworking to load non-file: URL content using String(contentsOf:…)" on Linux
// See https://stackoverflow.com/a/58606520
import FoundationNetworking
#endif

class BaseParser: Parser {
    let url: URL
    let html: String
    let document: Document

    /// Specifies (as a CSS query) which part of the HTML should be parsed
    let select: String

    /// Specifies which parts should be removed from the scrapped HTML
    let rejectedClasses: [String]

    init(url: URL, select: String, rejectedClasses: [String] = [], encoding: String.Encoding = .utf8) throws {
        self.url = url
        self.html = try String(contentsOf: url, encoding: encoding)
        self.document = try SwiftSoup.parse(html)
        self.select = select
        self.rejectedClasses = rejectedClasses
    }

    func meta() throws -> PageMeta {
        guard let title = try metaTitle(),
              let description = try metaDescription() else {
            throw ParserError.missingData
        }

        return PageMeta(title: title, description: description)
    }

    // MARK: - Parser
    func page() throws -> Page {
        do {
            return Page(
                url: url,
                meta: try meta(),
                thumbnail: thumbnail(document: document),
                body: try body(document: document),
                html: html
            )
        } catch let error {
            print("Error: \(error)")
            throw error
        }
    }

    func thumbnail(document: SwiftSoup.Document) -> Thumbnail? {
        guard let element = try? document.select("meta[property=og:image]").first(),
              let image = try? element.attr("content"),
              let url = URL(string: image) else {
            return nil
        }

        let width = try? document
            .select("meta[property=og:image:width]")
            .attr("content")

        let height = try? document
            .select("meta[property=og:image:height]")
            .attr("content")

        guard let width, let height else {
            return Thumbnail(url: url, width: nil, height: nil)
        }

        return Thumbnail(url: url, width: Float(width), height: Float(height))
    }

    func body(document: Document) throws -> String {
        let article = try document.select(self.select)

        let allElements: [Element] = article.array()
        allElements.forEach { $0.remove(classNames: self.rejectedClasses) }

        let elements = try sanitizeBody(elements: allElements)

        return elements
            .compactMap { try? $0.outerHtml() }
            .joined(separator: "\n")
    }

    func sanitizeBody(elements: [Element]) throws -> [Element] {
        let filtered = try elements
            .flatMap { try $0.getAllElements() }
            .compactMap { try $0.readModeBodyElement() }

        return filtered
    }

    // MARK: - Private
    private func metaTitle() throws -> String? {
        return try document
            .select("meta[property=og:title]")
            .first()?
            .attr("content")
    }

    private func metaDescription() throws -> String? {
        return try document
            .select("meta[property=og:description]")
            .first()?
            .attr("content")
    }
}
