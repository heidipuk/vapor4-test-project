import Fluent
import FluentMySQLDriver
import Vapor

// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    app.databases.use(try .mysql(
        hostname: Environment.assertGet("DATABASE_HOST"),
        username: Environment.assertGet("DATABASE_USERNAME"),
        password: Environment.assertGet("DATABASE_PASSWORD"),
        database: Environment.assertGet("DATABASE_NAME"),
        tlsConfiguration: nil // TODO: should only have this config for localhost...
    ), as: .mysql)

    app.migrations.add(CreateUser())
    app.migrations.add(CreateTodo())
    app.migrations.add(UpdateTodo())

    // register routes
    try routes(app)
}
