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
        if textField.isEqual(self.NombreContactoText) || textField.isEqual(self.TelefonoContactoText){
            if textField.isEqual(self.TelefonoContactoText){
                self.TelefonoContactoText.textColor = UIColor.black
                if (self.NombreContactoText.text?.isEmpty)! || !self.SoloLetras(name: self.NombreContactoText.text!){
                    
                    let alertaDos = UIAlertController (title: "Contactar a otra persona", message: "Debe teclear el nombre de la persona que el conductor debe contactar.", preferredStyle: .alert)
                    alertaDos.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: {alerAction in
                        self.NombreContactoText.becomeFirstResponder()
                    }))
                    self.present(alertaDos, animated: true, completion: nil)
                }
            }
            self.animateViewMoving(true, moveValue: 190, view: view)
        }else{
            if textField.isEqual(self.origenText){
                if self.DireccionesArray.count != 0{
                    self.TablaDirecciones.frame = CGRect(x: 22, y: Int(self.origenText.frame.origin.y + self.origenText.frame.height), width: Int(self.origenText.frame.width - 2) , height: 44 * self.DireccionesArray.count)
                    self.TablaDirecciones.isHidden = false
                    self.RecordarView.isHidden = true
                }
            }else{
                if !(self.origenText.text?.isEmpty)!{
                    textField.text?.removeAll()
                    animateViewMoving(true, moveValue: 130, view: self.view)
                }else{
                    self.view.resignFirstResponder()
                    animateViewMoving(true, moveValue: 130, view: self.view)
                    let alertaDos = UIAlertController (title: "Dirección de Origen", message: "Debe teclear la dirección de recogida para orientar al conductor.", preferredStyle: .alert)
                    alertaDos.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: {alerAction in
                        self.origenText.becomeFirstResponder()
                    }))
                    
                    self.present(alertaDos, animated: true, completion: nil)
                }
            }
        }
    }
    
    func textFieldDidEndEditing(_ textfield: UITextField) {
        if textfield.isEqual(self.NombreContactoText) || textfield.isEqual(self.TelefonoContactoText){
            if textfield.isEqual(self.TelefonoContactoText) && textfield.text?.count != 10 && textfield.text?.count != 9 && !((self.NombreContactoText.text?.isEmpty)!){
                textfield.textColor = UIColor.red
                textfield.text = "Número de teléfono incorrecto"
            }
            self.animateViewMoving(false, moveValue: 190, view: view)
        }else{
            if textfield.isEqual(self.referenciaText) || textfield.isEqual(self.destinoText){
                self.animateViewMoving(false, moveValue: 130, view: view)
            }
        }
        self.TablaDirecciones.isHidden = true
        self.EnviarSolBtn.isEnabled = true
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField.text?.lengthOfBytes(using: .utf8) == 0{
            self.TablaDirecciones.isHidden = false
            self.RecordarView.isHidden = true
        }else{
            if self.DireccionesArray.count < 5 && textField.text?.lengthOfBytes(using: .utf8) == 1 {
                self.RecordarView.isHidden = false
                //NSLayoutConstraint(item: self.RecordarView, attribute: .bottom, relatedBy: .equal, toItem: self.referenciaText, attribute: .top, multiplier: 1, constant: -10).isActive = true
                //NSLayoutConstraint(item: self.origenText, attribute: .bottom, relatedBy: .equal, toItem: self.referenciaText, attribute: .top, multiplier: 1, constant: -(self.RecordarView.bounds.height + 20)).isActive = true
            }
            self.TablaDirecciones.isHidden = true
        }
        self.EnviarSolBtn.isEnabled = true
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

extension InicioController: UITableViewDelegate, UITableViewDataSource{
    //TABLA FUNCTIONS
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if tableView.isEqual(self.TablaDirecciones){
            return self.DireccionesArray.count
        }else{
            return self.MenuArray.count
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.isEqual(self.TablaDirecciones){
            let cell = tableView.dequeueReusableCell(withIdentifier: "CELL", for: indexPath)
            cell.textLabel?.text = self.DireccionesArray[indexPath.row][0]
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "MENUCELL", for: indexPath)
            cell.textLabel?.text = self.MenuArray[indexPath.row].title
            cell.imageView?.image = UIImage(named: self.MenuArray[indexPath.row].imagen)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.isEqual(self.TablaDirecciones){
            self.origenText.text = self.DireccionesArray[indexPath.row][0]
            self.TablaDirecciones.isHidden = true
            self.referenciaText.text = self.DireccionesArray[indexPath.row][1]
            self.origenText.resignFirstResponder()
        }else{
            self.MenuView1.isHidden = true
            self.TransparenciaView.isHidden = true
            tableView.deselectRow(at: indexPath, animated: false)
            switch tableView.cellForRow(at: indexPath)?.textLabel?.text{
            case "En proceso"?:
                if myvariables.solpendientes.count > 0{
                    let vc = UIStoryboard(name:"Main", bundle:nil).instantiateViewController(withIdentifier: "ListaSolPdtes") as! SolicitudesTableController
                    vc.solicitudesMostrar = myvariables.solpendientes
                    self.navigationController?.show(vc, sender: nil)
                }else{
                    self.SolPendientesView.isHidden = false
                }
            case "Call center"?:
                let vc = UIStoryboard(name:"Main", bundle:nil).instantiateViewController(withIdentifier: "CallCenter") as! CallCenterController
                vc.telefonosCallCenter = self.TelefonosCallCenter
                self.navigationController?.show(vc, sender: nil)
            case "Perfil"?:
                let vc = UIStoryboard(name:"Main", bundle:nil).instantiateViewController(withIdentifier: "Perfil") as! PerfilController
                self.navigationController?.show(vc, sender: nil)
            case "Compartir app"?:
                if let name = URL(string: GlobalConstants.itunesURL) {
                    let objectsToShare = [name]
                    let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
                    
                    self.present(activityVC, animated: true, completion: nil)
                }
                else
                {
                    // show alert for not available
                }
            case "Cerrar Sesion":
//                let fileManager = FileManager()
//                let filePath = NSHomeDirectory() + "/Library/Caches/log.txt"
//                do {
//                    try fileManager.removeItem(atPath: filePath)
//                }catch{
//
//                }
                myvariables.userDefaults.set(nil, forKey: "loginData")
                self.CloseAPP()
            default:
                self.CloseAPP()
            }
        }
    }
    
    //FUNCIONES Y EVENTOS PARA ELIMIMAR CELLS, SE NECESITA AGREGAR UITABLEVIEWDATASOURCE
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if tableView.isEqual(self.TablaDirecciones){
            return true
        }else{
            return false
        }
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Eliminar"
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            self.EliminarFavorita(posFavorita: indexPath.row)
            tableView.deleteRows(at: [indexPath as IndexPath], with: UITableView.RowAnimation.automatic)
            if self.DireccionesArray.count == 0{
                self.TablaDirecciones.isHidden = true
            }
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView.isEqual(self.MenuTable){
            return self.MenuTable.frame.height/CGFloat(self.MenuArray.count)
        }else{
            return 44
        }
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


