//
//  CreateAlertView.swift
//  Action Based Events Sample
//
//  Created by Alexander Collins on 31.01.21.
//

import SwiftUI
import Combine

struct CreateAlertView: View {
    @EnvironmentObject var model: Model
    
    @State var city = ""
    @State var country = ""
    
    @State var measurementPicker = Measurement.metric
    
    @State var intervalPicker = NotificationInterval.daily
    @State var date = Date()
    @State var toggle = true
    @State var temperature = "20"
    
    init() {
        //        UISegmentedControl.appearance().selectedSegmentTintColor = .blue
        //        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor : UIColor.white], for: .normal)
    }
    
    
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
                        .onChange(of: measurementPicker) {
                            switch $0 {
                            case .metric:
                                temperature = "20"
                            case .imperial:
                                temperature = "70"
                            }
                        }
                    }
                    Section(header: Text("Options")) {
                        Picker("Notification Interval", selection: $intervalPicker) {
                            Text("Daily").tag(NotificationInterval.daily)
                            Text("Weekly").tag(NotificationInterval.weekly)
                            Text("Date").tag(NotificationInterval.date)
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        
                        DatePicker("Date", selection: $date)
                        Toggle(isOn: $toggle) {
                            Text("Informing")
                        }
                        if !toggle {
                            TextField("Temperature", text: $temperature)
                                .keyboardType(.numberPad)
                                .onReceive(Just(temperature)) { newValue in
                                    let filtered = newValue.filter { "0123456789".contains($0) }
                                    if filtered != newValue {
                                        self.temperature = filtered
                                    }
                                }
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
    
    func send() {
        print("Saving")
        let temperature = Int(self.temperature) ?? 0
        let weatherTracker = WeatherTracker(city: city,
                                            country: country,
                                            measurement: measurementPicker,
                                            notificationInterval: intervalPicker,
                                            date: date,
                                            isInforming: toggle,
                                            temperature: temperature)
        model.save(weatherTracker)
    }
    
}

struct CreateAlertView_Previews: PreviewProvider {
    static var previews: some View {
        CreateAlertView().environmentObject(Mocker.mockModel())
    }
}
