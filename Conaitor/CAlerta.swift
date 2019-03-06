//
//  CAlerta.swift
//  Xtaxi
//
//  Created by Done Santana on 23/2/16.
//  Copyright © 2016 Done Santana. All rights reserved.
//

import Foundation
import UIKit

class CAlerta {
    var titulo : UILabel
    var mensaje : UITextView
    var vista : UIView!
    var aceptar : UIButton!
    var aceptarSolo: UIButton!
    var cancelar : UIButton!
    var tipo: Int
    
    init(titulo: UILabel, mensaje: UITextView, vistaalerta: UIView, aceptarbtn: UIButton, aceptarsolobtn: UIButton, cancelarbtn: UIButton, tipo: Int){
        self.titulo = titulo
        self.mensaje = mensaje
        self.vista = vistaalerta
        self.aceptar = aceptarbtn
        self.aceptarSolo = aceptarsolobtn
        self.cancelar = cancelarbtn
        self.tipo = tipo
    }
    
    func CambiarTitulo(titulo: String){
        self.titulo.text = titulo
    }
    
    func CambiarMensaje(mensaje: String){
        self.mensaje.text = mensaje
    }
    
    func DefinirTipo(tipo: Int){
        if tipo == 20{
            self.aceptarSolo.hidden = true
            self.aceptar.hidden = true
            self.cancelar.hidden = true
        }
        else{
            if tipo >= 10{
                self.aceptarSolo.hidden = true
                self.aceptar.hidden = false
                self.cancelar.hidden = false
            }
            else{
                self.aceptar.hidden = true
                self.cancelar.hidden = true
                self.aceptarSolo.hidden = false
            }
        }
        self.tipo = tipo
    }
    
    func CancelarAccion(){
        
    }
    
}