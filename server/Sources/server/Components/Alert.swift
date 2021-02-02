import Apodini
import Fluent
import ApodiniDatabase
import Foundation
import NIO
import AsyncHTTPClient

struct AlertComponent: Component {
    var content: some Component {
        Group("alert") {
            RegisterAlert()
                .operation(.create)
            ReadAll<WeatherTracker>()
            DeleteAlert()
                .operation(.delete)
        }
    }
}

struct RegisterAlert: Handler {
    @Environment(\.database) var database: Database
    
    @Parameter var weatherTracker: WeatherTracker
    
    func handle() -> EventLoopFuture<WeatherTracker> {
        weatherTracker
            .save(on: database)
            .transform(to: weatherTracker)
    }
}

struct DeleteAlert: Handler {
    @Environment(\.database) var database: Database
    
    @Parameter(.http(.path)) var id: UUID
    
    @Throws(.notFound, reason: "Couldn't find object")
    var notFound: ApodiniError
    
    func handle() -> EventLoopFuture<String> {
        WeatherTracker
            .find(id, on: database)
            .unwrap(or: notFound)
            .flatMap { $0.delete(on: database ) }
            .transform(to: "Deleted" )
    }
}
