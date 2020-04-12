import Fluent
import Vapor

final class Todo: Model, Content {
    static let schema = "todos"
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: "title")
    var title: String

    @Parent(key: "userID")
    var user: User

    init() { }

    init(id: UUID? = nil, title: String, userID: UUID) {
        self.id = id
        self.title = title
        self.$user.id = userID
    }
}
