//
//  Oferta.swift
//  MovilClub
//
//  Created by Donelkys Santana on 7/7/19.
//  Copyright © 2019 Done Santana. All rights reserved.
//

import Foundation
import CoreLocation

struct Oferta {
  //'#OSC,' + idsolicitud + ',' + idtaxi + ',' + codigo + ',' + nombreconductor + ',' + movilconductor + ',' + lat + ',' + lng + ',' + valoroferta + ',' + tiempollegada + ',' + calificacion + ',' + totalcalif + ',' + urlfoto + ',' + matricula + ',' + marca + ',' + color + ',# \n';
  
  var idSolicitud: String
  var idTaxi: String
  var codigo: String
  var nombreConductor: String
  var movilConductor: String
  var location: CLLocationCoordinate2D
  var valorOferta: Double
  var tiempoLLegada: String
  var calificacion: String
  var totalCalif: String
  var urlFoto: String
  var matricula :String
  var marcaVehiculo :String
  var colorVehiculo :String
  
  init(idSolicitud: String, idTaxi: String, codigo: String, nombreConductor: String, movilConductor: String, lat: String, lng: String, valorOferta: Double, tiempoLLegada: String, calificacion: String, totalCalif: String,urlFoto: String, matricula :String, marcaVehiculo :String, colorVehiculo :String){
    self.idSolicitud = idSolicitud
    self.idTaxi = idTaxi
    self.codigo = codigo
    self.nombreConductor = nombreConductor
    self.movilConductor = movilConductor
    self.location = CLLocationCoordinate2D(latitude: Double(lat)!, longitude: Double(lng)!)
    self.valorOferta = valorOferta
    self.tiempoLLegada = tiempoLLegada
    self.calificacion = calificacion
    self.totalCalif = totalCalif
    self.urlFoto = urlFoto
    self.matricula = matricula
    self.marcaVehiculo = marcaVehiculo
    self.colorVehiculo = colorVehiculo
  }
  
  mutating func updateValorOferta(cantidad: Double) {
    self.valorOferta += cantidad
  }
  
}
