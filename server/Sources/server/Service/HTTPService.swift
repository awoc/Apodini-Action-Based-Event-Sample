import Foundation
import AsyncHTTPClient
import NIO
import Apodini

struct HTTPService {
    let httpClient: HTTPClient
    let apiKey: String
    let baseURL: String
    
    @Throws(.notFound, reason: "Couldn't find object") var requestError: ApodiniError
    
    init(app: Application) {
        self.apiKey = Secrets.api
        self.baseURL = "http://api.openweathermap.org/data/2.5/weather"
        httpClient = HTTPClient(eventLoopGroupProvider: .shared(app.eventLoopGroup))
    }
    
    func getWeather(city: String, country: String, measurement: Measurement) -> EventLoopFuture<WeatherResponse> {
        guard var urlComponent = URLComponents(string: baseURL) else {
            fatalError("Couldn't create URL")
        }
        let queryCity = URLQueryItem(name: "q", value: "\(city),\(country)")
        let queryAPIKey = URLQueryItem(name: "appid", value: apiKey)
        let queryMeasurement = URLQueryItem(name: "units", value: measurement.rawValue)
        
        urlComponent.queryItems = [queryCity, queryAPIKey, queryMeasurement]

        return httpClient
            .get(url: urlComponent.string!)
            .flatMapThrowing { response -> WeatherResponse in

                guard response.status == .ok, let body = response.body else {
                    throw requestError
                }
                let decoder = JSONDecoder()
                let weatherResponse = try decoder.decode(WeatherResponse.self, from: body)
                return weatherResponse
            }
            
    }
}

extension Application {
    var httpService: HTTPService {
        if let storedHTTPService = self.storage[HTTPConfigurationKey.self] {
            return storedHTTPService
        }
        let newHTTPService = HTTPService(app: self)
        self.storage[HTTPConfigurationKey.self] = newHTTPService
        
        return newHTTPService
    }
    
    struct HTTPConfigurationKey: StorageKey {
        typealias Value = HTTPService
    }
}
