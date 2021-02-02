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
    public var date: String
    
    @Field(key: "informing")
    public var isInforming: Bool
    
    @Field(key: "temperature")
    public var temperature: Int?
    
    required public init() { }
    
    init(id: UUID? = nil, city: String, country: String, measurement: Measurement, notificationInterval: NotificationInterval, date: String, isInforming: Bool, temperature: Int? = nil) {
        self.id = id
        self.city = city
        self.country = country
        self.measurement = measurement
        self.notificationInterval = notificationInterval
        self.date = date
        self.isInforming = isInforming
        self.temperature = temperature
    }
    
    public func update(_ object: WeatherTracker) {
        
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
