//
//  CTarifario.swift
//  XTaxi
//
//  Created by Done Santana on 25/6/16.
//  Copyright © 2016 Done Santana. All rights reserved.
//

import Foundation
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func <= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l <= r
  default:
    return !(rhs < lhs)
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l >= r
  default:
    return !(lhs < rhs)
  }
}



class CTarifario{
    var origenCoord: String
    var destinoCoord: String
    
    init(){
        self.origenCoord = String()
        self.destinoCoord = String()
    }
    func InsertarOrigen(_ origen: CLLocationCoordinate2D){
        self.origenCoord = String(origen.latitude) + "," + String(origen.longitude)
    }
    func InsertarDestino(_ destino: CLLocationCoordinate2D){
        self.destinoCoord = String(destino.latitude) + "," + String(destino.longitude)
    }
    func CalcularTarifa(_ tarifas: [CTarifa])->[String]{
        let ruta = CRuta(origin: origenCoord, destination: destinoCoord)
        let dateFormatter = DateFormatter()
        var costo : Double!
        dateFormatter.dateFormat = "hh"
        let horaActual = dateFormatter.string(from: Date())
        var tarifa = Double()
        let distancia = ruta.totalDistance
        for var tarifatemporal in tarifas{
            if (Int(tarifatemporal.horaInicio) <= Int(horaActual)) && (Int(horaActual) <= Int(tarifatemporal.horaFin)){
                tarifa = Double(tarifatemporal.valorKilometro)
            }
            if Double(distancia) >= 4{
                costo = Double(distancia)! * tarifa
            }
            else{
                costo = Double(tarifatemporal.valorMinimo)
            }
        }
        
        return [ruta.totalDistance, ruta.totalDuration, String(costo)]
    }
    func CalcularRuta()->GMSPolyline{
        let ruta = CRuta(origin: origenCoord, destination: destinoCoord)
        let routePolyline = ruta.drawRoute()
        let lines = GMSPolyline(path: routePolyline)
        return lines
    }
    
}
