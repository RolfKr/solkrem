//
//  Location.swift
//  Solkrem?
//
//  Created by Rolf Kristian Andreassen on 22/06/2019.
//  Copyright © 2019 Rolf Kristian Andreassen. All rights reserved.
//

import Foundation

struct Location {
    var latitude: Double?
    var longitude: Double?
    
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
}

struct LocationString {
    var latitude: String
    var longitude: String
    var city: String
    
    init(latitude: String, longitude: String, city: String) {
        self.latitude = latitude
        self.longitude = longitude
        self.city = city
    }
}
