//
//  Model.swift
//  Action Based Events Sample
//
//  Created by Alexander Collins on 31.01.21.
//

import Foundation
import Combine

public class ViewModel: ObservableObject {
    @Published public var weatherQueries: [WeatherTracker] = []
    @Published public var shouldPresentView = false
    @Published public var weatherMain: WeatherMain
    @Published public var temperature: Temperature
    @Published public var wind: Wind
    
    @Published public var icon: String
    
    let icons = [
        "01d": "sun.max.fill",
        "02d": "cloud.sun.fill",
        "03d": "cloud.fill",
        "04d": "smoke.fill",
        "09d": "cloud.drizzle.fill",
        "10d": "cloud.rain.fill",
        "11d": "cloud.bolt.rain.fill",
        "13d": "snow",
        "50d": "cloud.fog.fill",
        "01n": "moon.stars.fill",
        "02n": "cloud.moon.fill",
        "03n": "cloud.fill",
        "04n": "smoke.fill",
        "09n": "cloud.drizzle.fill",
        "10n": "cloud.rain.fill",
        "11n": "cloud.bolt.rain.fill",
        "13n": "snow",
        "50n": "cloud.fog.fill"
    ]
    
    let restfulModel = RestfulModel()
    public var subscriptions = Set<AnyCancellable>()
    
    let headerFormatter: DateFormatter
    let dateFormatter: DateFormatter
    let timeFormatter: DateFormatter
    
    var currentDate: String {
        headerFormatter.string(from: Date())
    }
    
    init() {
        weatherMain = WeatherMain(id: 0, main: "Empty", description: "Cloudy", icon: "default")
        temperature = Temperature(temp: 0.0, feels_like: 0.0, temp_min: 0.0, temp_max: 0.0, pressure: 0.0, humidity: 0)
        wind = Wind(speed: 5.6, deg: 129)
        
        headerFormatter = DateFormatter()
        headerFormatter.dateFormat = "EEEE, MMMM d"
        
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yy"
        
        timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        
        icon = "cloud.fill"
    }
    
    public func fetchData() -> Future<Void, Never> {
        Future { promise in
            WeatherTracker
                .get()
                .sink(receiveCompletion: { completion in
                    if case .failure = completion {
                        print("Error \(completion)")
                    }
                    promise(.success(()))
                },
                receiveValue: {
                    self.weatherQueries = $0
                    promise(.success(()))
                })
                .store(in: &self.subscriptions)
        }
    }
    
    public func save(_ weather: WeatherTracker) {
        weather
            .post()
            .sink(receiveCompletion: { completion in
                if case .failure = completion {
                    print("Error \(completion)")
                }
            },
            receiveValue: {
                self.weatherQueries.append($0)
            })
            .store(in: &subscriptions)
    }
    
    public func delete(_ index: Int) {
        let weatherQuery = weatherQueries[index]
        WeatherTracker
            .delete(id: weatherQuery.id)
            .sink(receiveCompletion: { completion in
                if case .failure = completion {
                    print("Error \(completion)")
                }
            },
            receiveValue: {
                self.weatherQueries.remove(at: index)
            })
            .store(in: &subscriptions)
    }
    
    public func getWeather(_ weatherTracker: WeatherTracker) {
        return restfulModel
            .getWeather(city: weatherTracker.city, country: weatherTracker.country, measurement: weatherTracker.measurement)
            .sink(receiveCompletion: { completion in
                if case .failure = completion {
                    print("Error \(completion)")
                }
            },
            receiveValue: {
                self.weatherMain = $0.weather[0]
                self.icon = self.icons[self.weatherMain.icon] ?? "snow"
                self.temperature = $0.main
                self.wind = $0.wind
                self.shouldPresentView = true
            })
            .store(in: &subscriptions)
    }
    
    func temperature(_ double: Double) -> String {
        return "\(Int(double))°"
    }
    
    func formatDate(_ date: Date) -> String {
        dateFormatter.string(from: date)
    }
    
    func formatTime(_ date: Date) -> String {
        timeFormatter.string(from: date)
    }
}
