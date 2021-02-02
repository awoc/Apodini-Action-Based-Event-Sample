//
//  CellView.swift
//  Action Based Events Sample
//
//  Created by Alexander Collins on 31.01.21.
//

import SwiftUI

struct CellView: View {
    let flagService = FlagService()
    
    var query: WeatherTracker
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .lastTextBaseline) {
                Text(query.city)
                    .font(Font.system(size: 22, weight: .bold))
                    .padding(.trailing, 16)
                Spacer()
                Text(query.country)
                    .font(Font.system(size: 18, weight: .bold))
                    .foregroundColor(Color(UIColor.systemGray))
                Text(flagService.getFlag(query.country))
                    .font(Font.system(size: 18, weight: .bold))
            }
        }
    }
}

struct FlagService {
    let countries = [
        "Germany": "🇩🇪",
        "United Kingdom": "🇬🇧",
        "USA": "🇺🇸"
    ]
    
    public func getFlag(_ country: String) -> String {
        countries[country] ?? ""
    }
}

struct CellView_Previews: PreviewProvider {
    static var previews: some View {
        CellView(query: Mocker.mockWeatherQuery())
    }
}
