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
    case shows
    case sports
    case tech

    var synonims: [String] {
        switch self {
        case .economics:
            return ["business", "economia", "finanzas", "negocios"]

        case .international:
            return ["internacional", "internacionales", "mundo", "el-mundo", "new-york-times-international-weekly"]

        case .politics:
            return ["politica"]

        case .shows:
            return ["espectaculos", "famosos", "tvshow", "arts", "fama", "celebrities", "series-y-peliculas"]

        case .sports:
            return ["deportes", "el-deportivo", "futbol"]

        case .tech:
            return ["tecnologia"]
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
