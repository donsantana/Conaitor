//
//  OfertasController.swift
//  MovilClub
//
//  Created by Donelkys Santana on 7/26/19.
//  Copyright © 2019 Done Santana. All rights reserved.
//

import UIKit

class OfertasController: UIViewController {
  let progress = Progress(totalUnitCount: 80)
  var progressTimer = Timer()
  let inicioController = R.storyboard.main.inicioView()
  var ofertaSeleccionada: Oferta!
  
  @IBOutlet weak var ofertasTableView: UITableView!
  @IBOutlet weak var progressTimeBar: UIProgressView!
  @IBOutlet weak var ofertaAceptadaEffect: UIVisualEffectView!
  @IBOutlet weak var waitingView: UIView!
  
  override func viewDidLoad() {
    self.waitingView.addShadow()
    //self.navigationController?.navigationBar.tintColor = UIColor.black
    
    self.ofertasTableView.delegate = self
    
    // 1
    self.progressTimeBar.progress = 0.0
    progress.completedUnitCount = 0
    
    // 2
    self.progressTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
      guard self.progress.isFinished == false else {
        let alertaDos = UIAlertController (title: "Ofertas no Aceptadas", message: "El tiempo para aceptar alguna oferta ha concluido. Por favor vuelva a enviar su solicitud.", preferredStyle: UIAlertController.Style.alert)
        alertaDos.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: {alerAction in
          self.inicioController?.Inicio()
        }))
        self.present(alertaDos, animated: true, completion: nil)
        timer.invalidate()
        return
      }
      
      // 3
      self.progress.completedUnitCount += 1
      self.progressTimeBar.setProgress(Float(self.progress.fractionCompleted), animated: true)
      
      //self.progressLabel.text = "\(Int(self.progress.fractionCompleted * 100)) %"
    }
  }
  
}
