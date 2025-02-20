import Fluent
import Vapor

struct QuoteController: RouteCollection {
    private let quoteID = "quoteID"
    func boot(routes: RoutesBuilder) throws {
        let quotes = routes.grouped("quotes")
        quotes.get(use: index)
        quotes.post(use: create)
        quotes.group(":\(quoteID)") { quote in
            quote.put(use: update)
            quote.delete(use: delete)
        }
    }

    @Sendable
    func index(req: Request) async throws -> [Quote] {
        try await retry(logger: req.logger) {
            try await Quote.query(on: req.db).all()
        }
    }

    @Sendable
    func create(req: Request) async throws -> Quote {
        let quote = try req.content.decode(Quote.self)
        try await retry(logger: req.logger) {
            try await quote.create(on: req.db)
        }
        return quote
    }

    @Sendable
    func update(req: Request) async throws -> Quote {
        let id = try req.parameters.require(quoteID, as: UUID.self)
        let quote: Quote = try await findOrThrow(id, on: req.db, logger: req.logger)

        let updated = try req.content.decode(Quote.self)

        quote.text = updated.text
        quote.author = updated.author
        quote.category = updated.category

        try await retry(logger: req.logger) {
            try await quote.save(on: req.db)
        }
        return quote
    }

    @Sendable
    func delete(req: Request) async throws -> HTTPStatus {
        let id = try req.parameters.require(quoteID, as: UUID.self)
        let quote: Quote = try await findOrThrow(id, on: req.db, logger: req.logger)

        try await retry(logger: req.logger) {
            try await quote.delete(on: req.db)
        }
        return .noContent
    }
}
