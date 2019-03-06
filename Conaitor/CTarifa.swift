//
//  CTarifa.swift
//  Xtaxi
//
//  Created by usuario on 17/4/16.
//  Copyright © 2016 Done Santana. All rights reserved.
//

import Foundation

class CTarifa {
    var horaInicio : Int
    var horaFin : Int
    var valorMinimo : Double
    var tiempoEspera : Double
    var valorKilometro1 : Double // 0-3
    var valorKilometro2 : Double //3-10
    var valorKilometro3 : Double // +10 km
    var valorArranque : Double
    
    init(horaInicio : String, horaFin : String, valorMinimo : Double, tiempoEspera : Double, valorKilometro1 : Double,valorKilometro2 : Double,valorKilometro3 : Double, valorArranque : Double){
        self.horaInicio = Int(horaInicio)!
        self.horaFin = Int(horaFin)!
        self.valorMinimo = valorMinimo
        self.tiempoEspera = tiempoEspera
        self.valorKilometro1 = valorKilometro1
        self.valorKilometro2 = valorKilometro2
        self.valorKilometro3 = valorKilometro3
        self.valorArranque = valorArranque
    }
}
