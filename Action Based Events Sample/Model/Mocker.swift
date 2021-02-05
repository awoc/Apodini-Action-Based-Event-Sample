//
//  MockModel.swift
//  Action Based Events Sample
//
//  Created by Alexander Collins on 31.01.21.
//
import Foundation

public enum Mocker {
    public static func mockModel() -> ViewModel {
        let model = ViewModel()
        
        let query1 = WeatherTracker(id: UUID(),
                                    city: "Munich",
                                    country: "Germany",
                                    measurement: .metric,
                                    notificationInterval: .daily,
                                    date: Date(),
                                    dayOfWeek: 1,
                                    isInforming: true,
                                    condition: WeatherCondition.clear)
        let query2 = WeatherTracker(id: UUID(),
                                    city: "Berlin",
                                    country: "Germany",
                                    measurement: .metric,
                                    notificationInterval: .weekly,
                                    date: Date(),
                                    dayOfWeek: 1,
                                    isInforming: false,
                                    temperature: 0,
                                    condition: WeatherCondition.clear)
        let query3 = WeatherTracker(id: UUID(),
                                    city: "London",
                                    country: "United Kingdom",
                                    measurement: .imperial,
                                    notificationInterval: .date,
                                    date: Date(),
                                    dayOfWeek: 1,
                                    isInforming: false,
                                    temperature: 30,
                                    condition: WeatherCondition.clear)
        
        model.weatherQueries.append(query1)
        model.weatherQueries.append(query2)
        model.weatherQueries.append(query3)
        
        return model
    }
    
    public static func mockWeatherQuery() -> WeatherTracker {
        WeatherTracker(id: UUID(),
                       city: "Munich",
                       country: "Germany",
                       measurement: .metric,
                       notificationInterval: .daily,
                       date: Date(),
                       dayOfWeek: 1,
                       isInforming: true,
                       condition: WeatherCondition.clear)
    }
}
