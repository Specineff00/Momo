import Foundation
import Vapor
import Fluent

// Reusable error handling function
func findOrThrow<T: Findable>(
  _ id: UUID?,
  on db: Database,
  logger: Logger
) async throws -> T {
  do {
    // Wrap in retry
    return try await retry(logger: logger) {
      let item = try await T.find(id, on: db)

      guard let item else {
        logger.notice("\(T.modelName) not found", metadata: [
          "id": .string(id?.uuidString ?? "unknown")
        ])
        throw Abort(.notFound, reason: "\(T.modelName) not found")
      }
      return item
    }

  } catch let error where error is DatabaseError {
    logger.error("Database error", metadata: [
      "error": .string(error.localizedDescription),
      "operation": .string("find_\(T.modelName)"),
      "id": .string(id?.uuidString ?? "unknown")
    ])
    throw error
  } catch {
    logger.error("Unexpected error", metadata: [
      "error": .string(error.localizedDescription),
      "type": .string(String(describing: type(of: error))),
      "model": .string(T.modelName)
    ])
    throw error
  }
}
