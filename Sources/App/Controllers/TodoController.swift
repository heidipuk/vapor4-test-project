import Fluent
import Vapor

struct TodoController {
    func index(req: Request) throws -> EventLoopFuture<[Todo]> {
        Todo.query(on: req.db).with(\.$user).all()
    }

    func get(req: Request) throws -> EventLoopFuture<Todo> {
        guard let todoID = req.parameters.get("todoID", as: UUID.self) else {
            throw Abort(.badRequest, reason: "Missing todoID in URL")
        }
        return Todo.query(on: req.db).with(\.$user)
            .filter(\.$id == todoID)
            .first()
            .unwrap(or: Abort(.notFound))
    }

    func create(req: Request) throws -> EventLoopFuture<Todo> {
        let todo = try req.content.decode(Todo.self)
        return todo.save(on: req.db).map { todo }
    }

    func update(req: Request) throws -> EventLoopFuture<Todo> {
        guard let todoID = req.parameters.get("todoID", as: UUID.self) else {
            throw Abort(.badRequest, reason: "Missing todoID in URL")
        }
        let updatedTodoRequestBody = try req.content.decode(UpdateTodoRequestBody.self)
        return Todo.query(on: req.db).with(\.$user)
            .filter(\.$id == todoID)
            .first()
            .unwrap(or: Abort(.notFound))
            .flatMap { todo in
                if let newTitle = updatedTodoRequestBody.newTitle, !newTitle.isEmpty {
                    todo.title = newTitle
                }

                if let newStatus = updatedTodoRequestBody.status {
                    todo.status = newStatus
                }

                return todo.save(on: req.db).transform(to: todo)
            }
    }

    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        Todo.find(req.parameters.get("todoID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .transform(to: .ok)
    }

    struct UpdateTodoRequestBody: Content {
        let newTitle: String?
        let status: TodoStatus?
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
