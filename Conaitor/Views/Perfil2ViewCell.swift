//
//  Perfil2ViewCell.swift
//  UnTaxi
//
//  Created by Done Santana on 10/28/17.
//  Copyright © 2017 Done Santana. All rights reserved.
//

import UIKit

class Perfil2ViewCell: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var NombreCampo: UILabel!
    @IBOutlet weak var ValorActual: UILabel!
    @IBOutlet weak var NuevoValor: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.NuevoValor.delegate = self
        self.NuevoValor.setBottomBorder(borderColor: UIColor.black)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

