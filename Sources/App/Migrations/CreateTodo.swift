import Fluent

struct CreateTodo: Migration {
    let model = Todo()

    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema(Todo.schema)
            .id()
            .field(model.$title.key, .string, .required)
            .field(model.$createdAt.field.key, .datetime)
            .field(model.$updatedAt.field.key, .datetime)
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema(Todo.schema).delete()
    }
}
