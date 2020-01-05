//
//  ClaveChangeController.swift
//  UnTaxi
//
//  Created by Done Santana on 7/3/17.
//  Copyright © 2017 Done Santana. All rights reserved.
//

import UIKit

class ClaveChangeController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var ClaveActual: UITextField!
    @IBOutlet weak var ClaveNueva: UITextField!
    @IBOutlet weak var RepiteClaveNueva: UITextField!
    @IBOutlet weak var CambiarClave: UIButton!
    @IBOutlet weak var CancelaCambioClave: UIButton!


    override func viewDidLoad() {
        super.viewDidLoad()

        self.ClaveActual.delegate = self
        self.ClaveNueva.delegate = self
        self.RepiteClaveNueva.delegate = self
        
        self.ClaveActual.text?.removeAll()
        self.ClaveNueva.text?.removeAll()
        self.RepiteClaveNueva.text?.removeAll()
        // Do any additional setup after loading the view.
        
        //CAMBIAR CLAVE
        /*#Cambiarclave,idusuario,claveold,clavenew
         evento Cambiarclave
         retorno #Cambiarclave,ok
         #Cambiarclave,error*/
        myvariables.socket.on("Cambiarclave"){data, ack in
            let temporal = String(describing: data).components(separatedBy: ",")
            if temporal[1] == "ok"{
                let alertaDos = UIAlertController (title: "Cambio de clave", message: "Su clave ha sido cambiada satisfactoriamente", preferredStyle: UIAlertControllerStyle.alert)
                alertaDos.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: {alerAction in

                }))
                
                //Para hacer que la alerta se muestre usamos presentViewController, a diferencia de Objective C que como recordaremos se usa [Show Alerta]
                alertaDos.view.tintColor = UIColor.black
                let subview = alertaDos.view.subviews.last! as UIView
                let alertContentView = subview.subviews.last! as UIView
                alertContentView.backgroundColor = UIColor(red: 252.0/255.0, green: 238.0/255.0, blue: 129.0/255.0, alpha: 1.0)
                alertContentView.layer.cornerRadius = 5
                let TitleString = NSAttributedString(string: "Cambio de clave", attributes: [NSAttributedString.font : UIFont.systemFont(ofSize: 19), NSAttributedString.foregroundColor : UIColor.black])
                alertaDos.setValue(TitleString, forKey: "attributedTitle")
                //let MessageString = NSAttributedString(string: Message, attributes: [NSFontAttributeName : UIFont.systemFontOfSize(15), NSForegroundColorAttributeName : MessageColor])
                
                self.present(alertaDos, animated: true, completion: nil)
                
            }else{
                let alertaDos = UIAlertController (title: "Cambio de clave", message: "Se produjo un error al cambiar su clave. Revise la información ingresada e inténtelo más tarde.", preferredStyle: UIAlertControllerStyle.alert)
                alertaDos.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: {alerAction in
                    self.ClaveActual.text?.removeAll()
                    self.ClaveNueva.text?.removeAll()
                    self.RepiteClaveNueva.text?.removeAll()
                }))
                
                //Para hacer que la alerta se muestre usamos presentViewController, a diferencia de Objective C que como recordaremos se usa [Show Alerta]
                alertaDos.view.tintColor = UIColor.black
                let subview = alertaDos.view.subviews.last! as UIView
                let alertContentView = subview.subviews.last! as UIView
                alertContentView.backgroundColor = UIColor(red: 252.0/255.0, green: 238.0/255.0, blue: 129.0/255.0, alpha: 1.0)
                alertContentView.layer.cornerRadius = 5
                let TitleString = NSAttributedString(string: "Cambio de clave", attributes: [NSAttributedString.font : UIFont.systemFont(ofSize: 19), NSAttributedStringKey.foregroundColor : UIColor.black])
                alertaDos.setValue(TitleString, forKey: "attributedTitle")
                //let MessageString = NSAttributedString(string: Message, attributes: [NSFontAttributeName : UIFont.systemFontOfSize(15), NSForegroundColorAttributeName : MessageColor])
                self.present(alertaDos, animated: true, completion: nil)
            }
            
        }
    }
    
    //FUNCIÓN ENVIAR AL SOCKET
    func EnviarSocket(_ datos: String){
        if CConexionInternet.isConnectedToNetwork() == true{
            if myvariables.socket.reconnects{
                myvariables.socket.emit("data",datos)
            }
            else{
                let alertaDos = UIAlertController (title: "Sin Conexión", message: "No se puede conectar al servidor por favor intentar otra vez.", preferredStyle: UIAlertControllerStyle.alert)
                alertaDos.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: {alerAction in
                    exit(0)
                }))
                
                //Para hacer que la alerta se muestre usamos presentViewController, a diferencia de Objective C que como recordaremos se usa [Show Alerta]
                alertaDos.view.tintColor = UIColor.black
                let subview = alertaDos.view.subviews.last! as UIView
                let alertContentView = subview.subviews.last! as UIView
                alertContentView.backgroundColor = UIColor(red: 252.0/255.0, green: 238.0/255.0, blue: 129.0/255.0, alpha: 1.0)
                alertContentView.layer.cornerRadius = 5
                let TitleString = NSAttributedString(string: "Sin Conexión", attributes: [NSAttributedString.attributes.font : UIFont.systemFont(ofSize: 19), NSAttributedString.foregroundColor : UIColor.black])
                alertaDos.setValue(TitleString, forKey: "attributedTitle")
                //let MessageString = NSAttributedString(string: Message, attributes: [NSFontAttributeName : UIFont.systemFontOfSize(15), NSForegroundColorAttributeName : MessageColor])
                
                self.present(alertaDos, animated: true, completion: nil)
            }
        }else{
            self.ErrorConexion()
        }
    }
    //FUNCIONES ESCUCHAR SOCKET
    func ErrorConexion(){
        //self.CargarTelefonos()
        //AlertaSinConexion.isHidden = false
        
        let alertaDos = UIAlertController (title: "Sin Conexión", message: "No se puede conectar al servidor por favor revise su conexión a Internet.", preferredStyle: UIAlertControllerStyle.alert)
        alertaDos.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: {alerAction in
            exit(0)
        }))
        
        //Para hacer que la alerta se muestre usamos presentViewController, a diferencia de Objective C que como recordaremos se usa [Show Alerta]
        alertaDos.view.tintColor = UIColor.black
        let subview = alertaDos.view.subviews.last! as UIView
        let alertContentView = subview.subviews.last! as UIView
        alertContentView.backgroundColor = UIColor(red: 252.0/255.0, green: 238.0/255.0, blue: 129.0/255.0, alpha: 1.0)
        alertContentView.layer.cornerRadius = 5
        let TitleString = NSAttributedString(string: "Sin Conexión", attributes: [NSAttributedString.attributes.font : UIFont.systemFont(ofSize: 19), NSAttributedString.foregroundColor : UIColor.black])
        alertaDos.setValue(TitleString, forKey: "attributedTitle")
        //let MessageString = NSAttributedString(string: Message, attributes: [NSFontAttributeName : UIFont.systemFontOfSize(15), NSForegroundColorAttributeName : MessageColor])
        
        self.present(alertaDos, animated: true, completion: nil)
    }



    @IBAction func EnviarCambioClave(_ sender: AnyObject) {
        // #Cambiarclave,idusuario,claveold,clavenew
        let datos = "#Cambiarclave," + myvariables.cliente.idUsuario + "," + ClaveActual.text! + "," + ClaveNueva.text! + ",# \n"
        EnviarSocket(datos)
        self.ClaveActual.endEditing(true)
        self.ClaveNueva.endEditing(true)
        self.RepiteClaveNueva.endEditing(true)
    }
    
    @IBAction func CancelarCambioClave(_ sender: AnyObject) {
        self.ClaveActual.endEditing(true)
        self.ClaveNueva.endEditing(true)
        self.RepiteClaveNueva.endEditing(true)
        self.ClaveActual.text?.removeAll()
        self.ClaveNueva.text?.removeAll()
        self.RepiteClaveNueva.text?.removeAll()
        
    }
    
    //CONTROL DE TECLADO VIRTUAL
    //Funciones para mover los elementos para que no queden detrás del teclado
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.textColor = UIColor.black
        textField.text?.removeAll()
        if textField.isEqual(RepiteClaveNueva){
            textField.tintColor = UIColor.black
            if textField.isEqual(RepiteClaveNueva){
                    textField.isSecureTextEntry = true
                    animateViewMoving(true, moveValue: 135, view: self.view)
            }
        }else{
            if textField.isEqual(ClaveNueva){
                animateViewMoving(true, moveValue: 80, view: self.view)
            }

        }
    }
    func textFieldDidEndEditing(_ textfield: UITextField) {
        textfield.text = textfield.text!.replacingOccurrences(of: ",", with: ".")
        if textfield.isEqual(ClaveNueva){
            animateViewMoving(false, moveValue: 80, view: self.view)
        }
        else{
            if textfield.isEqual(RepiteClaveNueva){
                if RepiteClaveNueva.text != ClaveNueva.text{
                    textfield.textColor = UIColor.red
                    textfield.text = "Las Claves Nuevas no coinciden"
                    textfield.isSecureTextEntry = false
                }else{
                    CambiarClave.isEnabled = true
                }
                animateViewMoving(false, moveValue: 135, view: self.view)
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.isEqual(self.RepiteClaveNueva){
            let datos = "#Cambiarclave," + myvariables.cliente.idUsuario + "," + ClaveActual.text! + "," + ClaveNueva.text! + ",# \n"
            EnviarSocket(datos)
        }
       textField.endEditing(true)
        return true
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
