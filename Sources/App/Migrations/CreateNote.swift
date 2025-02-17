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

struct DropTodoTable: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("todos").delete()
    }

    func revert(on database: Database) async throws {
        // If you need to revert, this would recreate the table
        try await database.schema("todos")
            .id()
            .field("title", .string, .required)
            .create()
    }
}
