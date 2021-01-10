import Vapor
import APNS

extension Application {
    
    func configurePush(privateKey: Data) throws {
        
        apns.configuration = try .init(
            authenticationMethod: .jwt(
                key: .private(pem: privateKey),
                keyIdentifier: "",
                teamIdentifier: ""
            ),
            topic: "com.raywenderlich.airplanespotter",
            environment: .sandbox
        )
    }
    
}
