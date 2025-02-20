import Foundation
import Fluent

struct RetryConfig: Sendable {
  let maxAttempts: Int
  let baseDelay: TimeInterval
  let maxDelay: TimeInterval
  let shouldRetry: @Sendable (Error) -> Bool

  static let `default` = RetryConfig(
    maxAttempts: 3,
    baseDelay: 0.1, // 100ms
    maxDelay: 2.0,  // 2 seconds
    shouldRetry: { error in
      // Only retry specific errors
      switch error {
      case let dbError as DatabaseError where dbError.isConnectionClosed: return true
      default: return false
      }
    }
  )
}
