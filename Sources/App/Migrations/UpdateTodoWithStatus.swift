import Fluent

struct UpdateTodoWithStatus: Migration {
    let model = Todo()

    func prepare(on database: Database) -> EventLoopFuture<Void> {
        let status = database.enum(String(describing: TodoStatus.self))
        _ = TodoStatus.allCases.map { status.case($0.rawValue) }

        return status.create().flatMap { todoStatus in
            database.schema(Todo.schema)
                .field(self.model.$status.field.key, todoStatus, .required)
                .update()
        }
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        let status = database.enum(String(describing: TodoStatus.self))

        return database.schema(Todo.schema)
            .deleteField(model.$status.field.key)
            .update()
            .and(status.delete())
            .transform(to: ())
    }
}
