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
            return try BaseParser(url: url, select: "section.detail-body")

        case _ where host.contains("clarin.com"):
            return try BaseParser(
                url: url,
                select: "article.entry-body",
                rejectedClasses: ["related", "related ", "noticiaIndividual"]
            )

        case _ where host.contains("elpais.com.uy"):
            return try BaseParser(
                url: url,
                select: ".Page-content",
                rejectedClasses: ["contenido-exclusivo-nota", "Page-footer", "Page-tags", "Page-aside"]
            )

        case _ where host.contains("elmundo.es"):
            return try BaseParser(
                url: url,
                select: "div.ue-l-article__body.ue-c-article__body",
                encoding: .isoLatin1
            )

        case _ where host.contains("lanacion.com"):
            return try BaseParser(
                url: url,
                select: "section.cuerpo__nota",
                rejectedClasses: ["box-article", "box-articles  ", "mod-themes ", "mod-article"]
            )

        case _ where host.contains("pagina12.com"):
            return try BaseParser(url: url, select: "div.section-2-col.article-main-content")

        default:
            return nil
        }
    }
}
