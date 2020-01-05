//
//  InicioControllerSocketExt.swift
//  UnTaxi
//
//  Created by Donelkys Santana on 5/5/19.
//  Copyright © 2019 Done Santana. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

extension InicioController{
  func socketEventos(){
    
    //Evento sockect para escuchar
    //TRAMA IN: #LoginPassword,loginok,idusuario,idrol,idcliente,nombreapellidos,cantsolpdte,idsolicitud,idtaxi,cod,fechahora,lattaxi,lngtaxi,latorig,lngorig,latdest,lngdest,telefonoconductor
    if self.appUpdateAvailable(){
      
      let alertaVersion = UIAlertController (title: "Versión de la aplicación", message: "Estimado cliente es necesario que actualice a la última versión de la aplicación disponible en la AppStore. ¿Desea hacerlo en este momento?", preferredStyle: .alert)
      alertaVersion.addAction(UIAlertAction(title: "Si", style: .default, handler: {alerAction in
        
        UIApplication.shared.openURL(URL(string: GlobalConstants.itunesURL)!)
      }))
      alertaVersion.addAction(UIAlertAction(title: "No", style: .default, handler: {alerAction in
        exit(0)
      }))
      self.present(alertaVersion, animated: true, completion: nil)
    }
    
    //Evento Posicion de taxis
    GlobalVariables.socket.on("Posicion"){data, ack in
      self.EnviarTimer(estado: 0, datos: "Terminado")
      let temporal = String(describing: data).components(separatedBy: ",")
      if temporal[1] == "0" {
        let alertaDos = UIAlertController(title: "Solicitud de Taxi", message: "No hay taxis disponibles en este momento, espere unos minutos y vuelva a intentarlo.", preferredStyle: UIAlertController.Style.alert )
        alertaDos.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: {alerAction in
          super.topMenu.isHidden = false
          self.viewDidLoad()
        }))
        self.present(alertaDos, animated: true, completion: nil)
      }else{
        self.formularioSolicitud.isHidden = false
        self.MostrarTaxi(temporal)
      }
    }
    
    //Respuesta de la solicitud enviada
    
    GlobalVariables.socket.on("SO"){data, ack in
      //Trama IN: #Solicitud, ok, idsolicitud, fechahora
      //Trama IN: #Solicitud, error
      self.EnviarTimer(estado: 0, datos: "terminando")
      let temporal = String(describing: data).components(separatedBy: ",")
      print("here \(temporal)")
      if temporal[1] == "ok"{
        self.solicitudInProcess.text = temporal[2]
        self.MensajeEspera.text = "Solicitud creada exitosamente. Buscamos el taxi disponible más cercano a usted. Mientras espera una respuesta puede modificar el valor de su oferta y reenviarla."
        self.AlertaEsperaView.isHidden = false
        self.CancelarSolicitudProceso.isHidden = false
        self.ConfirmaSolicitud(temporal)
        self.newOfertaText.text = self.ofertaDataCell.ofertaText.text
        self.down25.isEnabled = false
      }else{
        print("error de solicitud")
      }
    }
    
    GlobalVariables.socket.on("OSC"){data, ack in
      //'#OSC,' + idsolicitud + ',' + idtaxi + ',' + codigo + ',' + nombreconductor + ',' + movilconductor + ',' + lat + ',' + lng + ',' + valoroferta + ',' + tiempollegada + ',' + calificacion + ',' + totalcalif + ',' + urlfoto + ',' + matricula + ',' + marca + ',' + color + ',# \n';
      self.EnviarTimer(estado: 0, datos: "terminando")
      let temporal = String(describing: data).components(separatedBy: ",")
      print(temporal)
      let array = GlobalVariables.ofertasList.map{$0.idTaxi}
      if !array.contains(temporal[2]){
        let newOferta = Oferta(idSolicitud: temporal[1], idTaxi: temporal[2], codigo: temporal[3], nombreConductor: temporal[4], movilConductor: temporal[5], lat: temporal[6], lng: temporal[7], valorOferta: Double(temporal[8])!, tiempoLLegada: temporal[9], calificacion: temporal[10], totalCalif: temporal[11], urlFoto: temporal[12], matricula: temporal[13], marcaVehiculo: temporal[14], colorVehiculo: temporal[15])
        
        GlobalVariables.ofertasList.append(newOferta)
        
        DispatchQueue.main.async {
          let vc = R.storyboard.main.ofertasView()
          self.navigationController?.show(vc!, sender: nil)
        }
      }
    }
    
    GlobalVariables.socket.on("RSO"){data, ack in
      //Trama IN: #Solicitud, ok, idsolicitud, fechahora
      //Trama IN: #Solicitud, error
      self.EnviarTimer(estado: 0, datos: "terminando")
      let temporal = String(describing: data).components(separatedBy: ",")
      print(temporal)
      if temporal[1] == "ok"{
        let alertaDos = UIAlertController (title: "Oferta Actualizada", message: "La oferta ha sido actualizada con éxito y enviada a los conductores disponibles. Esperamos que acepten su nueva oferta.", preferredStyle: UIAlertController.Style.alert)
        alertaDos.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: {alerAction in
          
        }))
        self.present(alertaDos, animated: true, completion: nil)
      }else{
        let alertaDos = UIAlertController (title: "Oferta Cancelada", message: "La oferta ha sido cancelada por el conductor. Por favor", preferredStyle: UIAlertController.Style.alert)
        alertaDos.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: {alerAction in
          self.Inicio()
          if GlobalVariables.solpendientes.count != 0{
            self.SolPendientesView.isHidden = true
            
          }
        }))
        self.present(alertaDos, animated: true, completion: nil)
      }
    }
    
    //RESPUESTA DE CANCELAR SOLICITUD
    GlobalVariables.socket.on("CSO"){data, ack in
      self.EnviarTimer(estado: 0, datos: "Terminado")
      let temporal = String(describing: data).components(separatedBy: ",")
      if temporal[1] == "ok"{
        let alertaDos = UIAlertController (title: "Cancelar Solicitud", message: "Su solicitud fue cancelada.", preferredStyle: UIAlertController.Style.alert)
        alertaDos.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: {alerAction in
          self.AlertaEsperaView.isHidden = true
          self.Inicio()
          if GlobalVariables.solpendientes.count != 0{
            self.SolPendientesView.isHidden = true
          }
        }))
        self.present(alertaDos, animated: true, completion: nil)
      }
    }
    
    GlobalVariables.socket.on("Cambioestadosolicitudconductor"){data, ack in
      let temporal = String(describing: data).components(separatedBy: ",")
      let alertaDos = UIAlertController (title: "Estado de Solicitud", message: "Solicitud cancelada por el conductor.", preferredStyle: UIAlertController.Style.alert)
      alertaDos.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: {alerAction in
        var pos = -1
        pos = self.BuscarPosSolicitudID(temporal[1])
        if  pos != -1{
          self.CancelarSolicitudes("Conductor")
        }
        
        DispatchQueue.main.async {
          let vc = R.storyboard.main.inicioView()!
          self.navigationController?.show(vc, sender: nil)
        }
      }))
      self.present(alertaDos, animated: true, completion: nil)
    }
    
    //SOLICITUDES SIN RESPUESTA DE TAXIS
    GlobalVariables.socket.on("SNA"){data, ack in
      let temporal = String(describing: data).components(separatedBy: ",")
      if (GlobalVariables.solpendientes.filter{$0.id == temporal[1]}.count > 0) {
        let alertaDos = UIAlertController (title: "Estado de Solicitud", message: "No se encontó ningún taxi disponible para ejecutar su solicitud. Por favor inténtelo más tarde.", preferredStyle: UIAlertController.Style.alert)
        alertaDos.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: {alerAction in
          self.CancelarSolicitudes("")
        }))
        
        self.present(alertaDos, animated: true, completion: nil)
      }
    }
    
    //ACTIVACION DEL TAXIMETRO
    GlobalVariables.socket.on("TI"){data, ack in
      let temporal = String(describing: data).components(separatedBy: ",")
      if GlobalVariables.solpendientes.count != 0 {
        //self.MensajeEspera.text = temporal
        //self.AlertaEsperaView.hidden = false
        for solicitudpendiente in GlobalVariables.solpendientes{
          if (temporal[2] == solicitudpendiente.idTaxi){
            let alertaDos = UIAlertController (title: "Taximetro Activado", message: "Estimado Cliente: El conductor ha iniciado el Taximetro a las: \(temporal[1]).", preferredStyle: .alert)
            alertaDos.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: {alerAction in
              
            }))
            self.present(alertaDos, animated: true, completion: nil)
          }
        }
      }
    }
    
    
    //Respuesta de la solicitud enviada
    GlobalVariables.socket.on("Solicitud"){data, ack in
      //Trama IN: #Solicitud, ok, idsolicitud, fechahora
      //Trama IN: #Solicitud, error
      self.EnviarTimer(estado: 0, datos: "terminando")
      let temporal = String(describing: data).components(separatedBy: ",")
      if temporal[1] == "ok"{
        self.MensajeEspera.text = "Solicitud enviada a todos los taxis cercanos. Esperando respuesta de un conductor."
        self.AlertaEsperaView.isHidden = false
        self.CancelarSolicitudProceso.isHidden = false
        self.ConfirmaSolicitud(temporal)
      }
      else{
        
      }
    }
    
    GlobalVariables.socket.on("Aceptada"){data, ack in
      self.Inicio()
      let temporal = String(describing: data).components(separatedBy: ",")
      print(temporal)
      //#Aceptada, idsolicitud, idconductor, nombreApellidosConductor, movilConductor, URLfoto, idTaxi, Codvehiculo, matricula, marca, color, latTaxi, lngTaxi
      if temporal[0] == "#Aceptada" || temporal[0] == "[#Aceptada"{
        let solicitud = GlobalVariables.solpendientes.filter{$0.id == temporal[1]}.first
        solicitud!.DatosTaxiConductor(idtaxi: temporal[6], matricula: temporal[8], codigovehiculo: temporal[7], marcaVehiculo: temporal[9],colorVehiculo: temporal[10], lattaxi: Double(temporal[11])!, lngtaxi: Double(temporal[12])!, idconductor: temporal[2], nombreapellidosconductor: temporal[3], movilconductor: temporal[4], foto: temporal[5])
        
        let vc = R.storyboard.main.solPendientes()!
        vc.solicitudIndex = GlobalVariables.solpendientes.firstIndex{$0.id == solicitud?.id}
        self.navigationController?.show(vc, sender: nil)
        
      }else{
        if temporal[0] == "#Cancelada" {
          //#Cancelada, idsolicitud
          let alertaDos = UIAlertController (title: "Estado de Solicitud", message: "Ningún vehículo aceptó su solicitud, puede intentarlo más tarde.", preferredStyle: .alert)
          alertaDos.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: {alerAction in
          }))
          
          self.present(alertaDos, animated: true, completion: nil)
        }
      }
    }
    
    GlobalVariables.socket.on("Cancelarsolicitud"){data, ack in
      let temporal = String(describing: data).components(separatedBy: ",")
      if temporal[1] == "ok"{
        self.Inicio()
      }
    }
    
  }
}
