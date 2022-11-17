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
}

class ClarineteCache {
    static func trends(req: Request) async throws -> Trends {
        guard let trends = try? await fetchTrends(req: req) else {
            return await fallbackTrends(req: req)
        }

        return trends
    }

    static func fallbackTrends(req: Request) async -> Trends {
        let backupKey = RedisKey("clarinete_trends_backup")

        guard let trends = try? await req.redis.get(backupKey, asJSON: Trends.self) else {
            return Trends(timestamp: Date(), trends: [])
        }

        return trends
    }

    static func fetchTrends(req: Request) async throws -> Trends {
        let redisKey = RedisKey("clarinete_trends")
        let backupKey = RedisKey("clarinete_trends_backup")

        guard let cached = try await req.redis.get(redisKey, asJSON: Trends.self) else {
            // Fetch fresh data from source
            let uri = URI("https://clarinete.seppo.com.ar/api/trends")
            let trends = try await req.client.get(uri).content.decode([Trend].self)

            // Sort trends
            let sortedTrends = trends.sorted { lhs, rhs in
                lhs.name.lowercased() < rhs.name.lowercased()
            }

            // Create a cache object (trends + timestamp)
            let fresh = Trends(timestamp: Date(), trends: sortedTrends)

            // Cache response
            try await req.redis.setex(redisKey, toJSON: fresh, expirationInSeconds: 300)

            // Cache it without expiration, this will be used later if:
            // 1. Key above is expired, and...
            // 2. Request above to Seppo's server is unavailable
            try await req.redis.set(backupKey, toJSON: fresh)
            return fresh
        }

        return cached
    }
}
