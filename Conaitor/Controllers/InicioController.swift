//
//  InicioController.swift
//  Conaitor
//
//  Created by Done Santana on 2/3/17.
//  Copyright © 2017 Done Santana. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import MapKit
import SocketIO
import AVFoundation
import MaterialComponents.MaterialTextFields

class InicioController: UIViewController, URLSessionDelegate, URLSessionTaskDelegate, URLSessionDataDelegate, UIApplicationDelegate, AVAudioPlayerDelegate {
    var coreLocationManager : CLLocationManager!
    var miposicion = MKPointAnnotation()
    var origenAnotacion = MKPointAnnotation()
    var taxiLocation = MKPointAnnotation()

    var taxi : CTaxi!
    var login = [String]()
    var idusuario : String = ""
    var indexselect = Int()
    var contador = 0
    var centro = CLLocationCoordinate2D()
    var TelefonosCallCenter = [CTelefono]()
    var opcionAnterior : IndexPath!
    var evaluacion: CEvaluacion!
    var taxiscercanos = [MKPointAnnotation]()
    //var SMSVoz = CSMSVoz()
    
    //Reconect Timer
    var timer = Timer()

    
    
    var tiempoTemporal = 10
    
    var emitTimer = Timer()
    var EnviosCount = 0

    //variables de interfaz
    
    @IBOutlet weak var origenIcono: UIImageView!
    @IBOutlet weak var mapaVista: MKMapView!
    

    @IBOutlet weak var LocationBtn: UIButton!
    @IBOutlet weak var SolicitarBtn: UIButton!
    
    
    @IBOutlet weak var formularioSolicitud: UIView!
    @IBOutlet weak var origenText: UITextField!
    @IBOutlet weak var referenciaText: UITextField!
    @IBOutlet weak var voucherView: UIView!
    @IBOutlet weak var voucherCheck: UISwitch!
    
    @IBOutlet weak var EnviarSolBtn: UIButton!

    
    //MENU BUTTONS
    @IBOutlet weak var MenuView: UIView!
    @IBOutlet weak var CallCEnterBtn: UIButton!
    @IBOutlet weak var SolPendientesBtn: UIButton!
    @IBOutlet weak var MapaBtn: UIButton!
    @IBOutlet weak var SolPendImage: UIImageView!
    @IBOutlet weak var CantSolPendientes: UILabel!
    @IBOutlet weak var SolPendientesView: UIView!
    
    @IBOutlet weak var AlertaEsperaView: UIView!
    @IBOutlet weak var MensajeEspera: UITextView!
    
    
    //Tarifario
    
    @IBOutlet weak var CancelarSolicitudProceso: UIButton!
    
    var TimerTemporal = Timer()

