import Fluent

struct CreateUser: Migration {
    let model = User()

    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema(User.schema)
            .id()
            .field(model.$username.key, .string, .required)
            .unique(on: model.$username.key)
            .field(model.$createdAt.field.key, .datetime)
            .field(model.$updatedAt.field.key, .datetime)
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema(User.schema).delete()
    }
}
