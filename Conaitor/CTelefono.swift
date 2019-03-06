//
//  CTelefono.swift
//  XTaxi
//
//  Created by Done Santana on 11/8/16.
//  Copyright © 2016 Done Santana. All rights reserved.
//

import Foundation

class CTelefono{
    //#Telefonos,cantidad,numerotelefono1,operadora1,siesmovil1,sitienewassap1,numerotelefono2,operadora2.......,#
    var numero: String
    var operadora: String
    var esmovil: String
    var tienewhatsapp: String
    
    init(numero: String,operadora: String,esmovil: String,tienewhatsapp: String){
        self.numero = numero
        self.operadora = operadora
        self.esmovil = esmovil
        self.tienewhatsapp = tienewhatsapp
    }
}