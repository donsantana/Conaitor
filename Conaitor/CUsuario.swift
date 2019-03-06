//
//  CUsuario.swift
//  Xtaxi
//
//  Created by Done Santana on 14/10/15.
//  Copyright © 2015 Done Santana. All rights reserved.
//

import Foundation

class CUsuario{
    var idusuario :String
    
    //Constructor
    init(idusuario :String){
        self.idusuario = idusuario
    }
    //Get and Set valores
    func GetIdusuario()-> String{
     return idusuario
    }
    
    func SetIdusuario(newusuario :String){
        idusuario = newusuario
    }
    
    //Función autenticación
    func Autenticacion(){
    //enviar usuario y contraseña al servidor para comprobarlos
       
    }
}