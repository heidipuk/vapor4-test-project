import Vapor

extension Environment{
    static func assertGet(_ key: String) throws -> String {
        guard let value = Environment.get(key) else {
            fatalError("Missing environment value for \(key)")
        }
        return value
    }
}
