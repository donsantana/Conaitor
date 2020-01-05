//
//  PerfilViewCell.swift
//  UnTaxi
//
//  Created by Done Santana on 9/3/17.
//  Copyright © 2017 Done Santana. All rights reserved.
//

import UIKit

class PerfilViewCell: UITableViewCell, UITextFieldDelegate {
    @IBOutlet weak var NombreCampo: UILabel!
    @IBOutlet weak var ValorActual: UILabel!
    @IBOutlet weak var NuevoValor: UITextField!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.NuevoValor.delegate = self
        // Initialization code
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
