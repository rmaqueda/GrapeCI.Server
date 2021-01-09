import FluentSQLite
import Vapor

final class User: SQLiteModel {
    typealias Database = SQLiteDatabase

    var id: Int?
    var name: String
    var email: String
    var pushToken: String

    init(id: Int? = nil, name: String, email: String, pushToken: String) {
        self.id = id
        self.name = name
        self.email = email
        self.pushToken = pushToken
    }
}

/// Allows `User` to be used as a dynamic migration.
extension User: Migration { }

/// Allows `User` to be encoded to and decoded from HTTP messages.
extension User: Content { }

/// Allows `User` to be used as a dynamic parameter in route definitions.
extension User: Parameter { }
