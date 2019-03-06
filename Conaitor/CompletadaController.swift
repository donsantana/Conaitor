//
//  CompletadaController.swift
//  Conaitor
//
//  Created by Done Santana on 1/6/17.
//  Copyright © 2017 Done Santana. All rights reserved.
//

import Foundation
import UIKit


class CompletadaController: UIViewController, UITextViewDelegate {
    var evaluacion: CEvaluacion!
    var idSolicitud = ""
    @IBOutlet weak var comentarioText: UITextView!
    
    @IBOutlet weak var PrimeraStart: UIButton!
    @IBOutlet weak var SegundaStar: UIButton!
    @IBOutlet weak var TerceraStar: UIButton!
    @IBOutlet weak var CuartaStar: UIButton!
    @IBOutlet weak var QuintaStar: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.comentarioText.delegate = self
        self.evaluacion = CEvaluacion(botones: [PrimeraStart, SegundaStar,TerceraStar,CuartaStar,QuintaStar])
        
        self.navigationItem.setHidesBackButton(true, animated:true)
    }
    
    //ENVIAR EVALUACIÓN
    func EnviarEvaluacion(_ evaluacion: Int, comentario: String){
        self.comentarioText.text = "Escriba su comentario..."
        let datos = "#Evaluar,\(self.idSolicitud),\(String(evaluacion)),\(comentario),# \n"
        EnviarSocket(datos)
    }
    
    //FUNCIÓN ENVIAR AL SOCKET
    func EnviarSocket(_ datos: String){
        if CConexionInternet.isConnectedToNetwork() == true{
            if myvariables.socket.status.active{
                myvariables.socket.emit("data",datos)
                let vc = UIStoryboard(name:"Main", bundle:nil).instantiateViewController(withIdentifier: "Inicio") as! InicioController
                self.navigationController?.show(vc, sender: nil)  
            }else{
                let alertaDos = UIAlertController (title: "Sin Conexión", message: "No se puede conectar al servidor por favor intentar otra vez.", preferredStyle: UIAlertController.Style.alert)
                alertaDos.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: {alerAction in
                    exit(0)
                }))
                self.present(alertaDos, animated: true, completion: nil)
            }
        }else{
            self.ErrorConexion()
        }
    }
    
    func ErrorConexion(){
        let alertaDos = UIAlertController (title: "Sin Conexión", message: "No se puede conectar al servidor por favor revise su conexión a Internet.", preferredStyle: UIAlertController.Style.alert)
        alertaDos.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: {alerAction in
            exit(0)
        }))
        self.present(alertaDos, animated: true, completion: nil)
    }

    @IBAction func Star1(_ sender: AnyObject) {
        self.evaluacion.EvaluarCarrera(1)
        self.comentarioText.isHidden = false
    }
    @IBAction func Star2(_ sender: AnyObject) {
        self.evaluacion.EvaluarCarrera(2)
        self.comentarioText.isHidden = false
    }
    @IBAction func Star3(_ sender: AnyObject) {
        self.evaluacion.EvaluarCarrera(3)
        self.comentarioText.isHidden = false
    }
    @IBAction func Star4(_ sender: AnyObject) {
        self.evaluacion.EvaluarCarrera(4)
        self.comentarioText.isHidden = false
    }
    @IBAction func Star5(_ sender: AnyObject) {
        self.evaluacion.EvaluarCarrera(5)
        self.comentarioText.isHidden = false
    }
    //Enviar comentario
    @IBAction func AceptarEvalucion(_ sender: AnyObject) {
        EnviarEvaluacion(self.evaluacion.PtoEvaluacion,comentario: self.comentarioText.text)
        self.comentarioText.endEditing(true)
    }
    
    //MARK:- TEXT DELEGATE ACTION
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.isEqual(comentarioText){
            textView.text.removeAll()
            animateViewMoving(true, moveValue: 200, view: self.view)
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.isEqual(comentarioText){
            animateViewMoving(false, moveValue: 200,view: self.view)
        }
    }
    
    func animateViewMoving (_ up:Bool, moveValue :CGFloat, view : UIView){
        let movementDuration:TimeInterval = 0.3
        let movement:CGFloat = ( up ? -moveValue : moveValue)
        UIView.beginAnimations( "animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration)
        view.frame = view.frame.offsetBy(dx: 0,  dy: movement)
        UIView.commitAnimations()
    }


    
}
