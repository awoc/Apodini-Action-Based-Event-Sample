//
//  ListView.swift
//  Action Based Events Sample
//
//  Created by Alexander Collins on 31.01.21.
//

import SwiftUI
import SwiftUIRefresh

struct ListView: View {
    @EnvironmentObject var model: ViewModel
    
    @State private var isShowing = false
    
    init() {
        UITableView.appearance().separatorStyle = .none
        UITableViewCell.appearance().backgroundColor = UIColor.systemGray6
        UITableView.appearance().backgroundColor = UIColor.systemGray6
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(model.weatherQueries) { query in
                    NavigationLink(destination: WeatherDetailView(weatherTracker: query).environmentObject(model)) {
                        CellView(query: query)
                    }
                }.onDelete(perform: delete(at:))
            }.pullToRefresh(isShowing: $isShowing) {
                model
                    .fetchData()
                    .first()
                    .sink { self.isShowing = false }
                    .store(in: &model.subscriptions)
            }
            .navigationBarTitle("Watch List")
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
