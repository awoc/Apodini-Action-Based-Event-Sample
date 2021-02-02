import Notifications
import Jobs
import Apodini
import NIO
import Foundation
import ApodiniDatabase

struct Server: WebService {    
    var content: some Component {
        AlertComponent()
        Notifications()
        WeatherComponent()
    }
    
    var configuration: Configuration {
        EnvironmentObject(httpService, \Keys.httpService)
        HTTPConfiguration()
            .address(.hostname("192.168.178.20", port: 8080))
        
        // Notifications
        DatabaseConfiguration(.defaultMongoDB("mongodb://localhost:27017/apodini_app"))
            .addMigrations(WeatherMigration())
            .addNotifications()
        APNSConfiguration(.pem(pemPath: "/Users/awocatmac/Developer/Apodini-Alert-App/server/Certificates/apns.pem"),
                           topic: "de.tum.in.www1.ios.Action-Based-Events-Sample",
                           environment: .sandbox)
        FCMConfiguration("/Users/awocatmac/Developer/Action Based Events Sample/backend/Certificates/fcm.json")
    }
}

struct RetrieveWeather: Handler {
    @Environment(\Keys.httpService) var httpService: HTTPService
    
    @Parameter(.http)

    func handle() -> EventLoopFuture<WeatherResponse> {
        httpService.getWeather(city: "Munich", country: "Germany", measurement: .metric)
    }
}


struct Keys: EnvironmentAccessible {
    var httpService: HTTPService
}

let httpService = HTTPService(filePath: "/Users/awocatmac/Developer/Apodini-Alert-App/server/Certificates/secrets.json")

try Server.main()
