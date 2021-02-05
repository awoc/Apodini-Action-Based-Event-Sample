//
//  NotificationView.swift
//  Action Based Events Sample
//
//  Created by Alexander Collins on 04.02.21.
//

import SwiftUI

struct NotificationView: View {
    @EnvironmentObject var model: ViewModel
    
    var weatherTracker: WeatherTracker
    
    
    let days = [
        "Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"
    ]
    
    var body: some View {
        ZStack {
            BackgroundView()
                .frame(height: 80)
            VStack {
                HStack {
                    Image(systemName: "calendar")
                        .resizable()
                        .frame(width: 15, height: 15)
                    Text("Notification")
                    Spacer()
                    notificationBody
                }.padding([.leading, .trailing])
                HStack {
                    Image(systemName: "wand.and.stars")
                        .resizable()
                        .frame(width: 15, height: 15)
                    Text("Condition")
                    Spacer()
                    if weatherTracker.isInforming {
                        Text("Informing")
                    } else {
                        Text(weatherTracker.condition.rawValue)
                    }
                }.padding([.leading, .trailing])
            }
        }.padding([.top, .leading, .trailing])
    }
    
    
    var notificationBody: some View {
        switch weatherTracker.notificationInterval {
        case .daily:
            return Text("Everyday at \(model.formatTime(weatherTracker.date))")
        case .weekly:
            return Text("\(dayOfWeek(weatherTracker.dayOfWeek)). at \(model.formatTime(weatherTracker.date))")
        case .date:
            return Text("\(model.formatDate(weatherTracker.date)) at \(model.formatTime(weatherTracker.date))")
        }
    }
    
    func dayOfWeek(_ num: Int) -> String {
        days[num]
    }
}


struct NotificationView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationView(weatherTracker: Mocker.mockWeatherQuery()).environmentObject(Mocker.mockModel())
    }
}
