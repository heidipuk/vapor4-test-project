import Vapor

extension EventLoopFuture where Value: OptionalType {
    /// Unwraps an `Optional` values container inside a Future's expectation
    /// If the optional resolves to `value` (`.some`), the supplied error will be thrown instead.
    ///
    ///     print(futureString) //Future<String?>
    ///     futureString.isNil(or: MyError()) // Future<Void>
    ///
    /// - parameters:
    ///     - error: `Error` to throw if the value is `value`. This is captured with `@autoclosure`
    ///             to avoid initialize the `Error` unless needed.
    func isNil(or error: @autoclosure @escaping () -> Error) -> EventLoopFuture<Void> {
        return self.flatMapThrowing { optional -> Void in
            guard optional.wrapped == nil else {
                throw error()
            }
            return ()
        }
    }
}
