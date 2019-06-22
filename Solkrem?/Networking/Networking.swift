//
//  Networking.swift
//  Solkrem?
//
//  Created by Rolf Kristian Andreassen on 22/06/2019.
//  Copyright © 2019 Rolf Kristian Andreassen. All rights reserved.
//

import Foundation

struct Networking {
    
    //appid={appid}&lat={lat}&lon={lon}&cnt={cnt}
    
    let baseURLUV = "http://api.openweathermap.org/data/2.5/uvi/forecast?"
    let baseURLForecast = "http://api.openweathermap.org/data/2.5/weather?"
    
    
    func getUVStatus(appID: String, latitude: String, longitude: String, completion: @escaping(WeatherUV) -> ()) {
        
        guard let url = URL(string: baseURLUV + "appid=\(appID)&lat=\(latitude)&lon=\(longitude)&cnt=1") else {return}
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if error != nil {
                print(error!.localizedDescription)
            } else {
               
                guard let data = data else {return}
                
                do {
                    let json = try JSONDecoder().decode([WeatherUV].self, from: data)
                    completion(json[0])
                } catch {
                    print("Unable to convert data to JSON. Error: \(error.localizedDescription)")
                }
            }
        }
        task.resume()
    }
    
    func getWeatherStatus(appID: String, latitude: String, longitude: String, completion: @escaping(WeatherForecast) -> ()) {
        guard let url = URL(string: baseURLForecast + "lat=\(latitude)&lon=\(longitude)&appid=\(appID)") else {return}

        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if error != nil {
                print(error!.localizedDescription)
            } else {
                
                guard let data = data else {return}
                
                do {
                    let json = try JSONDecoder().decode(WeatherForecast.self, from: data)
                    completion(json)
                } catch {
                    print("Unable to convert data to JSON. Error: \(error.localizedDescription)")
                }
            }
        }
        task.resume()
    }
    
    
}
