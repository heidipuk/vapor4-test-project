import Fluent
import Vapor

struct UserController {
    func index(req: Request) throws -> EventLoopFuture<[User]> {
        User.query(on: req.db).all()
    }

    func get(req: Request) throws -> EventLoopFuture<User> {
        guard let userID = req.parameters.get("userID", as: UUID.self) else {
            throw Abort(.badRequest)
        }

        return User.query(on: req.db)
            .filter(\.$id, .equal, userID)
            .with(\.$todos)
            .first()
            .unwrap(or: Abort(.notFound))
    }

    func create(req: Request) throws -> EventLoopFuture<User> {
        let user = try req.content.decode(User.self)
        return _get(userName: user.username, on: req.db)
            .isNil(or: Abort(.preconditionFailed, reason: "Username already taken"))
            .flatMap { _ in
                user.save(on: req.db).map { user }
            }
    }

    private func _get(userName: String, on database: Database) -> EventLoopFuture<User?> {
        User.query(on: database)
            .filter(\.$username, .equal, userName)
            .first()
    }
}

extension UserController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        routes.get("", use: index)
        routes.get(":userID", use: get)
        routes.post("", use: create)
    }
}
