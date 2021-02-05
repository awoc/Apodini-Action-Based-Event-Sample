import Apodini

public struct WeatherResponse: Content, Codable {
    public var weather: [WeatherMain]
    public var main: Temperature
    public var wind: Wind
}

public struct WeatherMain: Content, Codable {
    public var id: Int
    public var main: String
    public var description: String
    public var icon: String
}

public struct Temperature: Content, Codable {
    public var temp: Double
    public var feels_like: Double
    public var temp_min: Double
    public var temp_max: Double
    public var pressure: Double
    public var humidity: Int
}

public struct Wind: Content, Codable {
    public var speed: Double
    public var deg: Int
}
