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

class ClarineteCache {
    static func trends(from redis: RedisClient) async throws -> Trends {
        let redisKey = RedisKey("clarinete_trends")
        return try await redis.get(redisKey, asJSON: Trends.self) ?? Trends.empty()
    }

    static func cacheTrends(application: Application) async throws -> Trends {
        let redisKey = RedisKey("clarinete_trends")

        let client = application.client
        let redis = application.redis

        // Fetch fresh data from source
        let uri = URI("https://clarinete.seppo.com.ar/api/trends")
        let trends = try await client.get(uri).content.decode([Trend].self)

        // Sort trends
        let sortedTrends = trends.sorted { lhs, rhs in
            lhs.name.lowercased() < rhs.name.lowercased()
        }

        // Create a cache object (trends + timestamp)
        let fresh = Trends(timestamp: Date(), trends: sortedTrends)

        try await redis.set(redisKey, toJSON: fresh)
        return fresh
    }
}
