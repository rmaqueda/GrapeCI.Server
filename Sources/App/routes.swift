import Vapor

public func routes(_ router: Router) throws {

    router.get { _ in
        return "It works!"
    }

    let userController = UserController()
    router.get("users", use: userController.index)
    router.post("users", use: userController.create)
    router.delete("users", User.parameter, use: userController.delete)
}
