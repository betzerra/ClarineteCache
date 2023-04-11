//
//  ParserFactory.swift
//  
//
//  Created by Ezequiel Becerra on 31/12/2022.
//

import Foundation

class ParserFactory {
    static func parser(from url: URL) throws -> Parser? {
        guard let host = url.host else {
            return nil
        }

        switch host {
        case _ where host.contains("ambito.com"):
            return try AmbitoParser(url: url)

        case _ where host.contains("clarin.com"):
            return try ClarinParser(url: url)

        case _ where host.contains("elpais.com.uy"):
            return try ElPaisParser(url: url)

        case _ where host.contains("lanacion.com"):
            return try LaNacionParser(url: url)

        case _ where host.contains("pagina12.com"):
            return try Pagina12Parser(url: url)

        default:
            return nil
        }
    }
}
