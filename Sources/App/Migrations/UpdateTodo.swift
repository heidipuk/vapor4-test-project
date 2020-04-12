import Fluent

struct UpdateTodo: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("todos")
            .field("userID", .uuid, .references("users", "id", onDelete: .cascade))
            .update()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("todos").deleteField("userID").update()
    }
}
