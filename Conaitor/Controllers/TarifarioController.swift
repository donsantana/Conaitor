//
//  TarifarioController.swift
//  UnTaxi
//
//  Created by Done Santana on 27/2/17.
//  Copyright © 2017 Done Santana. All rights reserved.
//

import UIKit
import MapKit

class TarifarioController: UIViewController, CLLocationManagerDelegate, UITextViewDelegate, MKMapViewDelegate{
    
    var coreLocationManager : CLLocationManager!
    var OrigenTarifario: MKPointAnnotation!
    var DestinoTarifario: MKPointAnnotation!
    var tarifario = CTarifario()
    var tarifas = [CTarifa]()
    
    
    //MASK:- VARIABLES INTERFAZ
    
    @IBOutlet weak var origenIcono: UIImageView!
    @IBOutlet weak var ExplicacionView: UIView!
    @IBOutlet weak var ExplicacionText: UILabel!
    
    
    //@IBOutlet weak var MapaTarifario: GMSMapView!
    @IBOutlet weak var DestinoTarifarioBtn: UIButton!
    @IBOutlet weak var CalcularTarifarioBtn: UIButton!    
    @IBOutlet weak var ReinciarTarifarioBtn: UIButton!
    
    @IBOutlet weak var DetallesCarreraView: UIView!
    @IBOutlet weak var DistanciaText: UILabel!
    @IBOutlet weak var DuracionText: UILabel!
    @IBOutlet weak var CostoText: UILabel!
    
    @IBOutlet weak var TarifarioMap: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.TarifarioMap.delegate = self
        
        coreLocationManager = CLLocationManager()
        coreLocationManager.delegate = self
        coreLocationManager.requestWhenInUseAuthorization() //solicitud de autorización para acceder a la localización del usuario
        coreLocationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        coreLocationManager.startUpdatingLocation()  //Iniciar servicios de actualiación de localización del usuario
        self.OrigenTarifario = MKPointAnnotation()
        self.OrigenTarifario.coordinate = (coreLocationManager.location?.coordinate)!
        self.OrigenTarifario.title = "origen"
        
        let span = MKCoordinateSpanMake(0.005, 0.005)
        let region = MKCoordinateRegion(center: self.OrigenTarifario.coordinate, span: span)
        self.TarifarioMap.setRegion(region, animated: true)

