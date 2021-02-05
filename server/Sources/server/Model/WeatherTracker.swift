import Foundation
import Apodini
import ApodiniDatabase

public class WeatherTracker: DatabaseModel {
    public static var schema = "weather_tracker"
    
    @ID(key: .id)
    public var id: UUID?
    
    @Field(key: "city")
    public var city: String
    
    @Field(key: "country")
    public var country: String
    
    @Enum(key: "measurement")
    public var measurement: Measurement
    
    @Enum(key: "notification_interval")
    public var notificationInterval: NotificationInterval
    
    @Field(key: "date")
    public var date: Date
    
    @Field(key: "day_of_week")
    public var dayOfWeek: Int
    
    @Field(key: "informing")
    public var isInforming: Bool
    
    @Field(key: "temperature")
    public var temperature: Int?
    
    @Field(key: "condition")
    public var condition: WeatherCondition
    
    required public init() { }
    
    init(id: UUID? = nil, city: String, country: String, measurement: Measurement, notificationInterval: NotificationInterval, date: Date, dayOfWeek: Int, isInforming: Bool, temperature: Int? = nil, condition: WeatherCondition) {
        self.id = id
        self.city = city
        self.country = country
        self.measurement = measurement
        self.notificationInterval = notificationInterval
        self.date = date
        self.dayOfWeek = dayOfWeek
        self.isInforming = isInforming
        self.temperature = temperature
        self.condition = condition
    }
    
    public func update(_ object: WeatherTracker) {
        
    }
    
    func transform() -> WeatherTrackerDTO {
        let dateFormatter = ISO8601DateFormatter()
        
        let date = dateFormatter.string(from: self.date) 
        
        return WeatherTrackerDTO(id: id,
                                 city: city,
                                 country: country,
                                 measurement: measurement,
                                 notificationInterval: notificationInterval,
                                 date: date,
                                 dayOfWeek: dayOfWeek,
                                 isInforming: isInforming,
                                 temperature: temperature,
                                 condition: condition)
    }
}

public enum Measurement: String, Codable {
    case metric
    case imperial
    
    var id: String { self.rawValue }
}

public enum NotificationInterval: String, Codable {
    case daily
    case weekly
    case date
    
    var id: String { self.rawValue }
}

public enum WeatherCondition: String, Codable {
    case thunderstorm = "Thunderstorm"
    case drizzle = "Drizzle"
    case rain = "Rain"
    case snow = "Snow"
    case atmosphere = "Atmosphere"
    case clear = "Clear"
    case clouds = "Clouds"
}

public struct WeatherTrackerDTO: Content, Codable {
    public var id: UUID?
    
    public var city: String
    public var country: String
    public var measurement: Measurement
    public var notificationInterval: NotificationInterval
    public var date: String
    public var dayOfWeek: Int
    public var isInforming: Bool
    public var temperature: Int?
    public var condition: WeatherCondition
    
    func transform() -> WeatherTracker? {
        let dateFormatter = ISO8601DateFormatter()
        
        guard let date = dateFormatter.date(from: self.date) else {
            return nil
        }
        
        return WeatherTracker(city: city,
                              country: country,
                              measurement: measurement,
                              notificationInterval: notificationInterval,
                              date: date,
                              dayOfWeek: dayOfWeek,
                              isInforming: isInforming,
                              temperature: temperature,
                              condition: condition)
    }
}
