//
//  ContentView.swift
//  WeatherApp
//
//  Created by Aleksandr on 09/08/22.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @StateObject var locationManager = LocationManager()
    var weatherManager = WeatherManager()
    @State var weather: ResponseBody?
    var body: some View {
        VStack{
            
            if let location = locationManager.location {
                if let weather = weather {
                    WeatherView(weather: weather)
                } else {
                    LoadingView()
                        .task {
                            do {
                                weather = try await weatherManager.getCurrentWeather(latitude: location.latitude, longitude: location.longitude)
                                
                            } catch{
                                print("Error getting weather: \(error) ")
                            }
                        }
                }
            }else {
                if locationManager.isLoading{
                    LoadingView()
                }else {
                    WelcomeView()
                        .environmentObject(locationManager)
                }
            }
        }
        .background(Color(hue: 0.635, saturation: 0.451, brightness: 0.245))
        .preferredColorScheme(.dark)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
 
