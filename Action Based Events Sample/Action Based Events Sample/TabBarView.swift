//
//  TabBar.swift
//  Action Based Events Sample
//
//  Created by Alexander Collins on 31.01.21.
//

import SwiftUI

struct TabBarView: View {
    @EnvironmentObject var model: Model
    
    var body: some View {
        TabView {
            ListView()
                .environmentObject(model)
                .tabItem {
                    Image(systemName: "list.dash")
                    Text("Watchlist")
                }
            
            CreateAlertView()
                .tabItem {
                    Image(systemName: "square.and.pencil")
                    Text("Alert")
                }
        }
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}
