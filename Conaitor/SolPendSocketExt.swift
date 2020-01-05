//
//  SolPendSocketExt.swift
//  MovilClub
//
//  Created by Donelkys Santana on 8/21/19.
//  Copyright © 2019 Done Santana. All rights reserved.
//

import UIKit
import MapKit
import SocketIO

extension SolPendController{
  func socketEventos(){
    //MASK:- EVENTOS SOCKET
    GlobalVariables.socket.on("Transporte"){data, ack in
      //"#Taxi,"+nombreconductor+" "+apellidosconductor+","+telefono+","+codigovehiculo+","+gastocombustible+","+marcavehiculo+","+colorvehiculo+","+matriculavehiculo+","+urlfoto+","+idconductor+",# \n";
      let datosConductor = String(describing: data).components(separatedBy: ",")
      print(datosConductor)
      self.NombreCond.text! = "Conductor: \(datosConductor[1])"
      self.MarcaAut.text! = "Marca: \(datosConductor[4])"
      self.ColorAut.text! = "Color: \(datosConductor[5])"
      self.MatriculaAut.text! = "Matrícula: \(datosConductor[6])"
      self.MovilCond.text! = "Movil: \(datosConductor[2])"
      if datosConductor[7 ] != "null" && datosConductor[7] != ""{
        let url = URL(string:datosConductor[7])
        
        let task = URLSession.shared.dataTask(with: url!) { data, response, error in
          guard let data = data, error == nil else { return }
          
          DispatchQueue.main.sync() {
            self.ImagenCond.image = UIImage(data: data)
          }
        }
        task.resume()
      }else{
        self.ImagenCond.image = UIImage(named: "chofer")
      }
      self.AlertaEsperaView.isHidden = true
      self.DatosConductor.isHidden = false
    }
    
    GlobalVariables.socket.on("V"){data, ack in
      self.MensajesBtn.isHidden = false
      self.MensajesBtn.setImage(UIImage(named: "mensajesnew"),for: UIControl.State())
    }
    
    //GEOPOSICION DE TAXIS
    GlobalVariables.socket.on("Geo"){data, ack in
      let temporal = String(describing: data).components(separatedBy: ",")
      if GlobalVariables.solpendientes.count != 0 {
        if (temporal[1] == self.solicitudPendiente.idTaxi){
     
          self.MapaSolPen.removeAnnotation(self.TaxiSolicitud)
          self.solicitudPendiente.taximarker = CLLocationCoordinate2DMake(Double(temporal[2])!, Double(temporal[3])!)
          self.TaxiSolicitud.coordinate = CLLocationCoordinate2DMake(Double(temporal[2])!, Double(temporal[3])!)
          self.MapaSolPen.addAnnotation(self.TaxiSolicitud)
          self.MapaSolPen.showAnnotations(self.MapaSolPen.annotations, animated: true)
          self.MostrarDetalleSolicitud()
        }
      }
    }
    
    GlobalVariables.socket.on("Completada"){data, ack in
      //'#Completada,'+idsolicitud+','+idtaxi+','+distancia+','+tiempoespera+','+importe+',# \n'
      let temporal = String(describing: data).components(separatedBy: ",")
      if GlobalVariables.solpendientes.count != 0{
        GlobalVariables.solpendientes.remove(at: GlobalVariables.solpendientes.firstIndex{$0.id == temporal[1]}!)
        DispatchQueue.main.async {
          let vc = R.storyboard.main.completadaView()!
          vc.idSolicitud = temporal[1]
          self.navigationController?.show(vc, sender: nil)
        }

      }
    }
    
    //RESPUESTA DE CANCELAR SOLICITUD
    GlobalVariables.socket.on("CSO"){data, ack in
      let vc = R.storyboard.main.inicioView()!
      vc.EnviarTimer(estado: 0, datos: "Terminado")
      let temporal = String(describing: data).components(separatedBy: ",")
      print("Cancelada \(temporal)")
//      if temporal[1] == "ok"{
////        let alertaDos = UIAlertController (title: "Cancelar Solicitud", message: "Su solicitud fue cancelada.", preferredStyle: UIAlertController.Style.alert)
////        alertaDos.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: {alerAction in
////          //self.Inicio()
////          if GlobalVariables.solpendientes.count != 0{
////            self.SolPendientesView.isHidden = true
////
////          }
//        }))
//        self.present(alertaDos, animated: true, completion: nil)
//      }
    }
  }
}
