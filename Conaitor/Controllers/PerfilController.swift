//
//  PerfilController.swift
//  UnTaxi
//
//  Created by Done Santana on 9/3/17.
//  Copyright © 2017 Done Santana. All rights reserved.
//

import UIKit
import SocketIO

class PerfilController: BaseController {
  
  var userperfil : CCliente!
  var NuevoTelefonoText: String = ""
  var NuevoEmailText: String = ""
  var ClaveActual: String = ""
  var NuevaClaveText: String = ""
  var ConfirmeClaveText: String = ""
  
  var login = [String]()
  
  var perfil2 : UITextField!
  
  @IBOutlet weak var perfilBackground: UIView!
  
  @IBOutlet weak var NombreApellidoText: UILabel!
  @IBOutlet weak var PerfilTable: UITableView!
  @IBOutlet weak var ActualizarBtn: UIButton!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    //self.navigationController?.navigationBar.tintColor = UIColor.black
    self.PerfilTable.addShadow()
    //self.perfilBackground.backgroundColor = Customization.primaryColor
    
    let readString = GlobalVariables.userDefaults.string(forKey: "\(Customization.nameShowed)-loginData") ?? ""
    
    self.login = String(readString).components(separatedBy: ",")
    
    self.ClaveActual = login[2]
    
    self.NombreApellidoText.text = GlobalVariables.cliente.nombreApellidos
    //MASK: - PARA MOSTRAR Y OCULTAR EL TECLADO
    //NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardNotification), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    
    GlobalVariables.socket.on("UpdateUser"){data, ack in
      let temporal = String(describing: data).components(separatedBy: ",")
      if temporal[1] == "ok"{
        let alertaDos = UIAlertController (title: "Perfil Actualizado", message: "Su perfil se actualizo con ÉXITO. Los cambios se verán reflejados una vez que vuelva ingresar a la aplicación.", preferredStyle: UIAlertController.Style.alert)
        alertaDos.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: {alerAction in
          let vc = R.storyboard.main.inicioView()
          self.navigationController?.show(vc!, sender: nil)
        }))
        
        self.present(alertaDos, animated: true, completion: nil)
      }else{
        let alertaDos = UIAlertController (title: "Error de Perfil", message: "Se produjo un ERROR al actualizar su perfil. Sus datos continuan sin cambios.", preferredStyle: UIAlertController.Style.alert)
        alertaDos.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: {alerAction in
          
        }))
        self.present(alertaDos, animated: true, completion: nil)
      }
    }
    
    
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.view.endEditing(true)
  }
  
  //FUNCIÓN ENVIAR AL SOCKET
  func EnviarSocket(_ datos: String){
    if CConexionInternet.isConnectedToNetwork() == true{
      if GlobalVariables.socket.status.active{
        GlobalVariables.socket.emit("data",datos)
      }
      else{
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
  //FUNCIONES ESCUCHAR SOCKET
  func ErrorConexion(){
    //self.CargarTelefonos()
    //AlertaSinConexion.isHidden = false
    
    let alertaDos = UIAlertController (title: "Sin Conexión", message: "No se puede conectar al servidor por favor revise su conexión a Internet.", preferredStyle: UIAlertController.Style.alert)
    alertaDos.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: {alerAction in
      exit(0)
    }))
    
    self.present(alertaDos, animated: true, completion: nil)
  }
  
  func EnviarActualizacion() {
    if self.NuevoTelefonoText == "" && self.NuevoEmailText == "" && self.NuevaClaveText == "" && self.ConfirmeClaveText == ""{
      let alertaDos = UIAlertController (title: "Mensaje Error", message: "Está tratando en enviar un formulario vacío. Por favor introduzca los valores que desea actualizar.", preferredStyle: UIAlertController.Style.alert)
      alertaDos.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: {alerAction in
        
      }))
      
      self.present(alertaDos, animated: true, completion: nil)
      
    }else{
      let datos = "#UpdateUser," + GlobalVariables.cliente.idUsuario + "," + GlobalVariables.cliente.user + "," + self.NuevoTelefonoText + "," + GlobalVariables.cliente.email + "," + self.NuevoEmailText + "," + self.ClaveActual + "," + self.NuevaClaveText + ",# \n"
      EnviarSocket(datos)
    }
  }
  
  override func homeBtnAction() {
    let vc = R.storyboard.main.inicioView()
    self.navigationController?.show(vc!, sender: nil)
  }
  
  
  @IBAction func ActualizarPerfil(_ sender: Any) {
    if self.ConfirmeClaveText != "Las Claves Nuevas no coinciden"{
      self.view.endEditing(true)
      self.EnviarActualizacion()
    }
  }
  
}
