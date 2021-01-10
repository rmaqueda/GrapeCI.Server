import Fluent

struct CreateDevice: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema(Device.schema)
            .id()
            .field("push_token", .string)
            .field("os_version", .string, .required)
            .field("system", .string, .required)
            .field("channels", .string, .required)
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema(Device.schema).delete()
    }
}
