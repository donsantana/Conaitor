//
//  PerfilControllerExt.swift
//  UnTaxi
//
//  Created by Donelkys Santana on 5/5/19.
//  Copyright © 2019 Done Santana. All rights reserved.
//

import Foundation
import UIKit

extension PerfilController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = UITableViewCell()
        switch indexPath.row {
        case 0:
            cell = Bundle.main.loadNibNamed("PerfilViewCell", owner: self, options: nil)?.first as! PerfilViewCell
            (cell as! PerfilViewCell).ValorActual.text = GlobalVariables.cliente.user
            (cell as! PerfilViewCell).NuevoValor.delegate = self
        case 1:
            cell = Bundle.main.loadNibNamed("Perfil2ViewCell", owner: self, options: nil)?.first as! Perfil2ViewCell
            (cell as! Perfil2ViewCell).ValorActual.text = GlobalVariables.cliente.email
            (cell as! Perfil2ViewCell).NuevoValor.delegate = self
        case 2:
            cell = Bundle.main.loadNibNamed("Perfil3ViewCell", owner: self, options: nil)?.first as! Perfil3ViewCell
            (cell as! Perfil3ViewCell).ClaveActualText.text = self.ClaveActual
            //(cell as! Perfil3ViewCell).ClaveActualText.delegate = self
            (cell as! Perfil3ViewCell).NuevaClaveText.delegate = self
            (cell as! Perfil3ViewCell).ConfirmeClaveText.delegate = self
            
        default:
            cell = Bundle.main.loadNibNamed("PerfilViewCell", owner: self, options: nil)?.first as! PerfilViewCell
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 0:
            (tableView.cellForRow(at: indexPath) as! PerfilViewCell).ValorActual.isHidden = !(tableView.cellForRow(at: indexPath) as! PerfilViewCell).ValorActual.isHidden
            (tableView.cellForRow(at: indexPath) as! PerfilViewCell).NuevoValor.isHidden = !(tableView.cellForRow(at: indexPath) as! PerfilViewCell).NuevoValor.isHidden
            tableView.cellForRow(at: indexPath)?.isSelected = false
        case 1:
            (tableView.cellForRow(at: indexPath) as! Perfil2ViewCell).ValorActual.isHidden = !(tableView.cellForRow(at: indexPath) as! Perfil2ViewCell).ValorActual.isHidden
            (tableView.cellForRow(at: indexPath) as! Perfil2ViewCell).NuevoValor.isHidden = !(tableView.cellForRow(at: indexPath) as! Perfil2ViewCell).NuevoValor.isHidden
            tableView.cellForRow(at: indexPath)?.isSelected = false
        case 2:
            (tableView.cellForRow(at: indexPath) as! Perfil3ViewCell).ClaveActualText.isHidden = !(tableView.cellForRow(at: indexPath) as! Perfil3ViewCell).ClaveActualText.isHidden
            (tableView.cellForRow(at: indexPath) as! Perfil3ViewCell).NuevaClaveText.isHidden = !(tableView.cellForRow(at: indexPath) as! Perfil3ViewCell).NuevaClaveText.isHidden
            (tableView.cellForRow(at: indexPath) as! Perfil3ViewCell).ConfirmeClaveText.isHidden = !(tableView.cellForRow(at: indexPath) as! Perfil3ViewCell).ConfirmeClaveText.isHidden
            (tableView.cellForRow(at: indexPath) as! Perfil3ViewCell).NuevaClaveText.text?.removeAll()
            (tableView.cellForRow(at: indexPath) as! Perfil3ViewCell).ConfirmeClaveText.text?.removeAll()
            tableView.cellForRow(at: indexPath)?.isSelected = false
            
        default:
            (tableView.cellForRow(at: indexPath) as! PerfilViewCell).ValorActual.isHidden = true
            (tableView.cellForRow(at: indexPath) as! PerfilViewCell).NuevoValor.isHidden = false
            tableView.cellForRow(at: indexPath)?.isSelected = false
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 2{
            return 140
        }else{
            return 85
        }
    }
}

extension PerfilController: UITextFieldDelegate{
    //CONTROL DE TECLADO VIRTUAL
    //Funciones para mover los elementos para que no queden detrás del teclado
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.restorationIdentifier != "NuevoTelefono" && textField.restorationIdentifier != "NuevoCorreo"{
            animateViewMoving(true, moveValue: 180, view: self.view)
            textField.textColor = UIColor.black
            textField.text?.removeAll()
        }
    }
    func textFieldDidEndEditing(_ textfield: UITextField) {
        if !(textfield.text?.isEmpty)!{
            switch textfield.restorationIdentifier! {
            case "NuevoTelefono":
                self.NuevoTelefonoText = textfield.text!
            case "NuevoCorreo":
                self.NuevoEmailText = textfield.text!
            case "ClaveActual":
                self.ClaveActual = textfield.text!
            case "NuevaClave":
                self.NuevaClaveText = textfield.text!
            case "ConfirmeClave":
                if self.NuevaClaveText != textfield.text{
                    textfield.textColor = UIColor.red
                    textfield.text = "Las Claves Nuevas no coinciden"
                    self.ConfirmeClaveText = "Las Claves Nuevas no coinciden"
                    textfield.isSecureTextEntry = false
                }else{
                    textfield.isSecureTextEntry = true
                    self.ConfirmeClaveText = textfield.text!
                }
            default:
                self.ConfirmeClaveText = textfield.text!
            }
        }
        textfield.resignFirstResponder()
        if textfield.restorationIdentifier != "NuevoTelefono" && textfield.restorationIdentifier != "NuevoCorreo"{
            animateViewMoving(false, moveValue: 180, view: self.view)
        }
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        if textField.restorationIdentifier == "ConfirmeClave"{
            if self.ConfirmeClaveText != "Las Claves Nuevas no coinciden"{
                self.EnviarActualizacion()
            }
        }
        
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
    
    func keyboardNotification(notification: NSNotification){
        if let userInfo = notification.userInfo{
            let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let duration:TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
            if (endFrame?.origin.y)! >= UIScreen.main.bounds.size.height {
                animateViewMoving(false, moveValue: 180, view: self.view)//self.keyboardHeightLayoutConstraint?.constant = 0.0
            } else {
                animateViewMoving(true, moveValue: 180, view: self.view)//self.keyboardHeightLayoutConstraint?.constant = endFrame?.size.height ?? 0.0
            }
            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: { self.view.layoutIfNeeded() },
                           completion: nil)
        }
        //animateViewMoving(true, moveValue: 135, view: self.view)
    }
}

