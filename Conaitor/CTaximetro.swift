//
//  CTaximetro.swift
//  UnTaxi
//
//  Created by Done Santana on 27/10/16.
//  Copyright © 2016 Done Santana. All rights reserved.
//

import Foundation
import GoogleMaps
import CoreData
import CoreLocation
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


class CTaximetro {
    //var acelerometro : CMMotionManager!
    var ValorPagar: Double = 0.0
    var CostoCarrera: Double = 0.0
    var Distancia: Double = 0.0
    var ValorArranque: Double = 0.0
    var ValorKilometro: Double = 0.0
    var ValorMinimo: Double = 0.0
    var ValorEspera: Double = 0.0
    var TiempoCarrera: Double = 0.0
    var TiempoEspera: [Int] = [0,0,0]
    var TiempoTotal: [Int] = [0,0,0]
    var LastPosition: CLLocation
    var horatemp: String
    
    var distanciaPrueba: Double = 0.0
  
    init(tarifas: [CTarifa], posicionInicio: CLLocationCoordinate2D){
        let date = Date()
        let formatter:DateFormatter = DateFormatter()
        formatter.dateFormat = "HH:mm" //opción formateador
        let hora = formatter.string(from: date)
        let temporal = String(hora).components(separatedBy: ":")
        self.horatemp = temporal[0]
        
        for var tarifatemporal in tarifas{
            if (Int(tarifatemporal.horaInicio) <= Int(temporal[0])) && (Int(temporal[0]) <= Int(tarifatemporal.horaFin)){
                self.ValorArranque = tarifatemporal.valorArranque
                self.ValorKilometro = tarifatemporal.valorKilometro1
                self.ValorMinimo = tarifatemporal.valorMinimo
                self.ValorEspera = tarifatemporal.tiempoEspera
                self.ValorPagar = self.ValorArranque
            }
        }
        self.CostoCarrera = 0.0
        self.Distancia = 0.0
        self.LastPosition = CLLocation(latitude: posicionInicio.latitude, longitude: posicionInicio.longitude)
    }
    
   /* func ActualizarTaximetro(posicion: CLLocationCoordinate2D)->Double{
            self.ValorPagar =  self.Distancia * self.ValorKilometro
        }
        return self.ValorPagar
    }
*/
    
    func CalcularDistancia(_ newPosition: CLLocationCoordinate2D)->Double{
        
        let newPositionTemp = CLLocation(latitude: newPosition.latitude, longitude: newPosition.longitude)
        if newPositionTemp.horizontalAccuracy < 10 && newPositionTemp.speed > 0.5{
            let recorrido = newPositionTemp.distance(from: self.LastPosition) / 1000
            self.Distancia += recorrido
            self.LastPosition = newPositionTemp
        }
        return self.Distancia
    }
    func ActualizaTiempoEspera()->[Int]{
        self.TiempoEspera[0] += 1
        if self.TiempoEspera[0] == 60{
            self.TiempoEspera[0] = 0
            self.TiempoEspera[1] += 1
        }
        if self.TiempoEspera[1] == 60{
            self.TiempoEspera[1] = 0
            self.TiempoEspera[2] += 1
        }
        return self.TiempoEspera
    }
    func ActualizaTiempoTotal()->[Int]{
        self.TiempoTotal[0] += 1
        if self.TiempoTotal[0] == 60{
            self.TiempoTotal[0] = 0
            self.TiempoTotal[1] += 1
        }
        if self.TiempoTotal[1] == 60{
            self.TiempoTotal[1] = 0
            self.TiempoTotal[2] += 1
        }
        return self.TiempoTotal
    }
    func ActualizarTarifa(_ tarifa: CTarifa){
        self.ValorArranque = tarifa.valorArranque
        self.ValorKilometro = tarifa.valorKilometro1
        self.ValorMinimo = tarifa.valorMinimo
        self.ValorEspera = tarifa.tiempoEspera

    }

    
}
