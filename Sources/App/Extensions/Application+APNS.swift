import Vapor
import APNS

extension Application {
    
    func configurePush(privateKey: Data) throws {
        
        apns.configuration = try .init(
            authenticationMethod: .jwt(
                key: .private(pem: privateKey),
                keyIdentifier: "S6Z37UDA5H",
                teamIdentifier: "FZ32CY9FLM"
            ),
            topic: "es.molestudio.GrapeCI",
            environment: .sandbox
        )
    }
    
}
