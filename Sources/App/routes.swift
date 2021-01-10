import Fluent
import Vapor

func routes(_ app: Application) throws {
    let routeCollections: [RouteCollection] = [
        DeviceController()
    ]
    
    try routeCollections.forEach(app.routes.register)
}
