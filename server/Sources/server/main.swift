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
        HTTPConfiguration()
            .address(.hostname("192.168.178.20", port: 8080))
        
        // Notifications
        DatabaseConfiguration(.defaultMongoDB("mongodb://localhost:27017/apodini_app"))
            .addMigrations(WeatherMigration())
            .addNotifications()
        APNSConfiguration(.pem(pemPath: apnsPath),
                          topic: Secrets.bundleIdentifier,
                          environment: .sandbox)
    }
}

let apnsPath = Bundle.module.path(forResource: "apns", ofType: "pem")!

try Server.main()
