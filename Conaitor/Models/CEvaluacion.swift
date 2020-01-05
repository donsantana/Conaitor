//
//  CEvaluacion.swift
//  Xtaxi
//
//  Created by usuario on 5/4/16.
//  Copyright © 2016 Done Santana. All rights reserved.
//

import Foundation
import UIKit

class CEvaluacion {
    var Botones: [UIButton]
    var PtoEvaluacion : Int
    
    init(botones: [UIButton]){
        self.Botones = botones
        self.PtoEvaluacion = 0
        var i = 0
        while i < 5 {
                self.Botones[i].setImage(UIImage(named: "stargris"), for: UIControl.State())
            i += 1
            }    

    }
    func EvaluarCarrera(_ posicion: Int){
        var i = 0
        while i < 5 {
            if i < posicion{
            self.Botones[i].setImage(UIImage(named: "stardorada"), for: UIControl.State())
                
            }
            else{
                self.Botones[i].setImage(UIImage(named: "stargris"), for: UIControl.State())
            }
            i += 1
        }
        self.PtoEvaluacion = posicion
    }

}
