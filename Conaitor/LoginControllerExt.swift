//
//  LoginControllerExt.swift
//  UnTaxi
//
//  Created by Donelkys Santana on 5/5/19.
//  Copyright © 2019 Done Santana. All rights reserved.
//

import Foundation
import UIKit


extension LoginController: UITextFieldDelegate{
  //MARK:- CONTROL DE TECLADO VIRTUAL
  //Funciones para mover los elementos para que no queden detrás del teclado
  func textFieldDidBeginEditing(_ textField: UITextField) {
    textField.textColor = Customization.textColor
    textField.text?.removeAll()
    if textField.isEqual(claveText) || textField.isEqual(Clave){
      animateViewMoving(true, moveValue: 80, view: self.view)
    }
    else{
      if textField.isEqual(movilClaveRecover){
        textField.text?.removeAll()
        animateViewMoving(true, moveValue: 105, view: self.view)
      }else{
        if textField.isEqual(confirmarClavText) || textField.isEqual(correoText){
          if textField.isEqual(confirmarClavText){
            textField.isSecureTextEntry = true
          }
          textField.tintColor = .black
          animateViewMoving(true, moveValue: 200, view: self.view)
        }else{
          if textField.isEqual(self.telefonoText){
            textField.textColor = .black
            //textField.text = ""
            animateViewMoving(true, moveValue: 70, view: self.view)
          }
        }
      }
    }
  }
  func textFieldDidEndEditing(_ textfield: UITextField) {
    textfield.text = textfield.text!.replacingOccurrences(of: ",", with: ".")
    if textfield.isEqual(claveText) || textfield.isEqual(Clave){
      animateViewMoving(false, moveValue: 80, view: self.view)
    }else{
      if textfield.isEqual(confirmarClavText) || textfield.isEqual(correoText){
        if textfield.text != claveText.text && textfield.isEqual(confirmarClavText){
          textfield.textColor = UIColor.red
          textfield.text = "Las claves no coinciden"
          textfield.isSecureTextEntry = false
          RegistroBtn.isEnabled = false
        }
        else{
          RegistroBtn.isEnabled = true
        }
        animateViewMoving(false, moveValue: 200, view: self.view)
      }else{
        if textfield.isEqual(telefonoText){
          
          if textfield.text?.count != 10{
            textfield.textColor = UIColor.red
            textfield.text = "Número de Teléfono Incorrecto"
          }
          animateViewMoving(false, moveValue: 70, view: self.view)
        }else{
          if textfield.isEqual(movilClaveRecover){
            if movilClaveRecover.text?.count != 10{
              textfield.text = "Número de Teléfono Incorrecto"
            }else{
              self.RecuperarClaveBtn.isEnabled = true
            }
            animateViewMoving(false, moveValue: 105, view: self.view)
          }
        }
      }
    }
  }
  
  @objc func textFieldDidChange(_ textField: UITextField) {
    
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
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.endEditing(true)
    if textField.isEqual(self.Clave){
      let loginData = "#LoginPassword," + self.Usuario.text! + "," + self.Clave.text! + ",# \n"
      //CREAR EL FICHERO DE LOGÍN
      //            let filePath = NSHomeDirectory() + "/Library/Caches/log.txt"
      //
      //            do {
      //                _ = try loginData.write(toFile: filePath, atomically: true, encoding: String.Encoding.utf8)
      //
      //            } catch {
      //
      //            }
      GlobalVariables.userDefaults.set(loginData, forKey: "\(Customization.nameShowed)-loginData")
      self.Login(loginData: loginData)
    }
    return true
  }
  
  @objc func ocultarTeclado(){
    self.ClaveRecover.endEditing(true)
    self.datosView.endEditing(true)
    self.RegistroView.endEditing(true)
  }
}

extension LoginController: ApiRequestDelegate{
  func apiRequest(_ controller: ApiRequestController, getLoginToken token: String) {
    self.apiRequestService.getServerConnectionData(token: token)
  }
  
  func apiRequest(_ controller: ApiRequestController, getServerData serverData: String) {
    print(serverData)
    Customization.serverData = "http://\(serverData)"
    self.connectToSocket()
  }
  
  
}
