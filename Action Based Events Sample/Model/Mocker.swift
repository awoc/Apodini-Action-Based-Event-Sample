//
//  MockModel.swift
//  Action Based Events Sample
//
//  Created by Alexander Collins on 31.01.21.
//
import Foundation

public enum Mocker {
    public static func mockModel() -> Model {
        let model = Model()
        
        let query1 = WeatherTracker(id: UUID(),
                                  city: "Munich",
                                  country: "Germany",
                                  measurement: .metric,
                                  notificationInterval: .daily,
                                  date: Date(),
                                  isInforming: true)
        let query2 = WeatherTracker(id: UUID(),
                                  city: "Berlin",
                                  country: "Germany",
                                  measurement: .metric,
                                  notificationInterval: .weekly,
                                  date: Date(),
                                  isInforming: false,
                                  temperature: 0)
        let query3 = WeatherTracker(id: UUID(),
                                  city: "London",
                                  country: "United Kingdom",
                                  measurement: .imperial,
                                  notificationInterval: .date,
                                  date: Date(),
                                  isInforming: false,
                                  temperature: 30)
        
        model.weatherQueries.append(query1)
        model.weatherQueries.append(query2)
        model.weatherQueries.append(query3)
        
        return model
    }
    
    public static func mockWeatherQuery() -> WeatherTracker {
        WeatherTracker(id: UUID(), city: "Munich", country: "Germany", measurement: .metric, notificationInterval: .daily, date: Date(), isInforming: true)
    }
}
