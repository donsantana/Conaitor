//
//  InicioControllerExtension.swift
//  UnTaxi
//
//  Created by Donelkys Santana on 2/16/19.
//  Copyright © 2019 Done Santana. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import MapKit
import GoogleMobileAds


extension InicioController: UITextFieldDelegate{
    //Funciones para mover los elementos para que no queden detrás del teclado
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text?.removeAll()
        if textField.isEqual(self.contactoCell.contactoNameText) || textField.isEqual(self.TelefonoContactoText){
            if textField.isEqual(self.TelefonoContactoText){
                self.TelefonoContactoText.textColor = UIColor.black
                if (self.contactoCell.contactoNameText.text?.isEmpty)! || !self.SoloLetras(name: self.contactoCell.contactoNameText.text!){
                    
                    let alertaDos = UIAlertController (title: "Contactar a otra persona", message: "Debe teclear el nombre de la persona que el conductor debe contactar.", preferredStyle: .alert)
                    alertaDos.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: {alerAction in
                        self.contactoCell.contactoNameText.becomeFirstResponder()
                    }))
                    self.present(alertaDos, animated: true, completion: nil)
                }
            }
            self.animateViewMoving(true, moveValue: 140, view: view)
        }else{
            if textField.isEqual(self.origenCell.origenText){
                if self.DireccionesArray.count != 0{
//                    self.TablaDirecciones.frame = CGRect(x: 22, y: Int(self.origenCell.origenText.frame.origin.y + self.origenCell.origenText.frame.height), width: Int(self.origenCell.origenText.frame.width - 2) , height: 44 * self.DireccionesArray.count)
//                    self.TablaDirecciones.isHidden = false
//                    self.RecordarView.isHidden = true
                }
            }else{
                if !(self.origenCell.origenText.text?.isEmpty)!{
                    textField.text?.removeAll()
                    //animateViewMoving(true, moveValue: 130, view: self.view)
                }else{
                    self.view.resignFirstResponder()
                    let alertaDos = UIAlertController (title: "Dirección de Origen", message: "Debe teclear la dirección de recogida para orientar al conductor.", preferredStyle: .alert)
                    alertaDos.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: {alerAction in
                        self.origenCell.origenText.becomeFirstResponder()
                    }))
                    
                    self.present(alertaDos, animated: true, completion: nil)
                }
            }
        }
      animateViewMoving(true, moveValue: 130, view: self.view)
    }
    
    func textFieldDidEndEditing(_ textfield: UITextField) {
        if textfield.isEqual(self.contactoCell.contactoNameText) || textfield.isEqual(self.TelefonoContactoText){
            if textfield.isEqual(self.TelefonoContactoText) && textfield.text?.count != 10 && textfield.text?.count != 9 && !((self.contactoCell.contactoNameText.text?.isEmpty)!){
                textfield.textColor = UIColor.red
                textfield.text = "Número de teléfono incorrecto"
            }
            self.animateViewMoving(false, moveValue: 140, view: view)
        }else{
            if textfield.isEqual(self.origenCell.referenciaText) || textfield.isEqual(self.origenCell.destinoText){
                self.animateViewMoving(false, moveValue: 130, view: view)
            }
        }
      self.animateViewMoving(false, moveValue: 130, view: view)
    }
    
//    @objc func textFieldDidChange(_ textField: UITextField) {
//        if textField.text?.lengthOfBytes(using: .utf8) == 0{
////            self.TablaDirecciones.isHidden = false
////            self.RecordarView.isHidden = true
//        }else{
//            if self.DireccionesArray.count < 5 && textField.text?.lengthOfBytes(using: .utf8) == 1 {
//                //self.RecordarView.isHidden = false
//                //NSLayoutConstraint(item: self.RecordarView, attribute: .bottom, relatedBy: .equal, toItem: self.origenCell.referenciaText, attribute: .top, multiplier: 1, constant: -10).isActive = true
//                //NSLayoutConstraint(item: self.origenCell.origenText, attribute: .bottom, relatedBy: .equal, toItem: self.origenCell.referenciaText, attribute: .top, multiplier: 1, constant: -(self.RecordarView.bounds.height + 20)).isActive = true
//            }
//            //self.TablaDirecciones.isHidden = true
//        }
//        //self.EnviarSolBtn.isEnabled = true
//    }
  
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
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



extension InicioController: MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var anotationView = mapaVista.dequeueReusableAnnotationView(withIdentifier: "annotationView")
        anotationView = MKAnnotationView(annotation: self.origenAnotacion, reuseIdentifier: "annotationView")
        if annotation.title! == "origen"{
            self.mapaVista.removeAnnotation(self.origenAnotacion)
            anotationView?.image = UIImage(named: "origen")
        }else{
            anotationView?.image = UIImage(named: "taxi_libre")
        }
        return anotationView
    }
    
    
    
    func mapView(_ mapView: MKMapView, rendererFor
        overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.green
        renderer.lineWidth = 4.0
        return renderer
    }
    
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        if SolicitarBtn.isHidden == false {
            self.miposicion.title = "origen"
            self.coreLocationManager.stopUpdatingLocation()
            self.mapaVista.removeAnnotations(self.mapaVista.annotations)
            self.SolPendientesView.isHidden = true
            self.origenIcono.isHidden = false
        }
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        origenIcono.isHidden = true
        if SolicitarBtn.isHidden == false {
            miposicion.coordinate = (self.mapaVista.centerCoordinate)
            origenAnotacion.title = "origen"
            mapaVista.addAnnotation(self.miposicion)
        }
    }
}

extension InicioController: GADBannerViewDelegate{
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("get the ads")
    }
    
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        print("Error receiving the ads")
    }
}


