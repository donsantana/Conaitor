//
//  ViewController.swift
//  Xtaxi
//
//  Created by Done Santana on 14/10/15.
//  Copyright © 2015 Done Santana. All rights reserved.
//
/*
import UIKit



class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var Usuario: UITextField!
    @IBOutlet weak var Clave: UITextField!
    
    
    
    //Registro Variables
   
    @IBOutlet weak var RegistroView: UIView!
    @IBOutlet weak var telefonoText: UITextField!
    @IBOutlet weak var usuarioText: UITextField!
    
    @IBOutlet weak var nombreApText: UITextField!
    @IBOutlet weak var claveText: UITextField!
    @IBOutlet weak var confirmarClavText: UITextField!
    @IBOutlet weak var correoText: UITextField!
    
    
    @IBOutlet weak var RegistrarBtn: UIButton!
    
    @IBOutlet weak var AlertaView: UIView!
    @IBOutlet weak var Titulo: UILabel!
    @IBOutlet weak var Mensaje: UITextView!
    @IBOutlet weak var AcpetarAlerta: UIButton!
    @IBOutlet weak var CancelarAlerta: UIButton!
    @IBOutlet weak var AceptarSoloAlerta: UIButton!
    @IBOutlet weak var activityview: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //asignar el delegado a los textfield para poder utilizar las funciones propias
       telefonoText.delegate = self
       claveText.delegate = self
       correoText.delegate = self
        Clave.delegate = self
       confirmarClavText.delegate = self
       telefonoText.addTarget(self, action: #selector(ViewController.textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
     }
    
    
    //Funcion para controlar los eventos del socket
        override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    //Boton de Autenticacion
    
    @IBAction func Autenticar(sender: AnyObject) {
        //TRAMA OUT: "#LoginPassword,Usuario,Clave
       if myvariables.socket.st == "Reconnecting"
        {
            self.Usuario.text = "Sin Conexión"
        }
        else{
            let writeString = "#LoginPassword," + self.Usuario.text! + "," + self.Clave.text! + ",# \n"
            //CREAR EL FICHERO DE LOGÍN
            let filePath = NSHomeDirectory() + "/Library/Caches/log.txt"
            
            do {
                _ = try writeString.write(toFile: filePath, atomically: true, encoding: String.Encoding.utf8)
            } catch {
                
            }
            CambiarPantalla()
        }
    }
       
    func textFieldDidChange(_ textField: UITextField) {
        self.usuarioText.text = textField.text
    }
    
    @IBAction func Registrarse(_ sender: UIButton) {
        
        self.RegistroView.isHidden = false
         self.telefonoText.addTarget(self, action: #selector(ViewController.textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
    }
    
    
    @IBAction func RegistrarUsuario(_ sender: UIButton) {
        
        if (nombreApText.text!.isEmpty || telefonoText.text!.isEmpty || claveText.text!.isEmpty) {
            let alertaDos = UIAlertController (title: "Registro de Usuario", message: "Debe llenar todos los campos del formulario", preferredStyle: UIAlertControllerStyle.alert)
            alertaDos.addAction(UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.default, handler: {alerAction in
                
            }))
            
            //Para hacer que la alerta se muestre usamos presentViewController, a diferencia de Objective C que como recordaremos se usa [Show Alerta]
            
            self.present(alertaDos, animated: true, completion: nil)
        }
        else{
        let temporal = "," + telefonoText.text! + "," + usuarioText.text! + "," + claveText.text!
            var temporal1 = ",Sin correo" + ",# \n"
            if correoText.text != ""{
         temporal1 = "," + correoText.text! + "," + "# \n"
            }
        let datos = "#Registro" + "," + nombreApText.text! + temporal + temporal1
        myvariables.socket.emit("data", datos)
        }
    }
    
    
    @IBAction func CancelRegistro(_ sender: AnyObject) {
       self.RegistroView.isHidden = true
        
    }
    
    //FUNCIÓN CAMBIO DE PANTALLA
    func CambiarPantalla (){
        let nuestroStoryBoard : UIStoryboard = UIStoryboard(name:"Main",bundle: nil)
        let nuestraPantallaInicio = nuestroStoryBoard.instantiateViewController(withIdentifier: "PI") as! PantallaInicio
        //Para cambiar a otra Pantalla por metodo push (cargar otra vista)
        //self.navigationController!.pushViewController(nuestraPantallaInicio, animated: true)
        //Para cambiar a otra pantalla superponiendo la vista.
        self.present(nuestraPantallaInicio, animated: true, completion: nil)
   }
    
    //enviar el id usuario
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func textFieldDidEndEditing(_ textfield: UITextField) {
        if textfield.isEqual(Clave){
            animateViewMoving(false, moveValue: 80)
        }
        else{
        if textfield.isEqual(telefonoText){
            usuarioText.text = textfield.text
            usuarioText.isUserInteractionEnabled = false
        }
        else{
            if textfield.isEqual(confirmarClavText){
                if textfield.text != claveText.text{
                    textfield.textColor = UIColor.red
                 textfield.text = "Las claves no coinciden"
                    textfield.isSecureTextEntry = false
                  RegistrarBtn.isEnabled = false
                }
                else{
                    RegistrarBtn.isEnabled = true
                }
            }
        animateViewMoving(false, moveValue: 140)
        }
     }
    }
    
    @IBAction func AceptarAlerta(_ sender: AnyObject) {
        RegistroView.isHidden = true
        let writeString = "#LoginPassword," + self.usuarioText.text! + "," + self.claveText.text! + ",# \n"
        //CREAR EL FICHERO DE LOGÍN
        let filePath = NSHomeDirectory() + "/Library/Caches/log.txt"
        
        do {
            _ = try writeString.write(toFile: filePath, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            
        }
        CambiarPantalla()
    }
    @IBAction func CancelarAlerta(_ sender: AnyObject) {
        AlertaView.isHidden = true
        RegistroView.isHidden = true
    }
    @IBAction func AceptarSolo(_ sender: AnyObject) {
        AlertaView.isHidden = true
    }
    
    
    //OCULTAR TECLACO CON TECLA ENTER
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    //Funciones para mover los elementos para que no queden detrás del teclado
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.isEqual(Clave){
            animateViewMoving(true, moveValue: 80)
        }
        else{
        if textField.isEqual(telefonoText){
       
        }
        else{
             animateViewMoving(true, moveValue: 140)
            if textField.isEqual(confirmarClavText){
                textField.isSecureTextEntry = true
                textField.textColor = UIColor.black
            }
        }
        }
    }
    func animateViewMoving (_ up:Bool, moveValue :CGFloat){
        let movementDuration:TimeInterval = 0.3
        let movement:CGFloat = ( up ? -moveValue : moveValue)
        UIView.beginAnimations( "animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration )
        self.view.frame = self.view.frame.offsetBy(dx: 0,  dy: movement)
        UIView.commitAnimations()
    }
   
}
*/

