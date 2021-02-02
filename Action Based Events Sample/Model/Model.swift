//
//  Model.swift
//  Action Based Events Sample
//
//  Created by Alexander Collins on 31.01.21.
//

import Foundation
import Combine

public class Model: ObservableObject {
    @Published public var weatherQueries: [WeatherTracker] = []
    @Published public var weatherResponse: WeatherResponse?
    @Published public var shouldPresentView = false
    
    let restfulModel = RestfulModel()
    var subscriptions = Set<AnyCancellable>()
    
    var didChange = PassthroughSubject<Void, Never>()
    
    init() { }
    
    public func fetchData() {
        WeatherTracker
            .get()
            .sink(receiveCompletion: { completion in
                if case .failure = completion {
                    print("Error \(completion)")
                }
            },
            receiveValue: {
                self.weatherQueries = $0
            })
            .store(in: &subscriptions)
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
                self.weatherResponse = $0
                print($0)
                self.shouldPresentView = true
            })
            .store(in: &subscriptions)
    }
}
