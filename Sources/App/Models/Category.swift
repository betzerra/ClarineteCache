//
//  Category.swift
//  
//
//  Created by Ezequiel Becerra on 09/12/2022.
//

import Foundation

enum Category: String, CaseIterable, Codable {
    case economics
    case international
    case politics
    case sports
    case tech

    var synonims: [String] {
        switch self {
        case .economics:
            return ["business", "economia"]

        case .international:
            return ["internacional", "internacionales", "mundo"]

        case .politics:
            return ["politica"]

        case .sports:
            return ["deportes"]

        case .tech:
            return ["tecnologia"]
        }
    }

    var display: String {
        switch self {
        case .economics:
            return "Economía"

        case .international:
            return "Internacionales"

        case .politics:
            return "Política"

        case .sports:
            return "Deportes"

        case .tech:
            return "Tecnología"
        }
    }

    static func from(word: String) -> Category? {
        for element in self.allCases {
            if element.synonims.contains(word) {
                return element
            }
        }

        return nil
    }

    static func from(url: URL) -> Category? {
        url.pathComponents.compactMap { Category.from(word: $0) }.first
    }
}
