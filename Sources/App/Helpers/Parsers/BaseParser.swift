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

    init(url: URL) throws {
        self.url = url
        self.html = try String(contentsOf: url, encoding: .utf8)
        self.document = try SwiftSoup.parse(html)
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
        fatalError("Subclasses need to implement this method")
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
