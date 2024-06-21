//
//  places.swift
//  FavPlacesApp
//
//  Created by Hugo López on 18-06-24.
//

import Foundation
import CoreLocation


class Place:Identifiable {
    let id = UUID()
    let name:String
    let coordinates:CLLocationCoordinate2D
    var fav:Bool
     
    init(name: String, coordinates: CLLocationCoordinate2D, fav: Bool) {
        self.name = name
        self.coordinates = coordinates
        self.fav = fav
    }
}
