import Foundation
import AsyncHTTPClient
import NIO
import Apodini

struct HTTPService {
    let httpClient: HTTPClient
    let apiKey: String
    
    @Throws(.notFound, reason: "Couldn't find object") var requestError: ApodiniError
    
    init(filePath: String) {
        guard let data = FileManager.default.contents(atPath: filePath),
              let secrets = try? JSONDecoder().decode(Secrets.self, from: data)  else {
            fatalError("Could not find api Key")
        }
        self.apiKey = secrets.api
        httpClient = HTTPClient(eventLoopGroupProvider: .createNew)
    }
    
    func getWeather(city: String, country: String, measurement: Measurement) -> EventLoopFuture<WeatherResponse> {
        let url = "http://api.openweathermap.org/data/2.5/weather?q=\(city),\(country)&appid=\(apiKey)&units=metric"
        return httpClient
            .get(url: url)
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
