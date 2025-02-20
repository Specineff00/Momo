import Fluent
import Foundation
import Vapor


final class Note: Model, Content, @unchecked Sendable {
  static let schema = "notes"

  @ID(key: .id)
  var id: UUID?

  @Field(key: "text")
  var text: String

  @Field(key: "category")
  var category: String?

  @Field(key: "dateCreated")
  var dateCreated: Date

  @Field(key: "priority")
  var priority: Int

  init() {}

  init(
    id: UUID,
    text: String,
    category: String? = nil,
    dateCreated: Date,
    priority: Int
  ) {
    self.id = id
    self.text = text
    self.category = category
    self.dateCreated = dateCreated
    self.priority = priority
  }
}

extension Note: Findable {
  static var modelName: String { String(describing: self) }
}
