//
//  WeatherDetailView.swift
//  Action Based Events Sample
//
//  Created by Alexander Collins on 02.02.21.
//

import SwiftUI

struct WeatherDetailView: View {
    var weatherTracker: WeatherTracker
    
    @EnvironmentObject var model: Model
    
    var body: some View {
        VStack {
            if (model.shouldPresentView) {
                Text("\(model.weatherResponse?.main.temp ?? 0.0)")
            }
        }.onAppear {
            model.getWeather(weatherTracker)
        }.onDisappear {
            model.shouldPresentView = false
        }
    }
}

struct WeatherDetailView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherDetailView(weatherTracker: Mocker.mockWeatherQuery()).environmentObject(Mocker.mockModel())
    }
}
