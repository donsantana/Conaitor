//
//  SolPendientesViewCell.swift
//  Conaitor
//
//  Created by Donelkys Santana on 12/27/19.
//  Copyright © 2019 Done Santana. All rights reserved.
//

import UIKit

class SolPendientesViewCell: UITableViewCell{
  
  @IBOutlet weak var solicitudOrigenText: UILabel!
  @IBOutlet weak var solDateText: UILabel!
  @IBOutlet weak var dataView: UIView!
  
  func initContent(solicitud: Solicitud){
    self.dataView.addShadow()
    self.solicitudOrigenText.text = solicitud.dirOrigen
    self.solDateText.text = solicitud.fechaHora
  }
}
