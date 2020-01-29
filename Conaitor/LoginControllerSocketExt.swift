//
//  LoginControllerSocketExt.swift
//  UnTaxi
//
//  Created by Donelkys Santana on 5/5/19.
//  Copyright © 2019 Done Santana. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import Rswift

extension LoginController{
  
  func socketEventos(){
    GlobalVariables.socket.on("connect"){data, ack in
      print("Connected")
      let read = GlobalVariables.userDefaults.string(forKey: "\(Customization.nameShowed)-loginData") ?? "Vacio"
      //            let filePath = NSHomeDirectory() + "/Library/Caches/log.txt"
      //            do {
      //                read = try NSString(contentsOfFile: filePath, encoding: String.Encoding.utf8.rawValue) as String
      //            }catch {
      //            }
      if read != "Vacio"{
        self.AutenticandoView.isHidden = false
        self.Login(loginData: read)
      }
      else{
        self.AutenticandoView.isHidden = true
      }
      
    }
    
    GlobalVariables.socket.on("LoginPassword"){data, ack in
      //#LoginPassword,loginok," + row.rows[0].idusuario + "," + email + "," + cliente.idcliente + "," + cliente.nombreapellidos + ',' + foto + ',' + empresa + ',' + rowsc.rows.length
      
      self.EnviarTimer(estado: 0, datos: "Terminado")
      let temporal = String(describing: data).components(separatedBy: ",")
      print(temporal)
      switch temporal[1]{
      case "loginok":
        GlobalVariables.cliente = CCliente(idUsuario: temporal[2],idcliente: temporal[4], user: self.login[1], nombre: temporal[5],email: temporal[3],empresa: temporal[7])
        if GlobalVariables.socket.status.active{
          let ColaHilos = OperationQueue()
          let Hilos : BlockOperation = BlockOperation (block: {
            self.socketEventos()
            let url = "#U,# \n"
            self.EnviarSocket(url)
            let telefonos = "#Telefonos,# \n"
            self.EnviarSocket(telefonos)
            let datos = "OT"
            self.EnviarSocket(datos)
          })
          ColaHilos.addOperation(Hilos)
        }
        if temporal[8] != "0"{
          self.ListSolicitudPendiente(temporal)
        }
        if CLLocationManager.locationServicesEnabled(){
          switch(CLLocationManager.authorizationStatus()) {
          case .notDetermined, .restricted, .denied:
            let locationAlert = UIAlertController (title: "Error de Localización", message: "Estimado cliente es necesario que active la localización de su dispositivo.", preferredStyle: .alert)
            locationAlert.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: {alerAction in
              if #available(iOS 10.0, *) {
                let settingsURL = URL(string: UIApplication.openSettingsURLString)!
                UIApplication.shared.open(settingsURL, options: [:], completionHandler: { success in
                  exit(0)
                })
              } else {
                if let url = NSURL(string:UIApplication.openSettingsURLString) {
                  UIApplication.shared.openURL(url as URL)
                  exit(0)
                }
              }
            }))
            locationAlert.addAction(UIAlertAction(title: "No", style: .default, handler: {alerAction in
              exit(0)
            }))
            self.present(locationAlert, animated: true, completion: nil)
          case .authorizedAlways, .authorizedWhenInUse:
            DispatchQueue.main.async {
              switch temporal[8]{
              case "1":
                if temporal[10] != "null"{
                  let vc = R.storyboard.main.solPendientes()
                  vc!.solicitudIndex = 0
                  self.navigationController?.pushViewController(vc!, animated: true)
                }else{
                  let vc = R.storyboard.main.inicioView()
                  self.navigationController?.show(vc!, sender: nil)
                }
              default:
                if Int(temporal[8])! > 1{
                  let vc = R.storyboard.main.listaSolPdtes()
                  self.navigationController?.show(vc!, sender: nil)
                }else{
                  let vc = R.storyboard.main.inicioView()
                  self.navigationController?.show(vc!, sender: nil)
                }
              }
//              if temporal[8] == "0"{
//                print("here")
//                let vc = R.storyboard.main.inicioView() //UIStoryboard(name:"Main", bundle:nil).instantiateViewController(withIdentifier: "Inicio") as! InicioController
//                self.navigationController?.show(vc!, sender: nil)
//              }else{
//                if temporal[8] == "1" && temporal[10] != "null"{
//                  let vc = R.storyboard.main.solPendientes()
//                  vc!.solicitudIndex = 0
//                  self.navigationController?.pushViewController(vc!, animated: true)
//                }else{
//                  let vc = R.storyboard.main.listaSolPdtes()
//                  self.navigationController?.show(vc!, sender: nil)
//                }
//              }
            }
            break
          }
        }else{
          let locationAlert = UIAlertController (title: "Error de Localización", message: "Estimado cliente es necesario que active la localización de su dispositivo.", preferredStyle: .alert)
          locationAlert.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: {alerAction in
            if #available(iOS 10.0, *) {
              let settingsURL = URL(string: UIApplication.openSettingsURLString)!
              UIApplication.shared.open(settingsURL, options: [:], completionHandler: { success in
                exit(0)
              })
            } else {
              if let url = NSURL(string:UIApplication.openSettingsURLString) {
                UIApplication.shared.openURL(url as URL)
                exit(0)
              }
            }
          }))
          locationAlert.addAction(UIAlertAction(title: "No", style: .default, handler: {alerAction in
            exit(0)
          }))
          self.present(locationAlert, animated: true, completion: nil)
        }
      case "loginerror":
        //                let fileManager = FileManager()
        //                let filePath = NSHomeDirectory() + "/Library/Caches/log.txt"
        //                do {
        //                    try fileManager.removeItem(atPath: filePath)
        //                }catch{
        //
        //                }
        GlobalVariables.userDefaults.set(nil, forKey: "\(Customization.nameShowed)-loginData")
        
        let alertaDos = UIAlertController (title: "Autenticación", message: "Usuario y/o clave incorrectos", preferredStyle: UIAlertController.Style.alert)
        alertaDos.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: {alerAction in
          self.AutenticandoView.isHidden = true
          self.Usuario.text?.removeAll()
        }))
        self.present(alertaDos, animated: true, completion: nil)
      default: print("Problemas de conexion")
      }
    }
    
    GlobalVariables.socket.on("Registro") {data, ack in
      self.EnviarTimer(estado: 0, datos: "Terminado")
      let temporal = String(describing: data).components(separatedBy: ",")
      if temporal[1] == "registrook"{
        let alertaDos = UIAlertController (title: "Registro de Usuario", message: "Registro Realizado con éxito, puede loguearse en la aplicación, ¿Desea ingresar a la Aplicación?", preferredStyle: .alert)
        alertaDos.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: {alerAction in
          self.RegistroView.isHidden = true
        }))
        alertaDos.addAction(UIAlertAction(title: "Cancelar", style: .default, handler: {alerAction in
          exit(0)
        }))
        self.present(alertaDos, animated: true, completion: nil)
      }else{
        let alertaDos = UIAlertController (title: "Registro de Usuario", message: "Error al registrar el usuario: \(temporal[2])", preferredStyle: UIAlertController.Style.alert)
        alertaDos.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: {alerAction in
          self.AutenticandoView.isHidden = true
        }))
        self.present(alertaDos, animated: true, completion: nil)
      }
    }
    
    //RECUPERAR CLAVES
    GlobalVariables.socket.on("Recuperarclave"){data, ack in
      self.EnviarTimer(estado: 0, datos: "Terminado")
      let temporal = String(describing: data).components(separatedBy: ",")
      if temporal[1] == "ok"{
        let alertaDos = UIAlertController (title: "Recuperación de clave", message: "Su clave ha sido recuperada satisfactoriamente, en este momento ha recibido un correo electronico a la dirección: " + temporal[2], preferredStyle: UIAlertController.Style.alert)
        alertaDos.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: {alerAction in
        }))
        self.present(alertaDos, animated: true, completion: nil)
      }
    }
    
    //URl PARA AUDIO
    GlobalVariables.socket.on("U"){data, ack in
      let temporal = String(describing: data).components(separatedBy: ",")
      GlobalVariables.UrlSubirVoz = temporal[1]
    }
    
    GlobalVariables.socket.on("V"){data, ack in
      let temporal = String(describing: data).components(separatedBy: ",")
      GlobalVariables.urlconductor = temporal[1]
      if UIApplication.shared.applicationState == .background {
        let localNotification = UILocalNotification()
        localNotification.alertAction = "Mensaje del Conductor"
        localNotification.alertBody = "Mensaje del Conductor. Abra la aplicación para escucharlo."
        localNotification.fireDate = Date(timeIntervalSinceNow: 4)
        UIApplication.shared.scheduleLocalNotification(localNotification)
      }
      GlobalVariables.SMSVoz.ReproducirVozConductor(GlobalVariables.urlconductor)
    }
    
    GlobalVariables.socket.on("Telefonos"){data, ack in
      //#Telefonos,cantidad,numerotelefono1,operadora1,siesmovil1,sitienewassap1,numerotelefono2,operadora2..,#
      GlobalVariables.TelefonosCallCenter = [CTelefono]()
      let temporal = String(describing: data).components(separatedBy: ",")
      if temporal[1] != "0"{
        var i = 2
        while i <= temporal.count - 4{
          let telefono = CTelefono(numero: temporal[i], operadora: temporal[i + 1], esmovil: temporal[i + 2], tienewhatsapp: temporal[i + 3])
          GlobalVariables.TelefonosCallCenter.append(telefono)
          i += 4
        }
        //self.GuardarTelefonos(temporal)
      }
    }
  }
}

