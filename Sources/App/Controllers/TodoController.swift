import Fluent
import Vapor

struct TodoController {
    func index(req: Request) throws -> EventLoopFuture<[Todo]> {
        return Todo.query(on: req.db).all()
    }

    func get(req: Request) throws -> EventLoopFuture<Todo> {
        let todoID = req.parameters.get("todoID", as: UUID.self)
        return Todo.find(todoID, on: req.db).unwrap(or: Abort(.notFound))
    }

    func create(req: Request) throws -> EventLoopFuture<Todo> {
        let todo = try req.content.decode(Todo.self)
        return todo.save(on: req.db).map { todo }
    }

    func update(req: Request) throws -> EventLoopFuture<Todo> {
        let todoID = req.parameters.get("todoID", as: UUID.self)
        let updatedTodoRequestBody = try req.content.decode(UpdateTodoRequestBody.self)
        return Todo
            .find(todoID, on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { todo in
                todo.title = updatedTodoRequestBody.newTitle
                return todo.update(on: req.db).transform(to: todo)
            }
    }

    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        return Todo.find(req.parameters.get("todoID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .transform(to: .ok)
    }

    struct UpdateTodoRequestBody: Content {
        let newTitle: String
    }
}

extension TodoController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        routes.get("", use: index)
        routes.get(":todoID", use: get)
        routes.post("", use: create)
        routes.patch(":todoID", use: update)
        routes.delete(":todoID", use: delete)
    }
}
