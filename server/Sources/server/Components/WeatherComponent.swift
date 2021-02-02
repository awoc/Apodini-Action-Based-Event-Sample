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