        //self.TarifarioMap.addAnnotation(self.OrigenTarifario)
        self.tarifas = myvariables.tarifas
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var origenView = TarifarioMap.dequeueReusableAnnotationView(withIdentifier: "annotationView")
        origenView = MKAnnotationView(annotation: self.OrigenTarifario, reuseIdentifier: "annotationView")
        if annotation.title! == "origen"{
            origenView?.image = UIImage(named: "origen")
        }else{
            origenView?.image = UIImage(named: "destino")
        }
        return origenView
    }
    
    func mapView(_ mapView: MKMapView, rendererFor
        overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.green
        renderer.lineWidth = 4.0
        return renderer
    }
    
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        if ReinciarTarifarioBtn.isHidden == true{
            origenIcono.isHidden = false
            if DestinoTarifarioBtn.isHidden == false {
                TarifarioMap.removeAnnotation(OrigenTarifario)
                ExplicacionText.text = "Localice el origen en el mapa"
            }
            else{
                TarifarioMap.removeAnnotation(DestinoTarifario)
                ExplicacionText.text = "Localice el destino en el mapa"
            }
        }

    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        origenIcono.isHidden = true
        if DestinoTarifarioBtn.isHidden == false {
            self.TarifarioMap.removeAnnotation(self.OrigenTarifario)
            self.OrigenTarifario = MKPointAnnotation()
            self.OrigenTarifario.coordinate = (self.TarifarioMap.centerCoordinate)
            self.OrigenTarifario.title = "origen"
            self.TarifarioMap.addAnnotation(self.OrigenTarifario)
        }else{
            if CalcularTarifarioBtn.isHidden == false{
                self.DestinoTarifario.coordinate = (self.TarifarioMap.centerCoordinate)
                self.TarifarioMap.addAnnotations([self.OrigenTarifario,self.DestinoTarifario])
            }
        }
    }
    
    func DrawRoute(annotations: [MKPointAnnotation]) {
        let origenLocation = CLLocation(latitude: self.OrigenTarifario.coordinate.latitude, longitude: self.OrigenTarifario.coordinate.longitude)
        let destinoLocation = CLLocation(latitude: self.DestinoTarifario.coordinate.latitude, longitude: self.DestinoTarifario.coordinate.longitude)
        
        let distanciTarifario = origenLocation.distance(from: destinoLocation)
        
        let distanciaTemp = Double(distanciTarifario)/1000
        self.DistanciaText.text = "\(distanciaTemp)" + " KM"

        /*// Calculate Transit ETA Request
        let request = MKDirectionsRequest()
        /* Source MKMapItem */
        let origenItem = MKMapItem(placemark: MKPlacemark(coordinate: annotations[0].coordinate, addressDictionary: nil))
        request.source = origenItem
        /* Destination MKMapItem */
        let destinationItem = MKMapItem(placemark: MKPlacemark(coordinate: annotations[1].coordinate, addressDictionary: nil))
        request.destination = destinationItem
        request.requestsAlternateRoutes = false
        // Looking for Transit directions, set the type to Transit
        request.transportType = .automobile
        // Center the map region around the restaurant coordinates
        self.TarifarioMap.setCenter(self.OrigenTarifario.coordinate, animated: true)
        // You use the MKDirectionsRequest object constructed above to initialise an MKDirections object
        let directions = MKDirections(request: request)
        
        directions.calculate(completionHandler: { response, error in
            if error == nil{
                let route = response?.routes.first
                self.TarifarioMap.add((route?.polyline)!, level: MKOverlayLevel.aboveRoads)
                
                let rect = route?.polyline.boundingMapRect
                self.TarifarioMap.setRegion(MKCoordinateRegionForMapRect(rect!), animated: true)
                let distanciaTemp = Double((route?.distance)!)/1000
                self.DistanciaText.text = "\(distanciaTemp)" + " KM"
                let totalTime = Int((route?.expectedTravelTime)!)
                let mins = totalTime / 60
                let hours = mins / 60
                let remainingHours = hours % 24
                let remainingMins = mins % 60
                let remainingSecs = Int((route?.expectedTravelTime)!) % 60
                
                let totalDuration = "\(remainingHours)h:\(remainingMins)m:\(remainingSecs)s"
                self.DuracionText.text = "\(totalDuration)"
                self.DetallesCarreraView.isHidden = false
            }else{
                print("Error: \(String(describing: error))")
            }
        })*/
    }

    //MASK:- FUNCIONES PROPIAS
    
    //MOSTRAR TODOS LOS MARCADORES EN PANTALLA
    /*func fitAllMarkers(_ markers: [GMSMarker]) {
        var bounds = GMSCoordinateBounds()
        for marcador in markers{
            bounds = bounds.includingCoordinate(marcador.position)
        }
        MapaTarifario.animate(with: GMSCameraUpdate.fit(bounds))
    }*/

    // MARK: - BOTONES
    //BOTONES DEL TARIFARIO
    @IBAction func DestinoTarifario(_ sender: AnyObject) {
        self.DestinoTarifario = MKPointAnnotation()
        self.OrigenTarifario.coordinate = (self.TarifarioMap.centerCoordinate)
        self.tarifario.InsertarOrigen(OrigenTarifario.coordinate)
        self.TarifarioMap.addAnnotation(OrigenTarifario)
        origenIcono.image = UIImage(named: "destino2@2x")
        ExplicacionText.text = "Localice el destino"
        DestinoTarifarioBtn.isHidden = true
        CalcularTarifarioBtn.isHidden = false
    }
    
    @IBAction func CalcularTarifario(_ sender: AnyObject) {
        self.DestinoTarifario.coordinate = (self.TarifarioMap.centerCoordinate)
        self.tarifario.InsertarDestino(DestinoTarifario.coordinate)
        self.TarifarioMap.addAnnotation(self.DestinoTarifario)
        //self.fitAllMarkers([self.OrigenTarifario, self.DestinoTarifario])
        origenIcono.isHidden = true
        ExplicacionView.isHidden = true
        ReinciarTarifarioBtn.isHidden = false
        CalcularTarifarioBtn.isHidden = true
        
        //self.DrawRoute(annotations: [self.OrigenTarifario, self.DestinoTarifario])
        let temporal = self.tarifario.CalcularTarifa(tarifas)
        DetallesCarreraView.isHidden = false
        //let lines = self.tarifario.CalcularRuta()
        //lines.strokeWidth = 5
        //lines.map = self.MapaTarifario
        //lines.strokeColor = UIColor.green
        DistanciaText.text = temporal[0] + " KM"
        //DuracionText.text = temporal[1]
        CostoText.text = "$" + temporal[1]
        
    }
    
    @IBAction func ReiniciarTarifario(_ sender: AnyObject) {
        origenIcono.image = UIImage(named: "origen2@2x")
        self.TarifarioMap.removeAnnotations([self.OrigenTarifario, self.DestinoTarifario])
        let span = MKCoordinateSpanMake(0.005, 0.005)
        let region = MKCoordinateRegion(center: (coreLocationManager.location?.coordinate)!, span: span)
        self.TarifarioMap.setRegion(region, animated: true)
        self.TarifarioMap.showAnnotations([self.OrigenTarifario], animated: true)
        ExplicacionView.isHidden = false
        DetallesCarreraView.isHidden = true
        ReinciarTarifarioBtn.isHidden = true
        DestinoTarifarioBtn.isHidden = false
        //self.OrigenTarifario = GMSMarker(position: self.MapaTarifario.camera.target)
       // OrigenTarifario.icon = UIImage(named: "origen")
        //OrigenTarifario.map = MapaTarifario
        ExplicacionText.text = "Localice el origen en el mapa"
    }



}