    override func viewDidLoad() {
        super.viewDidLoad()
        //LECTURA DEL FICHERO PARA AUTENTICACION
        
        mapaVista.delegate = self
        coreLocationManager = CLLocationManager()
        coreLocationManager.delegate = self
        self.origenText.delegate = self as UITextFieldDelegate
        self.referenciaText.delegate = self as UITextFieldDelegate
        
        self.origenAnotacion.title = "origen"
        
        if CLLocationManager.locationServicesEnabled(){
            switch(CLLocationManager.authorizationStatus()) {
            case .notDetermined, .restricted, .denied:
                coreLocationManager.requestWhenInUseAuthorization()
            case .authorizedAlways, .authorizedWhenInUse:
            
            break
                
            }
        }else{
            let locationAlert = UIAlertController (title: "Error de Localización", message: "Estimado cliente es necesario que active la localización de su dispositivo.", preferredStyle: .alert)
            locationAlert.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: {alerAction in
                if #available(iOS 10.0, *) {
                    let settingsURL = URL(string: UIApplication.openSettingsURLString)!
                    UIApplication.shared.open(settingsURL, options: [:], completionHandler: { success in
                        exit(0)
                    })
                } else {
                    if let url = NSURL(string:UIApplication.openSettingsURLString) {
                        UIApplication.shared.openURL(url as URL)
                        exit(0)
                    }
                }
            }))
            locationAlert.addAction(UIAlertAction(title: "No", style: .default, handler: {alerAction in
            exit(0)
            }))
            self.present(locationAlert, animated: true, completion: nil)

        }
        
        self.origenText.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        self.referenciaText.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        //solicitud de autorización para acceder a la localización del usuario
        coreLocationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        coreLocationManager.startUpdatingLocation()  //Iniciar servicios de actualiación de localización del usuario

        if let tempLocation = self.coreLocationManager.location?.coordinate{
            self.origenAnotacion.coordinate = (coreLocationManager.location?.coordinate)!
        }else{
            coreLocationManager.requestWhenInUseAuthorization()
            //self.origenAnotacion.coordinate = (CLLocationCoordinate2D(latitude: -2.173714, longitude: -79.921601))
        }
        
        //UBICAR LOS BOTONES DEL MENU
        var espacioBtn = self.view.frame.width/4
        self.CallCEnterBtn.frame = CGRect(x: espacioBtn - 40, y: 5, width: 44, height: 44)
        self.SolPendientesBtn.frame = CGRect(x: (espacioBtn * 2 - 25), y: 5, width: 44, height: 44)
        self.MapaBtn.frame = CGRect(x: (espacioBtn * 3 - 10), y: 5, width: 44, height: 44)
        self.SolPendImage.frame = CGRect(x: (espacioBtn * 2 - 2), y: 5, width: 25, height: 22)
        self.CantSolPendientes.frame = CGRect(x: (espacioBtn * 2 - 2), y: 5, width: 25, height: 22)

        
        if myvariables.solpendientes.count > 0{
            self.CantSolPendientes.isHidden = false
            self.CantSolPendientes.text = String(myvariables.solpendientes.count)
            self.SolPendImage.isHidden = false
        }
        
        if myvariables.socket.status.active{
            let ColaHilos = OperationQueue()
            let Hilos : BlockOperation = BlockOperation ( block: {
                self.SocketEventos()
                self.timer.invalidate()
                let url = "#U,# \n"
                self.EnviarSocket(url)
                let telefonos = "#Telefonos,# \n"
                self.EnviarSocket(telefonos)
                let datos = "OT"
                self.EnviarSocket(datos)
                if myvariables.solpendientes.count > 0{
                     self.CantSolPendientes.isHidden = false
                     self.CantSolPendientes.text = String(myvariables.solpendientes.count)
                     self.SolPendImage.isHidden = false
                }
            })
            ColaHilos.addOperation(Hilos)
        }else{
            self.Reconect()
        }
        
        //PEDIR PERMISO PARA MICROPHONE
        switch AVAudioSession.sharedInstance().recordPermission {
        case AVAudioSession.RecordPermission.granted:
            print("Permission granted")
        case AVAudioSession.RecordPermission.denied:
            print("Pemission denied")
        case AVAudioSession.RecordPermission.undetermined:
            AVAudioSession.sharedInstance().requestRecordPermission({(granted: Bool)-> Void in
                if granted {
                    
                } else{
                    
                }
            })
        default:
            break
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.referenciaText.resignFirstResponder()
    }
    
    //MARK:- FUNCIONES PROPIAS
    func appUpdateAvailable() -> Bool
    {
        let storeInfoURL: String = "http://itunes.apple.com/lookup?bundleId=com.donelkys.Conaitor"
        var upgradeAvailable = false
        
        // Get the main bundle of the app so that we can determine the app's version number
        let bundle = Bundle.main
        if let infoDictionary = bundle.infoDictionary {
            // The URL for this app on the iTunes store uses the Apple ID for the  This never changes, so it is a constant
            let urlOnAppStore = URL(string: storeInfoURL)
            if let dataInJSON = try? Data(contentsOf: urlOnAppStore!) {
                // Try to deserialize the JSON that we got
                if let lookupResults = try? JSONSerialization.jsonObject(with: dataInJSON, options: JSONSerialization.ReadingOptions()) as! Dictionary<String, Any>{
                    // Determine how many results we got. There should be exactly one, but will be zero if the URL was wrong
                    if let resultCount = lookupResults["resultCount"] as? Int {
                        if resultCount == 1 {
                            // Get the version number of the version in the App Store
                            //self.selectedRoute = (dictionary["routes"] as! Array<Dictionary<String, AnyObject>>)[0]
                            if let appStoreVersion = (lookupResults["results"]as! Array<Dictionary<String, AnyObject>>)[0]["version"] as? String {
                                // Get the version number of the current version
                                if let currentVersion = infoDictionary["CFBundleShortVersionString"] as? String {
                                    // Check if they are the same. If not, an upgrade is available.
                                    if appStoreVersion > currentVersion {
                                        upgradeAvailable = true
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        ///Volumes/Datos/Ecuador/Desarrollo/Conaitor/Conaitor/LocationManager.swift:635:31: Ambiguous use of 'indexOfObject'
        return upgradeAvailable
    }
    
    func SocketEventos(){
        //Evento sockect para escuchar
        //TRAMA IN: #LoginPassword,loginok,idusuario,idrol,idcliente,nombreapellidos,cantsolpdte,idsolicitud,idtaxi,cod,fechahora,lattaxi,lngtaxi,latorig,lngorig,latdest,lngdest,telefonoconductor
        if self.appUpdateAvailable(){
            
            let alertaVersion = UIAlertController (title: "Versión de la aplicación", message: "Estimado cliente es necesario que actualice a la última versión de la aplicación disponible en la AppStore. ¿Desea hacerlo en este momento?", preferredStyle: .alert)
            alertaVersion.addAction(UIAlertAction(title: "Si", style: .default, handler: {alerAction in
                
                UIApplication.shared.openURL(URL(string: "itms://itunes.apple.com/us/app/apple-store/id1391455068?mt=8")!)
            }))
            alertaVersion.addAction(UIAlertAction(title: "No", style: .default, handler: {alerAction in
                exit(0)
            }))
            self.present(alertaVersion, animated: true, completion: nil)

        }
        
        
        myvariables.socket.on("LoginPassword"){data, ack in
            let temporal = String(describing: data).components(separatedBy: ",")

            if (temporal[0] == "[#LoginPassword") || (temporal[0] == "#LoginPassword"){
                myvariables.solpendientes = [CSolicitud]()
                self.contador = 0
                switch temporal[1]{
                case "loginok":
                    let url = "#U,# \n"
                    self.EnviarSocket(url)
                    let telefonos = "#Telefonos,# \n"
                    self.EnviarSocket(telefonos)
                    self.idusuario = temporal[2]
                    self.SolicitarBtn.isHidden = false
                    //self.LoginView.isHidden = true
                    //self.LoginView.endEditing(true)
                    myvariables.cliente = CCliente(idUsuario: temporal[2],idcliente: temporal[4], user: self.login[1], nombre: temporal[5],email : temporal[3], empresa: temporal[temporal.count - 2])
                    if temporal[6] != "0"{
                        self.ListSolicitudPendiente(temporal)
                    }
                    
                case "loginerror":
                    let fileManager = FileManager()
                    let filePath = NSHomeDirectory() + "/Library/Caches/log.txt"
                    do {
                        try fileManager.removeItem(atPath: filePath)
                    }catch{
                        
                    }
                    
                    let alertaDos = UIAlertController (title: "Autenticación", message: "Usuario y/o clave incorrectos", preferredStyle: UIAlertController.Style.alert)
                    alertaDos.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: {alerAction in
                        
                    }))
                    self.present(alertaDos, animated: true, completion: nil)
                case "version":
                    let alertaDos = UIAlertController (title: "Versión de la aplicación", message: "Estimado cliente es necesario que actualice a la última versión de la aplicación disponible en la AppStore. Desea hacerlo en este momento:", preferredStyle: UIAlertController.Style.alert)
                    alertaDos.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: {alerAction in
                        
                    }))
                    alertaDos.addAction(UIAlertAction(title: "Cancelar", style: .default, handler: {alerAction in
                        
                    }))
                    self.present(alertaDos, animated: true, completion: nil)
                default: print("Problemas de conexion")
                }
            }
            else{
                //exit(0)
            }
        }
        
        //Evento Posicion de taxis
        myvariables.socket.on("Posicion"){data, ack in
            let temporal = String(describing: data).components(separatedBy: ",")

            if(temporal[1] == "0") {
                self.origenText.endEditing(true)
                self.formularioSolicitud.isHidden = true
                self.Inicio()
                let alertaDos = UIAlertController(title: "Solicitud de Taxi", message: "No hay taxis disponibles en este momento, espere unos minutos y vuelva a intentarlo.", preferredStyle: UIAlertController.Style.alert )
                alertaDos.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: {alerAction in

                }))
                
                self.present(alertaDos, animated: true, completion: nil)
            }else{
                self.MostrarTaxi(temporal)
            }
        }
        
        //Respuesta de la solicitud enviada
        myvariables.socket.on("Solicitud"){data, ack in
            //Trama IN: #Solicitud, ok, idsolicitud, fechahora
            //Trama IN: #Solicitud, error
            self.EnviarTimer(estado: 0, datos: "terminando")
            let temporal = String(describing: data).components(separatedBy: ",")
            if temporal[1] == "ok"{
                self.MensajeEspera.text = "Solicitud enviada a todos los taxis cercanos. Esperando respuesta de un conductor."
                self.AlertaEsperaView.isHidden = false
                self.CancelarSolicitudProceso.isHidden = false
                self.ConfirmaSolicitud(temporal)
            }
            else{

            }
        }
        
        //ACTIVACION DEL TAXIMETRO
        myvariables.socket.on("TI"){data, ack in
            let temporal = String(describing: data).components(separatedBy: ",")
            if myvariables.solpendientes.count != 0 {
                //self.MensajeEspera.text = temporal
                //self.AlertaEsperaView.hidden = false
                for solicitudpendiente in myvariables.solpendientes{
                    if (temporal[2] == solicitudpendiente.idTaxi){
                        let alertaDos = UIAlertController (title: "Taximetro Activado", message: "Estimado Cliente: El conductor ha iniciado el Taximetro a las: \(temporal[1]).", preferredStyle: .alert)
                        alertaDos.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: {alerAction in
                            
                        }))
                        self.present(alertaDos, animated: true, completion: nil)
                        }
                    }
                }
        }

    
        //RESPUESTA DE CANCELAR SOLICITUD
        myvariables.socket.on("Cancelarsolicitud"){data, ack in
            let temporal = String(describing: data).components(separatedBy: ",")
            if temporal[1] == "ok"{
                let alertaDos = UIAlertController (title: "Cancelar Solicitud", message: "Su solicitud fue cancelada.", preferredStyle: UIAlertController.Style.alert)
                alertaDos.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: {alerAction in
                    if myvariables.solpendientes.count != 0{
                        self.SolPendientesView.isHidden = true
                        self.CantSolPendientes.text = String(myvariables.solpendientes.count)
                    }
                    else{
                        self.SolPendImage.isHidden = true
                    }
                    self.Inicio()
                }))
                
                self.present(alertaDos, animated: true, completion: nil)
                
            }
        }
        
        //RESPUESTA DE CONDUCTOR A SOLICITUD
        
        myvariables.socket.on("Aceptada"){data, ack in
            self.Inicio()
            let temporal = String(describing: data).components(separatedBy: ",")
            //#Aceptada, idsolicitud, idconductor, nombreApellidosConductor, movilConductor, URLfoto, idTaxi, Codvehiculo, matricula, marca, color, latTaxi, lngTaxi
            if temporal[0] == "#Aceptada" || temporal[0] == "[#Aceptada"{
                var i = 0
                while myvariables.solpendientes[i].idSolicitud != temporal[1] && i < myvariables.solpendientes.count{
                    i += 1
                }
                if myvariables.solpendientes[i].idSolicitud == temporal[1]{
                    
                    let solicitud = myvariables.solpendientes[i]
                    solicitud.DatosTaxiConductor(idtaxi: temporal[6], matricula: temporal[8], codigovehiculo: temporal[7], marcaVehiculo: temporal[9],colorVehiculo: temporal[10], lattaxi: temporal[11], lngtaxi: temporal[12], idconductor: temporal[2], nombreapellidosconductor: temporal[3], movilconductor: temporal[4], foto: temporal[5])
                    
                    let vc = UIStoryboard(name:"Main", bundle:nil).instantiateViewController(withIdentifier: "SolPendientes") as! SolPendController
                    vc.SolicitudPendiente = solicitud
                    vc.posicionSolicitud = myvariables.solpendientes.count - 1
                    self.navigationController?.show(vc, sender: nil)
                    
                        /*let alertaDos = UIAlertController (title: "Solicitud Aceptada", message: "Su vehículo se encuentra en camino, siga su trayectoria en el mapa y/o comuníquese con el conductor.", preferredStyle: .alert)
                        alertaDos.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: {alerAction in
                            

                        }))
                    
                        self.present(alertaDos, animated: true, completion: nil)*/
                    }
            }
            else{
                if temporal[0] == "#Cancelada" {
                    //#Cancelada, idsolicitud
                    let alertaDos = UIAlertController (title: "Estado de Solicitud", message: "Ningún vehículo aceptó su solicitud, puede intentarlo más tarde.", preferredStyle: .alert)
                    alertaDos.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: {alerAction in
                        
                    }))
                    
                    self.present(alertaDos, animated: true, completion: nil)
                }
            }
        }
        
        myvariables.socket.on("Completada"){data, ack in
            //'#Completada,'+idsolicitud+,# \n'
            let temporal = String(describing: data).components(separatedBy: ",")
            
            if myvariables.solpendientes.count != 0{
                let pos = self.BuscarPosSolicitudID(temporal[1])
                myvariables.solpendientes.remove(at: pos)
                if myvariables.solpendientes.count != 0{
                    self.SolPendientesView.isHidden = true
                    self.CantSolPendientes.text = String(myvariables.solpendientes.count)
                }else{
                    self.SolPendImage.isHidden = true
                }

                let vc = UIStoryboard(name:"Main", bundle:nil).instantiateViewController(withIdentifier: "completadaView") as! CompletadaController
                vc.idSolicitud = temporal[1]
                self.navigationController?.show(vc, sender: nil)
            }
        }
        
        myvariables.socket.on("Cambioestadosolicitudconductor"){data, ack in
            let temporal = String(describing: data).components(separatedBy: ",")
            let alertaDos = UIAlertController (title: "Estado de Solicitud", message: "Solicitud cancelada por el conductor.", preferredStyle: UIAlertController.Style.alert)
            alertaDos.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: {alerAction in
                var pos = -1
                pos = self.BuscarPosSolicitudID(temporal[1])
                if  pos != -1{
                    self.CancelarSolicitudes("Conductor")
                }
                let vc = UIStoryboard(name:"Main", bundle:nil).instantiateViewController(withIdentifier: "Inicio") as! InicioController
                self.navigationController?.show(vc, sender: nil)
            }))
            
            self.present(alertaDos, animated: true, completion: nil)
        }
        //SOLICITUDES SIN RESPUESTA DE TAXIS
        myvariables.socket.on("SNA"){data, ack in
            let temporal = String(describing: data).components(separatedBy: ",")
            if myvariables.solpendientes.count != 0{
                for solicitudenproceso in myvariables.solpendientes{
                    if solicitudenproceso.idSolicitud == temporal[1]{
                        let alertaDos = UIAlertController (title: "Estado de Solicitud", message: "No se encontó ningún taxi disponible para ejecutar su solicitud. Por favor inténtelo más tarde.", preferredStyle: UIAlertController.Style.alert)
                        alertaDos.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: {alerAction in
                            self.CancelarSolicitudes("")
                        }))
                        
                        self.present(alertaDos, animated: true, completion: nil)
                    }
                }
            }
        }
        
        //URl PARA AUDIO
        myvariables.socket.on("U"){data, ack in
            let temporal = String(describing: data).components(separatedBy: ",")
            myvariables.UrlSubirVoz = temporal[1]
        }
        
        myvariables.socket.on("V"){data, ack in
            print("conductor message")
            let temporal = String(describing: data).components(separatedBy: ",")
            myvariables.urlconductor = temporal[1]
            
            if UIApplication.shared.applicationState != .background {
                if !myvariables.grabando{
                    myvariables.SMSProceso = true
                    myvariables.SMSVoz.ReproducirMusica()
                    myvariables.SMSVoz.ReproducirVozConductor(myvariables.urlconductor)
                }
            }else{
                if myvariables.SMSProceso{
                    myvariables.SMSVoz.ReproducirMusica()
                    myvariables.SMSVoz.ReproducirVozConductor(myvariables.urlconductor)
                }else{
                    let session = AVAudioSession.sharedInstance()
                }
                let localNotification = UILocalNotification()
                localNotification.alertAction = "Mensaje del Conductor"
                localNotification.alertBody = "Mensaje del Conductor. Abra la aplicación para escucharlo."
                localNotification.fireDate = Date(timeIntervalSinceNow: 4)
                UIApplication.shared.scheduleLocalNotification(localNotification)
            }
        }
        
        myvariables.socket.on("disconnect"){data, ack in
            self.timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(InicioController.Reconect), userInfo: nil, repeats: true)
        }
        
        myvariables.socket.on("connect"){data, ack in
            let ColaHilos = OperationQueue()
            let Hilos : BlockOperation = BlockOperation ( block: {
                self.SocketEventos()
                self.timer.invalidate()
            })
            ColaHilos.addOperation(Hilos)
            var read = "Vacio"
            //var vista = ""
            let filePath = NSHomeDirectory() + "/Library/Caches/log.txt"
            do {
                read = try NSString(contentsOfFile: filePath, encoding: String.Encoding.utf8.rawValue) as String
            }catch {
                
            }
            
        }
        
        myvariables.socket.on("Telefonos"){data, ack in
            //#Telefonos,cantidad,numerotelefono1,operadora1,siesmovil1,sitienewassap1,numerotelefono2,operadora2..,#
            self.TelefonosCallCenter = [CTelefono]()
            let temporal = String(describing: data).components(separatedBy: ",")
            if temporal[1] != "0"{
                var i = 2
                while i <= temporal.count - 4{
                    let telefono = CTelefono(numero: temporal[i], operadora: temporal[i + 1], esmovil: temporal[i + 2], tienewhatsapp: temporal[i + 3])
                    self.TelefonosCallCenter.append(telefono)
                    i += 4
                }
            }
        }
        
        //RECUPERAR CLAVES
        myvariables.socket.on("Recuperarclave"){data, ack in
            let temporal = String(describing: data).components(separatedBy: ",")
            if temporal[1] == "ok"{
                let alertaDos = UIAlertController (title: "Recuperación de clave", message: "Su clave ha sido recuperada satisfactoriamente, en este momento ha recibido un correo electronico a la dirección: " + temporal[2], preferredStyle: UIAlertController.Style.alert)
                alertaDos.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: {alerAction in
                }))
                
                self.present(alertaDos, animated: true, completion: nil)
            }
            
        }
        
        //CAMBIAR CLAVE
        /*#Cambiarclave,idusuario,claveold,clavenew
         evento Cambiarclave
         retorno #Cambiarclave,ok
         #Cambiarclave,error*/
        myvariables.socket.on("Cambiarclave"){data, ack in
            let temporal = String(describing: data).components(separatedBy: ",")
            if temporal[1] == "ok"{
                let alertaDos = UIAlertController (title: "Cambio de clave", message: "Su clave ha sido cambiada satisfactoriamente", preferredStyle: UIAlertController.Style.alert)
                alertaDos.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: {alerAction in

                }))
                
                self.present(alertaDos, animated: true, completion: nil)
                
            }else{
                let alertaDos = UIAlertController (title: "Cambio de clave", message: "Se produjo un error al cambiar su clave. Revise la información ingresada e inténtelo más tarde.", preferredStyle: UIAlertController.Style.alert)
                alertaDos.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: {alerAction in

                }))
                
                self.present(alertaDos, animated: true, completion: nil)
            }
            
        }
    }
    
    func getAddress(coordinate: CLLocationCoordinate2D){
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        var address = ""
        geoCoder.reverseGeocodeLocation(location){[weak self] (placemarks, error) in
            guard let self = self else { return }
            
            if let _ = error {
                //TODO: Show alert informing the user
                return
            }
            
            guard let placemark = placemarks?.first else {
                //TODO: Show alert informing the user
                return
            }
            
            let streetNumber = placemark.subThoroughfare ?? ""
            let streetName = placemark.thoroughfare ?? ""
            let city = placemark.locality ?? ""
            
            DispatchQueue.main.async {
                //self.origenText.text = "\(streetName), \(city)"
            }
            
        }
    }
    
    //RECONECT SOCKET
    @objc func Reconect(){
        if contador <= 5 {
            myvariables.socket.connect()
            contador += 1
        }
        else{
            let alertaDos = UIAlertController (title: "Sin Conexión", message: "No se puede conectar al servidor por favor intentar otra vez.", preferredStyle: UIAlertController.Style.alert)
            alertaDos.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: {alerAction in
                exit(0)
            }))
            
            self.present(alertaDos, animated: true, completion: nil)
        }
    }

    //FUNCTION ENVIO CON TIMER
    func EnviarTimer(estado: Int, datos: String){
        if estado == 1{
            self.EnviarSocket(datos)
            if !self.emitTimer.isValid{
                self.emitTimer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(EnviarSocket1(_:)), userInfo: ["datos": datos], repeats: true)
            }
        }else{
            self.emitTimer.invalidate()
            self.EnviosCount = 0
        }
    }
    
    //FUNCIÓN ENVIAR AL SOCKET
    func EnviarSocket(_ datos: String){
        
        if CConexionInternet.isConnectedToNetwork() == true{
            if myvariables.socket.status.active{
                myvariables.socket.emit("data",datos)
            }else{
                let alertaDos = UIAlertController (title: "Sin Conexión", message: "No se puede conectar al servidor por favor intentar otra vez.", preferredStyle: UIAlertController.Style.alert)
                alertaDos.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: {alerAction in
                    exit(0)
                }))
                
                self.present(alertaDos, animated: true, completion: nil)
            }
        }else{
            ErrorConexion()
        }
    }
    
    @objc func EnviarSocket1(_ timer: Timer){
       
        if CConexionInternet.isConnectedToNetwork() == true{
            if myvariables.socket.status.active && self.EnviosCount <= 3 {
                self.EnviosCount += 1
                let userInfo = timer.userInfo as! Dictionary<String, AnyObject>
                var datos = (userInfo["datos"] as! String)
                myvariables.socket.emit("data",datos)
            }else{
                let alertaDos = UIAlertController (title: "Sin Conexión", message: "No se puede conectar al servidor por favor intentar otra vez.", preferredStyle: UIAlertController.Style.alert)
                alertaDos.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: {alerAction in
                    self.EnviarTimer(estado: 0, datos: "Terminado")
                    exit(0)
                }))
                self.present(alertaDos, animated: true, completion: nil)
            }
        }else{
            ErrorConexion()
        }
    }
    
    func Inicio(){
        mapaVista.removeAnnotations(self.mapaVista.annotations)
        self.coreLocationManager.startUpdatingLocation()
        self.origenAnotacion.coordinate = (self.coreLocationManager.location?.coordinate)!
        self.origenIcono.image = UIImage(named: "origen2")
        self.origenIcono.isHidden = true
        self.origenAnotacion.title = "origen"
        let span = MKCoordinateSpan.init(latitudeDelta: 0.005, longitudeDelta: 0.005)
        let region = MKCoordinateRegion(center: self.origenAnotacion.coordinate, span: span)
        self.mapaVista.setRegion(region, animated: true)
        self.mapaVista.addAnnotation(self.origenAnotacion)
        if myvariables.solpendientes.count != 0 {
            self.SolPendImage.isHidden = false
            self.CantSolPendientes.text = String(myvariables.solpendientes.count)
            self.CantSolPendientes.isHidden = false
        }
        self.formularioSolicitud.isHidden = true
        self.SolicitarBtn.isHidden = false
        SolPendientesView.isHidden = true
        CancelarSolicitudProceso.isHidden = true
        AlertaEsperaView.isHidden = true
    }

    
    //FUNCION PARA LISTAR SOLICITUDES PENDIENTES
    func ListSolicitudPendiente(_ listado : [String]){
        //#LoginPassword,loginok,idusuario,idrol,idcliente,nombreapellidos,cantsolpdte,idsolicitud,idtaxi,cod,fechahora,lattaxi,lngtaxi, latorig,lngorig,latdest,lngdest,telefonoconductor
        
        var lattaxi = String()
        var longtaxi = String()
        var i = 7
        
        while i <= listado.count-10 {
            let solicitudpdte = CSolicitud()
            if listado[i+4] == "null"{
                lattaxi = "0"
                longtaxi = "0"
            }else{
                lattaxi = listado[i + 4]
                longtaxi = listado[i + 5]
            }
            solicitudpdte.idSolicitud = listado[i]
            solicitudpdte.DatosCliente(cliente: myvariables.cliente)
            solicitudpdte.DatosSolicitud(dirorigen: "", referenciaorigen: "", dirdestino: "", latorigen: listado[i + 6], lngorigen: listado[i + 7], latdestino: listado[i + 8], lngdestino: listado[i + 9],FechaHora: listado[i + 3])
            solicitudpdte.DatosTaxiConductor(idtaxi: listado[i + 1], matricula: "", codigovehiculo: listado[i + 2], marcaVehiculo: "", colorVehiculo: "", lattaxi: lattaxi, lngtaxi: longtaxi, idconductor: "", nombreapellidosconductor: "", movilconductor: listado[i + 10], foto: "")
            myvariables.solpendientes.append(solicitudpdte)
            if solicitudpdte.idTaxi != ""{
                myvariables.solicitudesproceso = true
            }
            i += 11
        }
        self.CantSolPendientes.isHidden = false
        self.CantSolPendientes.text = String(myvariables.solpendientes.count)
        self.SolPendImage.isHidden = false
    }
    
    //Funcion para Mostrar Datos del Taxi seleccionado
    func AgregarTaxiSolicitud(_ temporal : [String]){
        //#Aceptada, idsolicitud, idconductor, nombreApellidosConductor, movilConductor, URLfoto, idTaxi, Codvehiculo, matricula, marca_modelo, color, latTaxi, lngTaxi
        for solicitud in myvariables.solpendientes{
            if solicitud.idSolicitud == temporal[1]{
                myvariables.solicitudesproceso = true
                solicitud.DatosTaxiConductor(idtaxi: temporal[6], matricula: temporal[8], codigovehiculo: temporal[7], marcaVehiculo: temporal[9],colorVehiculo: temporal[10], lattaxi: temporal[11], lngtaxi: temporal[12], idconductor: temporal[2], nombreapellidosconductor: temporal[3], movilconductor: temporal[4], foto: temporal[5])
            }
        }
    }

    //FUNCIÓN BUSCA UNA SOLICITUD DENTRO DEL ARRAY DE SOLICITUDES PENDIENTES DADO SU ID
    func BuscarSolicitudID(_ id : String)->CSolicitud{
        var temporal : CSolicitud!
        for solicitudpdt in myvariables.solpendientes{
            if solicitudpdt.idSolicitud == id{
                temporal = solicitudpdt
            }
        }
        return temporal
    }
    
    //Devolver posicion de solicitud
    func BuscarPosSolicitudID(_ id : String)->Int{
        var temporal = 0
        var posicion = -1
        for solicitudpdt in myvariables.solpendientes{
            if solicitudpdt.idSolicitud == id{
                posicion = temporal
            }
            temporal += 1
        }
        return posicion
    }

    
    //Respuesta de solicitud
    func ConfirmaSolicitud(_ Temporal : [String]){
        //Trama IN: #Solicitud, ok, idsolicitud, fechahora
        if Temporal[1] == "ok"{
            myvariables.solpendientes.last!.RegistrarFechaHora(IdSolicitud: Temporal[2], FechaHora: Temporal[3])
            self.CantSolPendientes.isHidden = false
            self.CantSolPendientes.text = String(myvariables.solpendientes.count)
            self.SolPendImage.isHidden = false
        }
        else{
            if Temporal[1] == "error"{
                
            }
        }
    }
    
    //FUncion para mostrar los taxis
    func MostrarTaxi(_ temporal : [String]){
        //TRAMA IN: #Posicion,idtaxi,lattaxi,lngtaxi
        var i = 2
        var taxiscercanos = [MKPointAnnotation]()
        while i  <= temporal.count - 6{
            let taxiTemp = MKPointAnnotation()
            taxiTemp.coordinate = CLLocationCoordinate2DMake(Double(temporal[i + 2])!, Double(temporal[i + 3])!)
            taxiTemp.title = temporal[i]
            taxiscercanos.append(taxiTemp)
            i += 6
        }
        DibujarIconos(taxiscercanos)
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
    
    //CREAR SOLICITUD CON LOS DATOS DEL CIENTE, SU LOCALIZACIÓN DE ORIGEN Y DESTINO
    func CrearSolicitud(_ nuevaSolicitud: CSolicitud, voucher: String){
        //#Solicitud, idcliente, nombrecliente, movilcliente, dirorig, referencia, dirdest,latorig,lngorig, latdest, lngdest, distancia, costo, #
        formularioSolicitud.isHidden = true
        origenIcono.isHidden = true
        myvariables.solpendientes.append(nuevaSolicitud)
        let Datos = "#Solicitud,\(nuevaSolicitud.idCliente),\(nuevaSolicitud.nombreApellidos),\(nuevaSolicitud.user),\(nuevaSolicitud.dirOrigen),\(nuevaSolicitud.referenciaorigen),null,\(String(nuevaSolicitud.origenCarrera.latitude)),\(String(nuevaSolicitud.origenCarrera.longitude)),0.0,0.0,\(String(nuevaSolicitud.distancia)),\(nuevaSolicitud.costo),\(voucher),# \n"
        //EnviarSocket(Datos)
        self.EnviarTimer(estado: 1, datos: Datos)
        MensajeEspera.text = "Procesando..."
        self.AlertaEsperaView.isHidden = false
        self.origenText.text?.removeAll()
        //self.RecordarSwitch.isOn = false
        self.referenciaText.text?.removeAll()
    }
    
    //FUNCION PARA DIBUJAR LAS ANOTACIONES
    func DibujarIconos(_ anotaciones: [MKPointAnnotation]){
        if anotaciones.count == 1{
            self.mapaVista.addAnnotations([self.origenAnotacion,anotaciones[0]])
            self.mapaVista.fitAll(in: self.mapaVista.annotations, andShow: true)
        }else{
            self.mapaVista.addAnnotations(anotaciones)
            self.mapaVista.fitAll(in: anotaciones, andShow: true)
        }
    }
    
    //CANCELAR SOLICITUDES
    func MostrarMotivoCancelacion(){
        let motivoAlerta = UIAlertController(title: "", message: "Seleccione el motivo de cancelación.", preferredStyle: UIAlertController.Style.actionSheet)
        motivoAlerta.addAction(UIAlertAction(title: "No necesito", style: .default, handler: { action in
            //["No necesito","Demora el servicio","Tarifa incorrecta","Solo probaba el servicio", "Cancelar"]
                self.CancelarSolicitudes("No necesito")
   
        }))
        motivoAlerta.addAction(UIAlertAction(title: "Demora el servicio", style: .default, handler: { action in
            //["No necesito","Demora el servicio","Tarifa incorrecta","Solo probaba el servicio", "Cancelar"]
            
                self.CancelarSolicitudes("Demora el servicio")
      
        }))
        motivoAlerta.addAction(UIAlertAction(title: "Tarifa incorrecta", style: .default, handler: { action in
            //["No necesito","Demora el servicio","Tarifa incorrecta","Solo probaba el servicio", "Cancelar"]

                self.CancelarSolicitudes("Tarifa incorrecta")
       
        }))
        motivoAlerta.addAction(UIAlertAction(title: "Vehículo en mal estado", style: .default, handler: { action in
            //["No necesito","Demora el servicio","Tarifa incorrecta","Solo probaba el servicio", "Cancelar"]

                self.CancelarSolicitudes("Vehículo en mal estado")

        }))
        motivoAlerta.addAction(UIAlertAction(title: "Solo probaba el servicio", style: .default, handler: { action in
            //["No necesito","Demora el servicio","Tarifa incorrecta","Solo probaba el servicio", "Cancelar"]

                self.CancelarSolicitudes("Solo probaba el servicio")

        }))
        motivoAlerta.addAction(UIAlertAction(title: "Cancelar", style: UIAlertAction.Style.destructive, handler: { action in
        }))
        self.present(motivoAlerta, animated: true, completion: nil)
    }
    
    func CancelarSolicitudes(_ motivo: String){
        //#Cancelarsolicitud, idSolicitud, idTaxi, motivo, "# \n"
        let temp = (myvariables.solpendientes.last?.idTaxi)! + "," + motivo + "," + "# \n"
        let Datos = "#Cancelarsolicitud" + "," + (myvariables.solpendientes.last?.idSolicitud)! + "," + temp
        myvariables.solpendientes.removeLast()
        if myvariables.solpendientes.count == 0 {
            self.SolPendImage.isHidden = true
            CantSolPendientes.isHidden = true
            myvariables.solicitudesproceso = false
        }
        if motivo != "Conductor"{
            EnviarSocket(Datos)
        }
    }

    //CONTROL DE TECLADO VIRTUAL
    
    
    //Validar los formularios
    func SoloLetras(name: String) -> Bool {
        // (1):
        let pat = "[0-9,.!@#$%^&*()_+-]"
        // (2):
        //let testStr = "x.wu@strath.ac.uk, ak123@hotmail.com     e1s59@oxford.ac.uk, ee123@cooleng.co.uk, a.khan@surrey.ac.uk"
        // (3):
        let regex = try! NSRegularExpression(pattern: pat, options: [])
        // (4):
        let matches = regex.matches(in: name, options: [], range: NSRange(location: 0, length: name.characters.count))
        if matches.count == 0{
            return true
        }else{
            return false
        }
    }

    
    
    
    
    
    
    
    
    //MARK:- BOTONES GRAFICOS ACCIONES
    @IBAction func CerrarApp(_ sender: Any) {
        let fileAudio = FileManager()
        let AudioPath = NSHomeDirectory() + "/Library/Caches/Audio"
        do {
            try fileAudio.removeItem(atPath: AudioPath)
        }catch{
        }
        let datos = "#SocketClose," + myvariables.cliente.idCliente + ",# \n"
        EnviarSocket(datos)
        exit(3)
    }
    @IBAction func RelocateBtn(_ sender: Any) {
        let span = MKCoordinateSpan.init(latitudeDelta: 0.005, longitudeDelta: 0.005)
        let region = MKCoordinateRegion(center: (self.coreLocationManager.location?.coordinate)!, span: span)
        self.mapaVista.setRegion(region, animated: true)
    }
    //SOLICITAR BUTTON
    @IBAction func Solicitar(_ sender: AnyObject) {
        //TRAMA OUT: #Posicion,idCliente,latorig,lngorig
        self.origenIcono.isHidden = true
        self.origenAnotacion.coordinate = mapaVista.camera.centerCoordinate
        self.origenText.becomeFirstResponder()
        coreLocationManager.stopUpdatingLocation()
        self.SolicitarBtn.isHidden = true
        self.formularioSolicitud.isHidden = false
    
        self.voucherView.isHidden = myvariables.cliente.empresa == "null"
        
        let datos = "#Posicion,\(myvariables.cliente.idCliente!),\(self.origenAnotacion.coordinate.latitude),\(self.origenAnotacion.coordinate.longitude),# \n"
        EnviarSocket(datos)
    }
    
    //Aceptar y Enviar solicitud desde formulario solicitud
    @IBAction func AceptarSolicitud(_ sender: AnyObject) {
        if !(self.origenText.text?.isEmpty)! {
            var voucher = "0"
            var origen = self.origenText.text?.uppercased()
            origen = origen?.replacingOccurrences(of: "Ñ", with: "N",options: .regularExpression, range: nil)
            origen = origen?.replacingOccurrences(of: "[,.]", with: "-",options: .regularExpression, range: nil)
            origen = origen?.replacingOccurrences(of: "[\n]", with: " ",options: .regularExpression, range: nil)
            origen = origen?.replacingOccurrences(of: "[#]", with: "No",options: .regularExpression, range: nil)
            origen = origen?.folding(options: .diacriticInsensitive, locale: .current)
            
            var referencia = self.referenciaText.text?.uppercased()
            referencia = referencia?.replacingOccurrences(of: "Ñ", with: "N",options: .regularExpression, range: nil)
            referencia = referencia?.replacingOccurrences(of: "[,.]", with: "-",options: .regularExpression, range: nil)
            referencia = referencia?.replacingOccurrences(of: "[\n]", with: " ",options: .regularExpression, range: nil)
            referencia = referencia?.replacingOccurrences(of: "[#]", with: "No",options: .regularExpression, range: nil)
            referencia = referencia?.folding(options: .diacriticInsensitive, locale: .current)
            mapaVista.removeAnnotations(mapaVista.annotations)
            let nuevaSolicitud = CSolicitud()
            nuevaSolicitud.DatosCliente(cliente: myvariables.cliente)
            nuevaSolicitud.DatosSolicitud(dirorigen: origen!, referenciaorigen: referencia!, dirdestino: "",latorigen: String(Double(origenAnotacion.coordinate.latitude)), lngorigen: String(Double(origenAnotacion.coordinate.longitude)), latdestino: "0", lngdestino: "0",FechaHora: "")
            
            if self.voucherView.isHidden == false && self.voucherCheck.isOn{
                voucher = "1"
            }
            
            self.CrearSolicitud(nuevaSolicitud,voucher: voucher)
            DibujarIconos([self.origenAnotacion])
            self.origenText.endEditing(true)
            self.referenciaText.endEditing(true)
        }else{
            
        }
    }
    
    //Boton para Cancelar Carrera
    @IBAction func CancelarSol(_ sender: UIButton) {
        self.formularioSolicitud.isHidden = true
        self.referenciaText.endEditing(true)
        self.origenText.endEditing(true)
        self.Inicio()
        self.origenText.text?.removeAll()
        self.referenciaText.text?.removeAll()
        self.SolicitarBtn.isHidden = false
        if myvariables.solpendientes.count != 0{
            self.SolPendImage.isHidden = false
            self.CantSolPendientes.text = String(myvariables.solpendientes.count)
            self.CantSolPendientes.isHidden = false
        }
    }
    // CANCELAR LA SOL MIENTRAS SE ESPERA LA FONFIRMACI'ON DEL TAXI
    @IBAction func CancelarProcesoSolicitud(_ sender: AnyObject) {
        MostrarMotivoCancelacion()
    }
    
    @IBAction func MostrarTelefonosCC(_ sender: AnyObject) {
        self.SolPendientesView.isHidden = true
        let vc = UIStoryboard(name:"Main", bundle:nil).instantiateViewController(withIdentifier: "CallCenter") as! CallCenterController
        vc.telefonosCallCenter = self.TelefonosCallCenter
        self.navigationController?.show(vc, sender: nil)
        
    }
    
    @IBAction func MostrarSolPendientes(_ sender: AnyObject) {
        if myvariables.solpendientes.count > 0{
            let vc = UIStoryboard(name:"Main", bundle:nil).instantiateViewController(withIdentifier: "ListaSolPdtes") as! SolicitudesTableController
            vc.solicitudesMostrar = myvariables.solpendientes
            self.navigationController?.show(vc, sender: nil)
        }else{
            self.SolPendientesView.isHidden = !self.SolPendientesView.isHidden
        }
    }

    @IBAction func MapaMenu(_ sender: AnyObject) {
        Inicio()
    }
    @IBAction func CompartirApp(_ sender: Any) {
        if let name = URL(string: "itms://itunes.apple.com/us/app/apple-store/id1391455068?mt=8") {
            let objectsToShare = [name]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            self.present(activityVC, animated: true, completion: nil)
        }
        else
        {
            // show alert for not available
        }
        
    }
}

