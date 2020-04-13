import Fluent

extension SchemaBuilder {
    func addIndex(toField fieldKey: FieldKey) -> Self {
        self.field(.custom("INDEX \(self.schema.schema)_\(fieldKey) (\(fieldKey))"))
    }

    func removeIndex(fromField fieldKey: FieldKey) -> Self {
        self.deleteField(.custom("INDEX \(self.schema.schema)_\(fieldKey)"))
    }
}
