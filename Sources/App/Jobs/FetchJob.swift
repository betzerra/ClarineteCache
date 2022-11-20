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
        let logger = context.application.logger

        do {
            logger.info("FetchJob running")
            _ = try await ClarineteCache.fetch(application: context.application)
        } catch {
            logger.error("\(error.localizedDescription)")
        }
    }
}
