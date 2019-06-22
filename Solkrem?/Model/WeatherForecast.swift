//
//  WeatherForecast.swift
//  Solkrem?
//
//  Created by Rolf Kristian Andreassen on 22/06/2019.
//  Copyright © 2019 Rolf Kristian Andreassen. All rights reserved.
//

import Foundation

struct WeatherForecast: Decodable {
    var weather: [Weather]?
    var main: Main
    
    struct Weather: Decodable {
        var id: Int?
        var main: String?
        var description: String?
        var icon: String?
    }
    
    struct Main: Decodable {
        var temp: Double?
        var pressure: Double?
        var humidity: Double?
        var temp_min: Double?
        var temp_max: Double?
        var sea_level: Double?
        var grnd_level: Double?
    }
}
