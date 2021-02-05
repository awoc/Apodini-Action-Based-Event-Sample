//
//  HeaderView.swift
//  Action Based Events Sample
//
//  Created by Alexander Collins on 03.02.21.
//

import SwiftUI

struct HeaderView: View {
    var weatherTracker: WeatherTracker
    
    @EnvironmentObject var model: ViewModel
    
    var body: some View {
        ZStack {
            BackgroundView()
                .frame(height: 120)
            VStack {
                HStack(alignment: .lastTextBaseline) {
                    Text(weatherTracker.city)
                        .font(.title)
                    Text(weatherTracker.country).foregroundColor(Color(UIColor.systemGray))
                }
                .padding(.bottom)
                Text(model.currentDate)
                    .foregroundColor(Color(UIColor.systemGray))

            }
        }.padding([.top, .leading, .trailing])
    }
}

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView(weatherTracker: Mocker.mockWeatherQuery()).environmentObject(Mocker.mockModel())
    }
}
