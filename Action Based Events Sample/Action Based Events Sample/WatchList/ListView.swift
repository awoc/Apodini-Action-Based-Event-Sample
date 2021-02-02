//
//  ListView.swift
//  Action Based Events Sample
//
//  Created by Alexander Collins on 31.01.21.
//

import SwiftUI

struct ListView: View {
    @EnvironmentObject var model: Model
    
    var queries: [WeatherTracker] {
        model.weatherQueries
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(queries) { query in
                    NavigationLink(destination: WeatherDetailView(weatherTracker: query).environmentObject(model)) {
                        CellView(query: query)
                    }
                }.onDelete(perform: delete(at:))
                
            }.navigationBarTitle("Watch List")
        }
    }
    
    private func delete(at indexSet: IndexSet) {
        indexSet
            .forEach {
                self.model.delete($0)
            }
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView().environmentObject(Mocker.mockModel())
    }
}
