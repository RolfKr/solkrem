//
//  Sunscreen.swift
//  Solkrem?
//
//  Created by Rolf Kristian Andreassen on 22/06/2019.
//  Copyright © 2019 Rolf Kristian Andreassen. All rights reserved.
//

import Foundation

struct WeatherCondition {

    func getUVStatus(condition: Double) -> String {
        
        switch condition {
            
        case 0.0...2.9:
            return "Lav"
        case 3.0...5.9:
            return "Moderat"
        case 6.0...7.9:
            return "Høy"
        case 8.0...10.9:
            return "Svært Høy"
        case 11.0...99.9:
            return "Ekstrem"
            
        default:
            return "Ekstrem"
        }
    }
    
    func getSunTips(status: String) -> String {
        switch status {
            
        case "Lav":
            return "Ingen fare for UV stråler. Gå ut og nyt solen!"
        case "Moderat":
            return "Klær, solhatt og solbriller gir deg god beskyttelse. Ta deg en pause i skyggen, eller bruk solkrem."
        case "Høy":
            return "Mellom klokken 12:00 til 15:00 tar solen sterkest, ta deg i så tilfelle en pause i skyggen. Bruk solkrem med faktor 15 eller oppover"
        case "Svært Høy":
            return "Unngå solen mellom klokken 12:00 til 15:00, ta deg heller en pause i skyggen. Kle deg godt for å beskytte deg mot solen og bruk solkrem med faktor 15 eller oppover"
        case "Ekstrem":
            return "Unngå solen mellom klokken 12:00 til 15:00, ta deg heller en pause i skyggen. Kle deg godt for å beskytte deg mot solen og smør deg ofte med solkrem. Bruk faktor 15 eller oppover."
       
        default:
            return "x"
        }
    }
    
    func getWeatherCondition(id: Int) -> String {
        
        switch id {
            
        case 200...299:
            return "thunderstorm"
        case 300...399:
            return "drizzle"
        case 500...599:
            return "rain"
        case 600...699:
            return "snow"
        case 700...799:
            return "atmosphere"
        case 800:
            return "clear"
        case 801...899:
            return "clouds"
        
        default:
            return ""
        }
    }
}


