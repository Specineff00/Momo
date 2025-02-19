import Fluent
import Vapor

final class Quote: Model, Content, @unchecked Sendable {
    static let schema = "quotes"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "text")
    var text: String

    @Field(key: "author")
    var author: String?

    @Field(key: "category")
    var category: String

    init() {}

    init(
      id: UUID? = nil,
      text: String,
      author: String? = nil,
      category: String = "Inspiration"
    ) {
        self.id = id
        self.text = text
        self.author = author
        self.category = category
    }
}
