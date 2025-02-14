import NIOSSL
import Fluent
import FluentMySQLDriver
import Leaf
import Vapor

func readSecret(from path: String) -> String? {
  do {
    let secretData = try String(contentsOfFile: path)
    return secretData.trimmingCharacters(in: .whitespacesAndNewlines)
  } catch {
    print("Error reading secret from \(path): \(error)")
    return nil
  }
}

// configures your application
public func configure(_ app: Application) async throws {
  print("HELLO HELLO")
  var tls = TLSConfiguration.makeClientConfiguration()
  tls.certificateVerification = .none

  // Access the environment variables for the secret file paths
  let dbUserFilePath = Environment.get("DATABASE_USER_FILE") ?? "/run/secrets/db_user"
  let dbPasswordFilePath = Environment.get("DATABASE_PASSWORD_FILE") ?? "/run/secrets/db_user_password"

  app.databases.use(.mysql(
    hostname: Environment.get("DATABASE_HOST") ?? "db",
    username: readSecret(from: dbUserFilePath) ?? "vapor",
    password: readSecret(from: dbPasswordFilePath) ?? "password",
    database: Environment.get("MYSQL_DATABASE") ?? "vapor_database",
    tlsConfiguration: tls
  ), as: .mysql)


  app.migrations.add(CreateTodo())

  try await app.autoMigrate().get()

  app.views.use(.leaf)


  // register routes
  try routes(app)
}