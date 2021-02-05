//
//  WeatherDetailView.swift
//  Action Based Events Sample
//
//  Created by Alexander Collins on 02.02.21.
//

import SwiftUI

struct WeatherDetailView: View {
    var weatherTracker: WeatherTracker
    
    @EnvironmentObject var model: ViewModel
    
    var body: some View {
        ScrollView {
            ZStack {
                Color(UIColor.systemGray6).edgesIgnoringSafeArea(.all)
                VStack {
                    HeaderView(weatherTracker: weatherTracker)
                        .environmentObject(model)
                    NotificationView(weatherTracker: weatherTracker)
                        .environmentObject(model)
                    CurrentTemperatureView()
                        .environmentObject(model)
                    DetailTemperatureView()
                        .environmentObject(model)
                    OtherMeasurementView(weatherTracker: weatherTracker)
                        .environmentObject(model)
                    Spacer()
                }
            }
        }
       .onAppear {
            model.getWeather(weatherTracker)
        }
    }
}

struct WeatherDetailView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherDetailView(weatherTracker: Mocker.mockWeatherQuery()).environmentObject(Mocker.mockModel())
    }
}
