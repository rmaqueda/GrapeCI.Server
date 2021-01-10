import Fluent
import FluentSQLiteDriver
import Vapor

public func configure(_ app: Application) throws {
    app.databases.use(.sqlite(.file("GrapeCI.Server.sqlite")), as: .sqlite)
    
    app.migrations.add(CreateDevice())
    try app.autoMigrate().wait()
    
    try routes(app)
    
    let certificatePath = app.directory.workingDirectory + "Secrets/push_certificate.p8"
    let certificateURL = URL(fileURLWithPath: certificatePath)
    let keyData = try Data(contentsOf: certificateURL)
    try app.configurePush(privateKey: keyData)
}
