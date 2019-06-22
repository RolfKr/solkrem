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