//EXTENSION PARA CREAR EL SUBRAYADO EN LOS TEXTFIELDS
extension UITextField {
    func setBottomBorder(borderColor: UIColor) {
        self.borderStyle = UITextField.BorderStyle.none
        self.backgroundColor = UIColor.clear
        let width = 1.0
        let borderLine = UIView()
        borderLine.frame = CGRect(x: 0, y: Double(self.frame.height) - width, width: Double(self.frame.width), height: width)
        borderLine.backgroundColor = borderColor
        self.addSubview(borderLine)
    }
}

extension MKMapView {
    /// when we call this function, we have already added the annotations to the map, and just want all of them to be displayed.
    func fitAll() {
        var zoomRect            = MKMapRect.null;
        for annotation in annotations {
            let annotationPoint = MKMapPoint.init(annotation.coordinate)
            let pointRect       = MKMapRect.init(x: annotationPoint.x, y: annotationPoint.y, width: 0.01, height: 0.01)
            zoomRect            = zoomRect.union(pointRect);
        }
        setVisibleMapRect(zoomRect, edgePadding: UIEdgeInsets.init(top: 100, left: 100, bottom: 100, right: 100), animated: true)
    }
    
    /// we call this function and give it the annotations we want added to the map. we display the annotations if necessary
    func fitAll(in annotations: [MKAnnotation], andShow show: Bool) {
        
        var zoomRect:MKMapRect  = MKMapRect.null
        
        for annotation in annotations {
            let aPoint          = MKMapPoint.init(annotation.coordinate)
            let rect            = MKMapRect.init(x: aPoint.x, y: aPoint.y, width: 0.071, height: 0.071)
            
            if zoomRect.isNull {
                zoomRect = rect
            } else {
                zoomRect = zoomRect.union(rect)
            }
        }
        if(show) {
            addAnnotations(annotations)
        }
        setVisibleMapRect(zoomRect, edgePadding: UIEdgeInsets(top: 100, left: 100, bottom: 100, right: 100), animated: true)
    }
}
