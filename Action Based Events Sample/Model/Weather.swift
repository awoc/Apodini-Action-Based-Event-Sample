//
//  Weather.swift
//  Action Based Events Sample
//
//  Created by Alexander Collins on 01.02.21.
//

import Foundation

public struct WeatherResponse: Codable {
    public var weather: [WeatherMain]
    public var main: Temperature
}

public struct WeatherMain: Codable {
    public var id: String
    public var main: String
    public var description: String
    public var icon: String
}

public struct Temperature: Codable {
    public var temp: Double
    public var feels_like: Double
    public var temp_min: Double
    public var temp_max: Double
    public var pressure: Double
    public var humidity: Int
}
