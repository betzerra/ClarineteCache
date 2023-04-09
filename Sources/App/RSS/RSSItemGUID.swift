//
//  RSSItemGUID.swift
//  
//
//  Created by Ezequiel Becerra on 08/04/2023.
//

import Foundation
import XMLCoder

struct RSSItemGUID: Codable, DynamicNodeEncoding {
    let value: String
    let isPermalink: Bool

    enum CodingKeys: String, CodingKey {
        case value = ""
        case isPermalink
    }

    static func nodeEncoding(for key: CodingKey) -> XMLEncoder.NodeEncoding {
        switch key {
        case RSSItemGUID.CodingKeys.isPermalink:
            return .attribute
        default:
            return .element
        }
    }
}
