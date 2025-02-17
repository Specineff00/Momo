import Fluent

struct CreateNote: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("notes")
            .id()
            .field("text", .string, .required)
            .field("category", .string)
            .field("dateCreated", .datetime, .required)
            .field("priority", .int, .required)
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("notes").delete()
    }
}
