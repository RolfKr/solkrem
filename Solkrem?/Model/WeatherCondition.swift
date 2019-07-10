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
            return "Ingen beskyttelse nødvendig."
        case "Moderat":
            return "Beskyttelse kan være nødvendig. Klær, hodeplagg og solbriller gir god beskyttelse. Husk også solkrem. SPF 15 ved direkte sollys eller ved vannet."
        case "Høy":
            return "Beskyttelse er nødvendig. Begrens tiden i solen midt på dagen. Bruk klær, hodeplagg, solbriller og smør deg med solkrem med høy faktor. SPF 15 ved direkte sollys eller ved vannet."
        case "Svært Høy":
            return "Ekstra beskyttelse er nødvendig. Unngå solen midt på dagen og søk skygge. Bruk klær, hodeplagg, solbriller og smør deg ofte med solkrem med høy eller svært høy faktor. SPF 30 er anbefalt om man er ute mellom 12:00 og 16:00"
        case "Ekstrem":
            return "Ekstra beskyttelse er absolutt nødvendig. Unngå solen og søk skygge midt på dagen. Om du skal ferdes ute anbefales det at man dekker seg til og SPF 30 eller høyere"
       
        default:
            return "x"
        }
    }
    
    func getWeatherCondition(id: Int) -> String {
        
        switch id {
            
        case 200...299:
            return "thunderstorm"
        case 300...399:
            return "rain"
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
            return "clear"
        }
    }
}


