//
//  File.swift
//  Momo
//
//  Created by Yogesh N Ramsorrun on 20/02/2025.
//

import FluentKit
import Logging
import Vapor

// Generic retry function
func retry<T>(
  config: RetryConfig = .default,
  logger: Logger,
  operation: @Sendable @escaping () async throws -> T
) async throws -> T {
  for attempt in 1...config.maxAttempts {
    do {
      return try await operation()
    } catch {
      guard attempt < config.maxAttempts,
            config.shouldRetry(error) else {
        throw error
      }

      // Exponential backoff with jitter
      let delay = min(
        config.maxDelay,
        config.baseDelay * pow(2.0, Double(attempt - 1))
      )
      let jitter = Double.random(in: 0...0.1)
      try await Task.sleep(nanoseconds: UInt64((delay + jitter) * 1_000_000_000))

      // Log retry attempt
      logger.warning("Retrying operation after failure (attempt \(attempt)/\(config.maxAttempts)): \(error.localizedDescription)")
    }
  }

  throw Abort(.internalServerError, reason: "Max retry attempts reached")
}
