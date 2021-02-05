//
//  TemperatureView.swift
//  Action Based Events Sample
//
//  Created by Alexander Collins on 03.02.21.
//

import SwiftUI

struct CurrentTemperatureView: View {
    @EnvironmentObject var model: ViewModel
    
    var body: some View {
        ZStack {
            BackgroundView()
                .frame(height: 220)
            VStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: 0) {
                HStack {
                    Image(systemName: model.icon)
                        .resizable()
                        .frame(width: 40, height: 40)
                    Text(model.weatherMain.description)
                }.padding(.top, 20)
                Text(model.temperature(model.temperature.temp))
                    .fontWeight(.light)
                    .font(.system(size: 120))
            }
        }
        .padding([.top, .leading, .trailing])
    }
}

extension CurrentTemperatureView {

}

struct TemperatureView_Previews: PreviewProvider {
    static var previews: some View {
        CurrentTemperatureView().environmentObject(Mocker.mockModel())
    }
}
