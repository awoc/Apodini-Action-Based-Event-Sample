//
//  DetailTemperatureView.swift
//  Action Based Events Sample
//
//  Created by Alexander Collins on 03.02.21.
//

import SwiftUI

struct DetailTemperatureView: View {
    @EnvironmentObject var model: ViewModel
    
    var body: some View {
        ZStack {
            BackgroundView()
                .frame(height: 100)
            VStack {
                HStack {
                    Text("Feels Like")
                    Spacer()
                    Text(model.temperature(model.temperature.feels_like))
                }.padding([.leading, .trailing])
                HStack {
                    Text("Max")
                    Spacer()
                    Text(model.temperature(model.temperature.temp_max))
                }.padding([.leading, .trailing])
                HStack {
                    Text("Min")
                    Spacer()
                    Text(model.temperature(model.temperature.temp_min))
                }.padding([.leading, .trailing])
            }
        }.padding([.top, .leading, .trailing])
    }
}

struct DetailTemperatureView_Previews: PreviewProvider {
    static var previews: some View {
        DetailTemperatureView().environmentObject(Mocker.mockModel())
    }
}
