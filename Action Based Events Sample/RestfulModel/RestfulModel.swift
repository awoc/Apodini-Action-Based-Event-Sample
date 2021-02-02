//
//  RestfulModel.swift
//
//  Created by Paul Schmiedmayer on 03/14/20.
//  Copyright © 2020 TUM LS1. All rights reserved.
//

import Foundation
import Combine


// MARK: RestfulModel
public class RestfulModel {
    public init() { }
    
    /// The base route that is used to access the RESTful server
    static var baseURL: URL = {
        guard let baseURL = URL(string: "http://192.168.178.20:8080/v1") else {
            fatalError("Could not create the base URL for the Server")
        }
        return baseURL
    }()
    
    static var apnsURL: URL = {
        return baseURL.appendingPathComponent("notifications/device/")
    }()
    
    static var weatherURL: URL = {
        return baseURL.appendingPathComponent("weather/")
    }()
    
    public func register(device: Device) {
        let route = RestfulModel.apnsURL
        NetworkManager.post(device, on: route)
    }
    
    public func getWeather(city: String, country: String, measurement: Measurement) -> AnyPublisher<WeatherResponse, Error> {
        let route = RestfulModel.weatherURL.appendingPathComponent("?city=\(city)&country=\(country)&measurement=\(measurement.rawValue)")
        return NetworkManager.get(on: route, WeatherResponse.self)
    }
}
