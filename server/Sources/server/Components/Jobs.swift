import Jobs
import Apodini

struct WeatherAlert: Job {
    @Environment(\.httpService) var httpService: HTTPService
    @Environment(\.notificationService) var notificationService: NotificationService
    
    var tracker: WeatherTracker
    
    init(tracker: WeatherTracker) {
        self.tracker = tracker
    }
    
    func run() {
        _ = httpService
            .getWeather(city: tracker.city, country: tracker.country, measurement: tracker.measurement)
            .map { response in
                if tracker.isInforming {
                    notificationService.sendNotification(self.tracker, response)
                } else if tracker.condition.rawValue == response.weather[0].main {
                    notificationService.sendNotification(self.tracker, response)
                }
            }
    }
}
