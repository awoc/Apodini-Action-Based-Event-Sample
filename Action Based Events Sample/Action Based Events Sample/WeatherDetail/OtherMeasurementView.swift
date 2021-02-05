//
//  OtherMeasurementView.swift
//  Action Based Events Sample
//
//  Created by Alexander Collins on 03.02.21.
//

import SwiftUI

struct OtherMeasurementView: View {
    @EnvironmentObject var model: ViewModel
    
    var weatherTracker: WeatherTracker
    
    var body: some View {
        ZStack {
            BackgroundView()
                .frame(height: 80)
            VStack {
                HStack {
                    Image(systemName: "drop")
                        .resizable()
                        .frame(width: 15, height: 15)
                    Text("Humidity")
                    Spacer()
                    Text("\(model.temperature.humidity)%")
                }.padding([.leading, .trailing])
                HStack {
                    Image(systemName: "wind")
                        .resizable()
                        .frame(width: 20, height: 20)
                    Text("Wind")
                    Spacer()
                    Text(windSpeed)
                }.padding([.leading, .trailing])
            }
        }.padding([.top, .leading, .trailing])
    }
    
    var windSpeed: String{
        let speed = String(format: "%.3f", model.wind.speed)
        let unit = weatherTracker.measurement == .metric ? "M/s" : "M/h"
        return "\(speed) \(unit)"
    }
    
    
}

struct OtherMeasurementView_Previews: PreviewProvider {
    static var previews: some View {
        OtherMeasurementView(weatherTracker: Mocker.mockWeatherQuery()).environmentObject(Mocker.mockModel())
    }
}
