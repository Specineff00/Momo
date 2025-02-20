import Fluent
import Vapor

struct NoteController: RouteCollection {
  private let noteID = "noteID"

  func boot(routes: RoutesBuilder) throws {
    let notes = routes.grouped("notes")
    notes.get(use: index)
    notes.post(use: create)
    notes.group(":\(noteID)") { note in
      note.delete(use: delete)
      note.put(use: update)
    }
  }

  @Sendable
  func index(req: Request) async throws -> [Note] {
    try await retry(logger: req.logger) {
      try await Note.query(on: req.db).all()
    }
  }

  @Sendable
  func create(req: Request) async throws -> Note {
    let note = try req.content.decode(Note.self)

    try await retry(logger: req.logger) {
      try await note.save(on: req.db)
    }
    return note
  }

  @Sendable
  func update(req: Request) async throws -> Note {

    let id = try req.parameters.require(noteID, as: UUID.self)
    let note: Note = try await findOrThrow(id, on: req.db, logger: req.logger)

    let updated = try req.content.decode(Note.self)

    note.text = updated.text
    note.category = updated.category
    note.priority = updated.priority

    try await retry(logger: req.logger) {
      try await note.save(on: req.db)
    }
    return note
  }

  @Sendable
  func delete(req: Request) async throws -> HTTPStatus {
    let id = try req.parameters.require(noteID, as: UUID.self)
    let note: Note = try await findOrThrow(id, on: req.db, logger: req.logger)

    try await retry(logger: req.logger) {
      try await note.delete(on: req.db)
    }
    return .noContent
  }
}
