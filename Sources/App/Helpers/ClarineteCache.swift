//
//  ClarineteCache.swift
//  
//
//  Created by Ezequiel Becerra on 17/11/2022.
//

import Foundation
import Redis
import Vapor

struct Trends: Codable {
    let timestamp: Date
    let trends: [Trend]

    static func empty() -> Trends {
        return Trends(timestamp: Date(), trends: [])
    }
}

enum ClarineteError: LocalizedError {
    case wrongRedisURL
    case emptyData

    var errorDescription: String? {
        switch self {
        case .emptyData:
            return "Data should never be empty"

        case .wrongRedisURL:
            return "Couldn't find any redis server at the URL specified"
        }
    }
}

class ClarineteCache {
    static func trends(_ application: Application, refresh: Bool) async throws -> Trends {
        guard refresh else {
            do {
                return try await ClarineteCache.cached(from: application.redis)
            } catch {
                application.logger.error("\(error.localizedDescription)")
                return Trends.empty()
            }
        }

        return try await ClarineteCache.fetch(application: application)
    }

    static func cached(from redis: RedisClient) async throws -> Trends {
        let redisKey = RedisKey("clarinete_trends")
        return try await redis.get(redisKey, asJSON: Trends.self) ?? Trends.empty()
    }

    static func fetch(application: Application) async throws -> Trends {
        let redisKey = RedisKey("clarinete_trends")

        let client = application.client
        let redis = application.redis

        // Fetch fresh data from source
        let uri = URI("https://clarinete.seppo.com.ar/api/trends")
        let trends = try await client.get(uri).content.decode(LossyCodableList<Trend>.self)

        guard trends.elements.count > 0 else {
            throw ClarineteError.emptyData
        }

        // Sort trends
        let sortedTrends = trends.elements.sorted { lhs, rhs in
            lhs.name.lowercased() < rhs.name.lowercased()
        }

        // Create a cache object (trends + timestamp)
        let fresh = Trends(timestamp: Date(), trends: sortedTrends)

        try await redis.set(redisKey, toJSON: fresh)
        return fresh
    }
}
