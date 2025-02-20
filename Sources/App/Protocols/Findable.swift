import Fluent
import Foundation

protocol Findable {
    static var modelName: String { get }
    static func find(_ id: UUID?, on db: Database) async throws -> Self?
}
