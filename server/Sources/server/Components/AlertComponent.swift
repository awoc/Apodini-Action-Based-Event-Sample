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
            ReadAlerts()
            DeleteAlert()
                .operation(.delete)
        }
    }
}

struct RegisterAlert: Handler {
    @Environment(\.database) var database: Database
    @Environment(\.schedulingService) var schedulingService: SchedulingService
    
    @Parameter var dto: WeatherTrackerDTO
    
    @Throws(.badInput, reason: "Couldn't parse date")
    var badInput: ApodiniError
    
    // Using a DTO due to Date parsing problems
    func handle() throws -> EventLoopFuture<WeatherTrackerDTO> {
        guard let weatherTracker = dto.transform() else {
            throw badInput
        }

        return weatherTracker
            .save(on: database)
            .map {
                // Parameter is get only
                var response = dto
                response.id = weatherTracker.id
                
                self.schedulingService.add(weatherTracker)
                
                return response
            }
    }
}

struct ReadAlerts: Handler {
    @Environment(\.database) var database: Database
    
    func handle() -> EventLoopFuture<[WeatherTrackerDTO]> {
        WeatherTracker
            .query(on: database)
            .all()
            .mapEach { $0.transform() }
    }
}

struct DeleteAlert: Handler {
    @Environment(\.database) var database: Database
    @Environment(\.schedulingService) var schedulingService: SchedulingService
    
    @Parameter(.http(.path)) var id: UUID
    
    @Throws(.notFound, reason: "Couldn't find object")
    var notFound: ApodiniError
    
    func handle() -> EventLoopFuture<String> {
        WeatherTracker
            .find(id, on: database)
            .unwrap(or: notFound)
            .flatMap { weatherTracker -> EventLoopFuture<Void> in
                schedulingService.remove(weatherTracker)
                return weatherTracker.delete(on: database )
            }
            .transform(to: "Deleted")
    }
}
