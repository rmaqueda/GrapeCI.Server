import Fluent
import FluentSQLiteDriver
import Vapor

public func configure(_ app: Application) throws {
    app.databases.use(.sqlite(.file("GrapeCI.Server.sqlite")), as: .sqlite)
    
    app.migrations.add(CreateDevice())
    try app.autoMigrate().wait()
    
    try routes(app)
    
    let directory = app.directory.workingDirectory
    try app.configurePush()
}
