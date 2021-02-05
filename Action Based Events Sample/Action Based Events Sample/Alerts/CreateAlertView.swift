//
//  CreateAlertView.swift
//  Action Based Events Sample
//
//  Created by Alexander Collins on 31.01.21.
//

import SwiftUI
import Combine

struct CreateAlertView: View {
    @EnvironmentObject var model: ViewModel
    
    @State var city = ""
    @State var country = ""
    
    @State var measurementPicker = Measurement.metric
    
    @State var intervalPicker = NotificationInterval.daily
    @State var date = Date()
    @State var toggle = true
    @State var temperature = ""
    
    @State var dayOfWeek = 0
    
    @State var condition = WeatherCondition.rain
    
    let days = [
        "Sunday",
        "Monday",
        "Tuesday",
        "Wednesday",
        "Thursday",
        "Friday",
        "Saturday"
    ]
    
    var body: some View {
        VStack {
            NavigationView {
                Form {
                    Section(header: Text("Location")) {
                        TextField("City", text: $city)
                        TextField("Country", text: $country)
                    }
                    Section(header: Text("Unit")) {
                        Picker("Measurement", selection: $measurementPicker) {
                            Text("Celsius").tag(Measurement.metric)
                            Text("Fahrenheit").tag(Measurement.imperial)
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                    Section(header: Text("Notification Interval")) {
                        Picker("Notification Interval", selection: $intervalPicker) {
                            Text("Daily").tag(NotificationInterval.daily)
                            Text("Weekly").tag(NotificationInterval.weekly)
                            Text("Date").tag(NotificationInterval.date)
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        
                        switch intervalPicker {
                        case .daily:
                            DatePicker("Date", selection: $date, displayedComponents: .hourAndMinute).animation(nil)
                        case .weekly:
                            weeklyView
                        case .date:
                            DatePicker("Date", selection: $date, in: Date()...).animation(nil)
                        }
                    }
                    Section(header: Text("Options")) {
                        Toggle(isOn: $toggle) {
                            Text("Informing")
                        }
                        if !toggle {
                            Picker(selection: $condition, label: Text(condition.rawValue)) {
                                ForEach(WeatherCondition.allCases, id: \.self) { value in
                                    Text(value.rawValue).tag(value)
                                }
                            }.pickerStyle(MenuPickerStyle())
                            .animation(nil)
                        }
                    }
                }.navigationBarTitle("New Alert")
            }
            Button(action: {
                send()
            }, label: {
                PrimaryButton()
            }).padding(.bottom, 32)
        }
        .background(Color(UIColor.systemGray6))
    }
    
    var weeklyView: some View {
        Group {
            DatePicker("Date", selection: $date, displayedComponents: .hourAndMinute).animation(nil)
            Picker(selection: $dayOfWeek, label: Text(self.days[dayOfWeek])) {
                ForEach(0 ..< days.count) {
                    Text(self.days[$0])
                }
            }.pickerStyle(MenuPickerStyle())
            .animation(nil)
        }
    }
    
    func send() {
        let temperature = Int(self.temperature) ?? 0
        let weatherTracker = WeatherTracker(city: city,
                                            country: country,
                                            measurement: measurementPicker,
                                            notificationInterval: intervalPicker,
                                            date: date,
                                            dayOfWeek: dayOfWeek,
                                            isInforming: toggle,
                                            temperature: temperature,
                                            condition: condition)
        print("Sending \(weatherTracker)")
        model.save(weatherTracker)
    }
    
}

struct CreateAlertView_Previews: PreviewProvider {
    static var previews: some View {
        CreateAlertView().environmentObject(Mocker.mockModel())
    }
}
