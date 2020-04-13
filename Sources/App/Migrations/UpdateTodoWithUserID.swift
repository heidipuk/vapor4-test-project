import Fluent

struct UpdateTodoWithUserID: Migration {
    let model = Todo()

    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema(Todo.schema)
            .field(model.$user.$id.key, .uuid, .required)
            .foreignKey(
                model.$user.$id.key,
                references: User.schema,
                User().$id.field.key
            )
            .addIndex(toField: model.$user.$id.key)
            .update()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema(Todo.schema)
            .removeIndex(fromField: model.$user.$id.key)
            .deleteField(model.$user.$id.key)
            .update()
    }
}
