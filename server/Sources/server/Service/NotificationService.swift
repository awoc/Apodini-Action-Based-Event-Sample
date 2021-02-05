import Apodini
import Notifications

struct NotificationService {
    let notificationCenter: NotificationCenter
    
    init(notificationCenter: NotificationCenter) {
        self.notificationCenter = notificationCenter
    }
    
    func sendNotification(_ weatherTracker: WeatherTracker, _ currentWeather: WeatherResponse) {
        let temperature = Int(currentWeather.main.temp)
        let condition = currentWeather.weather[0].description
        let alert = Alert(title: "\(weatherTracker.city), \(weatherTracker.country)",
                          body: "The current temperature is \(temperature)° with \(condition)")

        let notification = Notification(alert: alert,
                                        payload: Payload(apnsPayload: APNSPayload(badge: 1, sound: .normal("default"))))
        
        notificationCenter.send(notification: notification, to: "general")
    }
}

extension Application {
    var notificationService: NotificationService {
        if let storedService = self.storage[NotificationServiceKey.self] {
            return storedService
        }
        let newService = NotificationService(notificationCenter: self.notificationCenter)
        self.storage[NotificationServiceKey.self] = newService
        
        return newService
    }
    
    struct NotificationServiceKey: StorageKey {
        typealias Value = NotificationService
    }
}
