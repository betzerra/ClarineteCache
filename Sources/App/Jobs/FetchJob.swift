//
//  FetchJob.swift
//  
//
//  Created by Ezequiel Becerra on 17/11/2022.
//

import Foundation
import Queues
import Vapor

struct FetchJob: AsyncScheduledJob {
    func run(context: Queues.QueueContext) async throws {
        do {
            _ = try await ClarineteCache.cacheTrends(application: context.application)
        } catch {
            // Log
            print(error.localizedDescription)
        }
    }
}
