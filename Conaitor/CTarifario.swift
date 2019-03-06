//
//  CTarifario.swift
//  XTaxi
//
//  Created by Done Santana on 25/6/16.
//  Copyright © 2016 Done Santana. All rights reserved.
//

import Foundation
import GoogleMaps
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
        let distancia = ruta.totalDistance
        for var tarifatemporal in tarifas{
            if (Int(tarifatemporal.horaInicio) <= Int(horaActual)) && (Int(horaActual) <= Int(tarifatemporal.horaFin)){
                if Double(distancia) <= 3{
                    costo = Double(distancia)! * tarifatemporal.valorKilometro1
                }
                else{
                    if Double(distancia) <= 10{
                        costo = 3 * tarifatemporal.valorKilometro1 + (Double(distancia)! - 3) * tarifatemporal.valorKilometro2
                    }else{
                        costo = 3 * tarifatemporal.valorKilometro1 + 7 * tarifatemporal.valorKilometro2 + (Double(distancia)! - 10) * tarifatemporal.valorKilometro3
                    }
                }
                if costo + tarifatemporal.valorArranque < tarifatemporal.valorMinimo{
                    costo = tarifatemporal.valorMinimo
                }else{
                    costo = costo + tarifatemporal.valorArranque
                }
            }
        }
        
        return [ruta.totalDistance, ruta.totalDuration, String(format:"%.2f",costo)]
    }
    func CalcularRuta()->GMSPolyline{
        let ruta = CRuta(origin: origenCoord, destination: destinoCoord)
        let routePolyline = ruta.drawRoute()
        let lines = GMSPolyline(path: routePolyline)
        return lines
    }
    
}
