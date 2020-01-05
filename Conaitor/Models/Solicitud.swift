//
//  SolicitudOferta.swift
//  Xtaxi
//
//  Created by Done Santana on 29/1/16.
//  Copyright © 2016 Done Santana. All rights reserved.
//

import Foundation
import CoreData
import CoreLocation
import MapKit

class Solicitud {
  // #SO,idcliente,nombreapellidos,movil,dirorigen,referencia,dirdestino,latorigen,lngorigen,ladestino,lngdestino,distanciaorigendestino,valor oferta,voucher,detalle oferta,fecha reserva,tipo transporte,#
  //Cliente
//  var idCliente: String
//  var user : String
//  var nombreApellidos : String
//
//  var idSolicitud: String
//  var fechaHora: String
//  var dirOrigen: String
//  var origenCoord: CLLocationCoordinate2D
//  var referenciaorigen :String //= datos[8];
//  var dirDestino: String
//  var destinoCoord: CLLocationCoordinate2D
//  var distancia: Double
  var id = ""
  var idCliente = ""
  var user = ""
  var nombreApellidos = ""


  
  var fechaHora = ""
  var dirOrigen = ""
  var origenCoord = CLLocationCoordinate2D()
  var referenciaorigen = ""
  var dirDestino = ""
  var destinoCoord = CLLocationCoordinate2D()
  var distancia = 0.0
  var costo = "0"
  var valorOferta = "0"
  var detallesOferta = ""
  var fechaReserva = Date()

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

  
  //Taxi
//  var idTaxi: String
//  var matricula :String
//  var codTaxi :String
//  var marcaVehiculo :String
//  var colorVehiculo :String
//  var taximarker: CLLocationCoordinate2D
//  //Conductor
//  var idConductor :String
//  var nombreApellido :String
//  var movil :String
//  var urlFoto :String
  
  
//  //Constructor
//  init(){
//    super.init()
//    self.idCliente = ""
//    self.user = ""
//    self.nombreApellidos = ""
//
//    self.id = ""
//    self.fechaHora = ""
//    self.dirOrigen = ""
//    self.origenCoord = CLLocationCoordinate2D()
//    self.referenciaorigen = ""
//    self.dirDestino = ""
//    self.destinoCoord = CLLocationCoordinate2D()
//    self.distancia = 0.0
//    self.valorOferta = "0"
//    self.detallesOferta = ""
//    self.fechaReserva = Date()
//
//    //Taxi
//    self.idTaxi = ""
//    self.matricula = ""
//    self.codTaxi = ""
//    self.marcaVehiculo = ""
//    self.colorVehiculo = ""
//    taximarker = CLLocationCoordinate2D()
//
//    self.idConductor = ""
//    self.nombreApellido = ""
//    self.movil = ""
//    self.urlFoto = ""
//
//  }
  
    //Agregar datos de la solicitud
    func DatosSolicitud(idSolicitud: String, fechaHora: String, dirOrigen: String, referenciaOrigen: String, dirDestino: String, latOrigen: Double, lngOrigen: Double, latDestino: Double, lngDestino: Double, valorOferta: String, detallesOferta: String, fechaReserva: String){
      self.id = idSolicitud
      self.fechaHora = fechaHora
      self.dirOrigen = dirOrigen
      self.referenciaorigen = referenciaOrigen
      self.dirDestino = dirDestino
      self.origenCoord = CLLocationCoordinate2D(latitude: latOrigen, longitude: lngOrigen)
      self.destinoCoord = CLLocationCoordinate2D(latitude: latDestino, longitude: lngDestino)
      self.valorOferta = valorOferta != "null" ? valorOferta : "0"
      self.detallesOferta = detallesOferta
      
  //    if fechaReserva != "Al Momento"{
  //      let fechaFormatted = fechaReserva.replacingOccurrences(of: "/", with: "-")
  //      let fechaReserva = OurDate(stringDate: fechaReserva)
  //      self.fechaReserva = //fechaReserva.date
  //    }
    }
  
  //agregar datos para contactar a otro cliente
  func DatosOtroCliente(clienteId: String, telefono: String, nombre: String){
    self.idCliente = clienteId
    self.nombreApellidos = nombre
    self.user = telefono
  }

  //agregar datos del cliente
  func DatosCliente(cliente: CCliente){
    self.idCliente = cliente.idCliente
    self.user = cliente.user
    self.nombreApellidos = cliente.nombreApellidos
  }
  //Agregar datos del Conductor
  func DatosTaxiConductor(idtaxi :String, matricula: String, codigovehiculo :String, marcaVehiculo:String, colorVehiculo: String,lattaxi: Double, lngtaxi: Double, idconductor: String, nombreapellidosconductor :String, movilconductor: String, foto: String){

      self.idConductor = idconductor
      self.nombreApellido = nombreapellidosconductor
      self.movil = movilconductor
      self.urlFoto = foto
      self.idTaxi = idtaxi
      self.matricula = matricula
      self.codTaxi = codigovehiculo
      self.marcaVehiculo = marcaVehiculo
      self.colorVehiculo = colorVehiculo
      taximarker = CLLocationCoordinate2D(latitude: lattaxi, longitude: lngtaxi)
  }

  //REGISTRAR FECHA Y HORA
  func RegistrarFechaHora(IdSolicitud: String, FechaHora: String){ //, tarifario: [CTarifa]
    self.id = IdSolicitud
    self.fechaHora = FechaHora
    
  }
  
  func DistanciaTaxi()->String{
    let ruta = CRuta(origen: self.origenCoord, taxi: taximarker)
    return ruta.CalcularDistancia()
  }

  func getFechaISO() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    return dateFormatter.string(from: self.fechaReserva)
  }
//
  func showFecha()->String{
    let formatter = DateFormatter()
    formatter.dateFormat = "MMMM dd HH:mm:ss"
    formatter.dateStyle = .medium
    formatter.timeStyle = .short
    return formatter.string(from: self.fechaReserva)
  }
  
  func crearTrama(voucher: String) -> String{
    if self.valorOferta != ""{
    return "#SO,\(self.idCliente),\(self.nombreApellidos),\(self.user),\(self.dirOrigen),\(self.referenciaorigen),\(self.dirDestino),\(self.origenCoord.latitude),\(self.origenCoord.longitude),\(self.destinoCoord.latitude),\(self.destinoCoord.longitude),\(self.distancia),\(self.valorOferta),\(voucher),\(self.detallesOferta),\(self.getFechaISO()),1,# \n"
    }else{
      return "#Solicitud,\(self.idCliente),\(self.nombreApellidos),\(self.user),\(self.dirOrigen),\(self.referenciaorigen),\(self.dirDestino),\(String(self.origenCoord.latitude)),\(String(self.origenCoord.longitude)),0.0,0.0,\(String(self.distancia)),\(self.costo),\(voucher),# \n"
    }
  }
  
  func crearTramaCancelar(motivo: String) -> String {
    if self.valorOferta != ""{
      return "#CSO,\(self.id),\(self.idTaxi != "" ? self.idTaxi : "null"),\(motivo),# \n"
    }else{
      return "#Cancelarsolicitud,\(self.id),\(self.idTaxi != "" ? self.idTaxi : "null"),\(motivo),# \n"
    }
  }
  
}
