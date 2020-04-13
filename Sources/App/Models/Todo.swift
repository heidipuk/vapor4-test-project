import Fluent
import Vapor

final class Todo: Model, Content {
    static let schema = "todos"
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: "title")
    var title: String

    @Enum(key: "status")
    var status: TodoStatus

    @Parent(key: "userID")
    var user: User

    @Timestamp(key: "createdAt", on: .create)
    var createdAt: Date?

    @Timestamp(key: "updatedAt", on: .update)
    var updatedAt: Date?

    init() { }

    init(
        id: UUID? = nil,
        title: String,
        userID: UUID,
        status: TodoStatus = .planned
    ) {
        self.id = id
        self.title = title
        self.$user.id = userID
        self.status = status
    }
}

enum TodoStatus: String, CaseIterable, Codable, RawRepresentable {
    case planned
    case inProgress
    case migrated
    case done
    case deleted

    func isActive() -> Bool {
        switch self {
        case .planned, .inProgress, .migrated: return true
        case .done, .deleted: return false
        }
    }

    static func isActive(_ isActive: Bool = true) -> [Self] {
        switch isActive {
        case true: return [.planned, .inProgress, .migrated]
        case false: return [.done, .deleted]
        }
    }
}
