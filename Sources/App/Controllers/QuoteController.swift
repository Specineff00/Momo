import Fluent
import Vapor

struct QuoteController: RouteCollection {
  func boot(routes: RoutesBuilder) throws {
    let quotes = routes.grouped("quotes")
    quotes.get(use: index)
    quotes.post(use: create)
    quotes.put(":quoteID", use: update)
    quotes.delete(":quoteID", use: delete)
  }

  @Sendable
  func index(req: Request) async throws -> [Quote] {
    try await Quote.query(on: req.db).all()
  }

  @Sendable
  func create(req: Request) async throws -> Quote {
    let quote = try req.content.decode(Quote.self)
    try await quote.create(on: req.db)
    return quote
  }

  @Sendable
  func update(req: Request) async throws -> Quote {
    guard let quote = try await Quote.find(req.parameters.get("quoteID"), on: req.db) else {
      throw Abort(.notFound)
    }
    let updated = try req.content.decode(Quote.self)
    quote.text = updated.text
    quote.author = updated.author
    quote.category = updated.category
    try await quote.save(on: req.db)
    return quote
  }

  @Sendable
  func delete(req: Request) async throws -> HTTPStatus {
    guard let quote = try await Quote.find(req.parameters.get("quoteID"), on: req.db) else {
      throw Abort(.notFound)
    }
    try await quote.delete(on: req.db)
    return .noContent
  }
}
