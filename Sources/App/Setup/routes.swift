import Fluent
import Vapor

func routes(_ app: Application) throws {
    app.get { req in
        return "It works!"
    }

    app.get("hello") { req -> String in
        return "Hello, world!"
    }

    // MARK: Controllers
    let todoController = TodoController()
    let userController = UserController()

    // MARK: Routes
    let apiRoutes = app.grouped("api")
    try apiRoutes.grouped("todos").register(collection: todoController)
    try apiRoutes.grouped("users").register(collection: userController)
}
