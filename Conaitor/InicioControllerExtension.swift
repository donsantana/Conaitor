//
//  InicioControllerExtension.swift
//  Paraiso
//
//  Created by Donelkys Santana on 2/12/19.
//  Copyright © 2019 Done Santana. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import MapKit

extension InicioController: UITextFieldDelegate{
    
    //Funciones para mover los elementos para que no queden detrás del teclado
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if (self.origenText.text?.isEmpty)!{
            self.origenText.becomeFirstResponder()
        }
        
        self.animateViewMoving(true, moveValue: 110, view: view)
    }
    
    func textFieldDidEndEditing(_ textfield: UITextField) {
        self.EnviarSolBtn.isEnabled = true
        self.animateViewMoving(false, moveValue: 110, view: view)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField.isEqual(self.origenText) && (textField.text?.count)! > 1{
            self.EnviarSolBtn.isEnabled = true
        }
    }
    
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

extension InicioController: CLLocationManagerDelegate{
    
    //VERIFICAR PERMISO DE LOCALIZACION
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if (status == CLAuthorizationStatus.denied) || (status == CLAuthorizationStatus.restricted){
            let locationAlert = UIAlertController (title: "Error de Localización", message: "Estimado cliente es necesario que active la localización de su dispositivo.", preferredStyle: .alert)
            locationAlert.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: {alerAction in
                UIApplication.shared.openURL(NSURL(string:UIApplication.openSettingsURLString)! as URL)
                
            }))
            locationAlert.addAction(UIAlertAction(title: "No", style: .default, handler: {alerAction in
                exit(0)
            }))
            self.present(locationAlert, animated: true, completion: nil)
        } else if (status == CLAuthorizationStatus.authorizedWhenInUse) {
            coreLocationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.miposicion.coordinate = (locations.last?.coordinate)!
        self.mapaVista.addAnnotation(self.miposicion)
        let span = MKCoordinateSpan.init(latitudeDelta: 0.005, longitudeDelta: 0.005)
        let region = MKCoordinateRegion(center: self.miposicion.coordinate, span: span)
        self.mapaVista.setRegion(region, animated: true)
        self.SolicitarBtn.isHidden = false
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
            mapaVista.addAnnotation(self.miposicion)
        }
    }
    
}
