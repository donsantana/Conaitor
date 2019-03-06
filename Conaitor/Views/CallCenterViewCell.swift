//
//  CallCenterViewCell.swift
//  Conaitor
//
//  Created by Done Santana on 4/3/17.
//  Copyright © 2017 Done Santana. All rights reserved.
//

import UIKit

class CallCenterViewCell: UITableViewCell {

    @IBOutlet weak var ImagenOperadora: UIImageView!
    @IBOutlet weak var NumeroTelefono: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
