import Fluent
import Vapor

final class Device: Model, Content {
    public enum System: String, Codable {
        case iOS
        case android
    }
    
    static let schema = "devices"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "system")
    var system: System
    
    @Field(key: "os_version")
    var osVersion: String
    
    @Field(key: "push_token")
    var pushToken: String?
    
    @Field(key: "channels")
    var channels: String
    
    init() {}
    
    init(id: UUID? = nil, system: System, osVersion: String, pushToken: String?, channels: [String]? ) {
        self.id = id
        self.system = system
        self.osVersion = osVersion
        self.pushToken = pushToken
        self.channels = channels?.toChannelsString() ?? ""
    }
}

extension Device {
    class func pushTokens(for channels: [String], on db: Database) -> EventLoopFuture<[String]> {
        Device.query(on: db)
            .filter(\.$pushToken != nil)
            .group(.or) { builder in
                channels.forEach { builder.filter(\.$channels ~~ $0) }
            }
            .all(\Device.$pushToken)
            .map { $0.compactMap { $0 } }
    }
}

extension Array where Element == String {
    func toChannelsString() -> String {
        compactMap { $0.isEmpty ? nil : $0 }
            .map { $0.appending("\n") }
            .joined()
    }
}

extension Device {
    func toPublic() throws -> Device {
        .init(id: try requireID(),
              system: system,
              osVersion: osVersion,
              pushToken: pushToken,
              channels: channels.isEmpty ? [] : channels.components(separatedBy: "\n"))
    }
}

struct UpdateDevice: Codable {
    public let id: UUID?
    public let pushToken: String?
    public let system: Device.System
    public let osVersion: String
    public let channels: [String]?
    
    init(id: UUID? = nil, pushToken: String? = nil, system: Device.System, osVersion: String, channels: [String]? = nil) {
        self.id = id
        self.pushToken = pushToken
        self.system = system
        self.osVersion = osVersion
        self.channels = channels
    }
}
