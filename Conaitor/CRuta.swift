//
//  CRuta.swift
//  Xtaxi
//
//  Created by usuario on 15/3/16.
//  Copyright © 2016 Done Santana. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreLocation

class CRuta{
    var originCoordinate: CLLocationCoordinate2D!
    var taxiCoordinate: CLLocationCoordinate2D!
    var totalDistanceInMeters: UInt = 0
    var totalDistance: String = "0"
    var totalDurationInSeconds: UInt = 0
    var totalDuration: String = "0"
    
    init(origen: CLLocationCoordinate2D, taxi: CLLocationCoordinate2D){
        self.originCoordinate = origen
        self.taxiCoordinate = taxi
        
    }
    
    func CalcularDistancia() -> String {
        let origen = CLLocation(latitude: self.originCoordinate.latitude, longitude: self.originCoordinate.longitude)
        let taxi = CLLocation(latitude: self.taxiCoordinate.latitude, longitude: self.taxiCoordinate.longitude)
        let distancia = origen.distance(from: taxi)/1000
        return String(format: "%.2f", distancia)
    }
}
