//
//  Solicitud.swift
//  SamboCar
//
//  Created by Donelkys Santana on 11/27/19.
//  Copyright © 2019 Done Santana. All rights reserved.
//

import Foundation
import CoreData
import CoreLocation
import MapKit

class SolicitudOld {
  
  var idSolicitud = ""
  var dirOrigen = ""
  var referenciaorigen = ""
  var dirDestino = ""
  var destinoCoord = CLLocationCoordinate2D()
  var fechaHora = ""
  var tarifa = 0.0
  var distancia = 0.0
  var tiempo = "0"
  var costo = "0"
  var origenCarrera = CLLocationCoordinate2D()
  
  
  //Cliente
  var idCliente = ""
  var user = ""
  var nombreApellidos = ""
  
  // self.cliente = CCliente()
  //self.taxi = CTaxi()
  
  var idTaxi = ""
  var matricula = ""
  var codTaxi = ""
  var marcaVehiculo = ""
  var colorVehiculo = ""
  var taximarker = CLLocationCoordinate2D()
  
  var idConductor = ""
  var nombreApellido = ""
  var movil = ""
  var urlFoto = ""
  
  //    var idSolicitud: String
  //    var origenCarrera: CLLocationCoordinate2D
  //    var dirOrigen: String
  //    var referenciaorigen :String //= datos[8];
  //    var dirDestino: String
  //    var destinoCoord: CLLocationCoordinate2D
  //    var fechaHora : String
  //    var tarifa : Double
  //    var distancia : Double
  //    var tiempo : String
  //    var costo : String
  //
  //    //Cliente
  //    var idCliente: String
  //    var user : String
  //    var nombreApellidos : String
  //
  //    //Taxi
  //    var idTaxi: String
  //    var matricula :String
  //    var codTaxi :String
  //    var marcaVehiculo :String
  //    var colorVehiculo :String
  //    var taximarker: CLLocationCoordinate2D
  //    //Conductor
  //    var idConductor :String
  //    var nombreApellido :String
  //    var movil :String
  //    var urlFoto :String
  
  //agregar datos de otro cliente
  func DatosOtroCliente(clienteId: String, telefono: String, nombre: String){
    self.idCliente = clienteId
    self.user = telefono
    self.nombreApellidos = nombre
  }
  
  //agregar datos del cliente
  func DatosCliente(cliente: CCliente){
    self.idCliente = cliente.idCliente
    self.user = cliente.user
    self.nombreApellidos = cliente.nombreApellidos
  }
  //Agregar datos del Conductor
  func DatosTaxiConductor(idtaxi: String, matricula: String, codigovehiculo: String, marcaVehiculo: String, colorVehiculo: String,lattaxi: String, lngtaxi: String, idconductor: String, nombreapellidosconductor: String, movilconductor: String, foto: String){
    
    if lattaxi != "undefined"{
      self.idConductor = idconductor
      self.nombreApellido = nombreapellidosconductor
      self.movil = movilconductor
      self.urlFoto = foto
      self.idTaxi = idtaxi
      self.matricula = matricula
      self.codTaxi = codigovehiculo
      self.marcaVehiculo = marcaVehiculo
      self.colorVehiculo = colorVehiculo
      self.taximarker = CLLocationCoordinate2D(latitude: Double(lattaxi)!, longitude: Double(lngtaxi)!)
    }
    
  }
  
  //REGISTRAR FECHA Y HORA
  func RegistrarFechaHora(IdSolicitud: String, FechaHora: String){ //, tarifario: [CTarifa]
    self.idSolicitud = IdSolicitud
    self.fechaHora = FechaHora
  }
  
  //Agregar datos de la solicitud
  func DatosSolicitud(dirorigen :String, referenciaorigen :String, dirdestino :String, latorigen :String, lngorigen :String, latdestino: String, lngdestino: String,FechaHora: String){
    self.dirOrigen = dirorigen
    self.referenciaorigen = referenciaorigen
    self.origenCarrera = CLLocationCoordinate2D(latitude: Double(latorigen)!, longitude: Double(lngorigen)!)
    self.dirDestino = dirdestino
    self.destinoCoord = CLLocationCoordinate2D(latitude: Double(latdestino)!, longitude: Double(lngdestino)!)
    self.fechaHora = FechaHora
  }
  
  func DistanciaTaxi()->String{
    let ruta = CRuta(origen: self.origenCarrera, taxi: taximarker)
    return ruta.CalcularDistancia()
  }
  
  func crearTrama(voucher: String) -> String{
  return "#Solicitud,\(self.idCliente),\(self.nombreApellidos),\(self.user),\(self.dirOrigen),\(self.referenciaorigen),\(self.dirDestino),\(String(self.origenCarrera.latitude)),\(String(self.origenCarrera.longitude)),0.0,0.0,\(String(self.distancia)),\(self.costo),\(voucher),# \n"
  }
  
  func crearTramaCancelar(motivo: String) -> String{
    return "#Cancelarsolicitud,\(self.idSolicitud),\(self.idTaxi != "" ? self.idTaxi : "null"),\(motivo),# \n"
  }
  
}
