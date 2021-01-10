import Vapor
import APNS
import Fluent

extension Request.APNS {
    func send<Notification>(_ notification: Notification, to device: Device) -> EventLoopFuture<Void> where Notification: APNSwiftNotification {
        guard let pushToken = device.pushToken else {
            return self.eventLoop.makeSucceededFuture(())
        }
        
        return send(notification, to: pushToken)
    }
    
    func send<Notification>(_ notification: Notification, toChannel channel: String, on db: Database) -> EventLoopFuture<Void> where Notification: APNSwiftNotification {
        send(notification, toChannels: [channel], on: db)
    }
    
    func send<Notification>(_ notification: Notification, toChannels channels: [String], on db: Database) -> EventLoopFuture<Void> where Notification: APNSwiftNotification {
        Device.pushTokens(for: channels, on: db)
            .flatMap { deviceTokens in
                deviceTokens.map {
                    self.send(notification, to: $0)
                }.flatten(on: self.eventLoop)
            }
    }
}

extension Request.APNS {
    func send(_ payload: APNSwiftPayload, to device: Device) -> EventLoopFuture<Void> {
        guard let pushToken = device.pushToken else {
            return self.eventLoop.makeSucceededFuture(())
        }
        
        return send(payload, to: pushToken)
    }
    
    func send(_ payload: APNSwiftPayload, toChannel channel: String, on db: Database) -> EventLoopFuture<Void> {
        send(payload, toChannels: [channel], on: db)
    }
    
    func send(_ payload: APNSwiftPayload, toChannels channels: [String], on db: Database) -> EventLoopFuture<Void> {
        Device.pushTokens(for: channels, on: db)
            .flatMap { deviceTokens in
                deviceTokens.map {
                    self.send(payload, to: $0)
                }.flatten(on: self.eventLoop)
            }
    }
}
