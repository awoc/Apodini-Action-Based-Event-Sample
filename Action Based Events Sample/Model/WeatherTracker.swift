import Foundation

public struct WeatherTracker: Codable, Identifiable {
    public var id: UUID?
    
    public var city: String
    public var country: String
    public var measurement: Measurement
    public var notificationInterval: NotificationInterval
    public var date: Date
    public var isInforming: Bool
    public var temperature: Int?
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

extension WeatherTracker: Restful {
    static var route: URL {
        return RestfulModel.baseURL.appendingPathComponent("alert/")
    }
}
