//
//  Element+Utils.swift
//  
//
//  Created by Ezequiel Becerra on 02/01/2023.
//

import Foundation
import SwiftSoup

extension Element {
    /// Returns sanitized elements that are allowed for read mode
    func readModeBodyElement() throws -> Element? {
        var element = self

        let allowedTags = ["h1", "h2", "h3", "h4", "h5", "h6", "p"]

        guard allowedTags.contains(tagName()) else {
            return nil
        }

        // These tags are reserved for article's title and subtitle
        let bigTitles = ["h1", "h2"]
        if bigTitles.contains(tagName()) {
            element = try element.tagName("h3")
        }

        return element
    }

    func remove(classNames: [String]) {
        let childrenToRemove = children().filter { $0.hasClassNames(classNames) }

        try? childrenToRemove.forEach { child in
            let html = (try? child.outerHtml()) ?? "N/A"
            try removeChild(child)
        }

        children().forEach { $0.remove(classNames: classNames) }
    }

    func hasClassNames(_ classNames: [String]) -> Bool {
        guard let name = try? className() else {
            return false
        }

        return classNames.contains(name)
    }
}
