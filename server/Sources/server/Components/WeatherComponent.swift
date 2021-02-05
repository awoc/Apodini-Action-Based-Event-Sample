import Apodini
import NIO
import AsyncHTTPClient
import Foundation

struct WeatherComponent: Component {
    
    var content: some Component {
        Group("weather") {
            RetrieveWeather()
        }
    }
}

struct RetrieveWeather: Handler {
    @Environment(\.httpService) var httpService: HTTPService
    
    @Parameter var city: String
    @Parameter var country: String
    @Parameter var measurement: String
    
    @Throws(.badInput, reason: "Wrong Measurement") var badInput: ApodiniError

    func handle() throws -> EventLoopFuture<WeatherResponse> {
        guard let measurement = Measurement.init(rawValue: measurement) else {
            throw badInput
        }
    
        return httpService.getWeather(city: city, country: country, measurement: measurement)
    }
}
