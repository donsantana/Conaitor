//
//  OfertaViewCell.swift
//  Conaitor
//
//  Created by Donelkys Santana on 12/4/19.
//  Copyright © 2019 Done Santana. All rights reserved.
//

import UIKit


class OfertaDataViewCell: UITableViewCell {
  
  @IBOutlet weak var ofertaText: UITextField!
  @IBOutlet weak var detallesText: UITextField!
  
  func initContent(){
    self.ofertaText.setBottomBorder(borderColor: .red)
    self.detallesText.setBottomBorder(borderColor: .gray)
  }
}
