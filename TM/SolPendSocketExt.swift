//
//  SolPendSocketExt.swift
//  TM
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
      self.NombreCond.text! = "Conductor: \(datosConductor[1])"
      self.MarcaAut.text! = "Marca: \(datosConductor[5])"
      self.ColorAut.text! = "Color: \(datosConductor[6])"
      self.MatriculaAut.text! = "Matrícula: \(datosConductor[7])"
      self.MovilCond.text! = "Movil: \(datosConductor[2])"
      if datosConductor[8] != "null" && datosConductor[8] != ""{
        let url = URL(string:datosConductor[8])
        
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
        if (temporal[2] == self.solicitudPendiente.idTaxi){
          self.MapaSolPen.removeAnnotation(self.TaxiSolicitud)
          self.solicitudPendiente.taximarker = CLLocationCoordinate2DMake(Double(temporal[3])!, Double(temporal[4])!)
          //self.TaxiSolicitud.coordinate = CLLocationCoordinate2DMake(Double(temporal[3])!, Double(temporal[4])!)
          //self.MapaSolPen.addAnnotation(self.TaxiSolicitud)
          //self.MapaSolPen.showAnnotations(self.MapaSolPen.annotations, animated: true)
          self.MostrarDetalleSolicitud()
        }
      }
    }
    
    GlobalVariables.socket.on("Completada"){data, ack in
      //'#Completada,'+idsolicitud+','+idtaxi+','+distancia+','+tiempoespera+','+importe+',# \n'
      let temporal = String(describing: data).components(separatedBy: ",")
      print(temporal)
      if GlobalVariables.solpendientes.count != 0{
        let pos = GlobalVariables.solpendientes.firstIndex{$0.idCliente == temporal[1]}
        print("pos \(pos)")
        //GlobalVariables.solpendientes.remove(at: pos!)
        DispatchQueue.main.async {
          let vc = R.storyboard.main.completadaView()!
          vc.idSolicitud = temporal[1]
//          vc.idTaxi = temporal[2]
//          vc.distanciaValue = temporal[3]
//          vc.tiempoValue = temporal[4]
//          vc.costoValue = temporal[5]

          self.navigationController?.show(vc, sender: nil)
        }

      }
    }
  }
}
