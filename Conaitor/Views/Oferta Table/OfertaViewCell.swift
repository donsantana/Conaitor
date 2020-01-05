//
//  OfertaViewCell.swift
//  MovilClub
//
//  Created by Donelkys Santana on 7/7/19.
//  Copyright © 2019 Done Santana. All rights reserved.
//

import UIKit

class OfertaViewCell: UITableViewCell {
  @IBOutlet weak var ofertaView: OfertaViewCell!
  @IBOutlet weak var conductorFoto: UIImageView!
  @IBOutlet weak var condNombreApellidos: UILabel!
  @IBOutlet weak var distanciaTiempoText: UILabel!
  @IBOutlet weak var valorText: UILabel!
  @IBOutlet weak var calificacionText: UILabel!
  
  func initContent(oferta: Oferta){
    self.ofertaView.addShadow()
    let url = URL(string:oferta.urlFoto)
    
    let task = URLSession.shared.dataTask(with: url!) { data, response, error in
      guard let data = data, error == nil else { return }
      
      DispatchQueue.main.sync() {
        self.conductorFoto.image = UIImage(data: data)
      }
    }
    task.resume()
   self.condNombreApellidos.text = oferta.nombreConductor
    self.distanciaTiempoText.text = "Tiempo de llegada: \(oferta.tiempoLLegada)"
    self.valorText.text = "Ofrece: $\(oferta.valorOferta)"
    self.calificacionText.text = "\(oferta.calificacion) (\(oferta.totalCalif))"
  }
}
