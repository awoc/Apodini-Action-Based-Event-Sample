import Fluent

// An example migration.
struct WeatherMigration: Migration {
    func prepare(on database: Fluent.Database) -> EventLoopFuture<Void> {
        database.eventLoop.flatten([
            database.schema(WeatherTracker.schema)
                .id()
                .field("city", .string, .required)
                .field("country", .string, .required)
                .field("measurement", .string, .required)
                .field("notification_interval", .string, .required)
                .field("date", .date, .required)
                .field("informing", .bool, .required)
                .field("temperature", .int, .required)
                .create()
        ])
    }
    
    func revert(on database: Fluent.Database) -> EventLoopFuture<Void> {
        database.eventLoop.flatten([
            database.schema(WeatherTracker.schema).delete()
        ])
    }
}
