import Fluent
import Vapor

func migrations(_ app: Application) throws {
    // MARK: User
    app.migrations.add(CreateUser())

    // MARK: Todo
    app.migrations.add(CreateTodo())
    app.migrations.add(UpdateTodoWithUserID())
    app.migrations.add(UpdateTodoWithStatus())
}
