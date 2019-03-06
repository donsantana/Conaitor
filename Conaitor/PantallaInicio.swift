//
//  PantallaInicioViewController.swift
//  Xtaxi
//
//  Created by Done Santana on 2/11/15.
//  Copyright © 2015 Done Santana. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import GoogleMaps
import SocketIO
import Canvas
import AddressBook
import AVFoundation
import CoreData


class PantallaInicio: UIViewController, CLLocationManagerDelegate, UITextViewDelegate, GMSMapViewDelegate, UITextFieldDelegate, URLSessionDelegate, URLSessionTaskDelegate, URLSessionDataDelegate, UIApplicationDelegate {
    var coreLocationManager : CLLocationManager!
    var miposicion = CLLocationCoordinate2D()
    var locationMarker = MKPointAnnotation()
    var taxiLocation : GMSMarker!
    var userAnotacion : GMSMarker!
    var origenAnotacion : GMSMarker!
    var destinoAnotacion : GMSMarker!
    var taxi : CTaxi!
    var login = [String]()
    var solpendientes = [CSolicitud]()
    var idusuario : String = ""
    var indexselect = Int()
    var contador = 0
    var centro = CLLocationCoordinate2D()
    var TelefonosCallCenter = [CTelefono]()
    var opcionAnterior : IndexPath!
    var evaluacion: CEvaluacion!
    var tarifas = [CTarifa]()
    var taxiscercanos = [GMSMarker]()
    var SMSVoz = CSMSVoz()

    var UrlSubirVoz = String()
    var responseData = NSMutableData()
    var data: Data!
    var timer = Timer()
    var fechahora: String!
    var grabando = false
    var urlconductor: String!
    let compartirOpcions = ["itms://itunes.apple.com/us/app/apple-store/id1193366712?mt=8"]
    var tiempoTemporal = 10
    
    var taximetro: CTaximetro!
    var TaximetroTimer = Timer()
    var TaximetroTotalTimer = Timer()
    var espera = 0
   
  
    //variables de interfaz
    //@IBOutlet weak var taxisDisponible: UILabel!
    @IBOutlet weak var Geolocalizando: UIActivityIndicatorView!
    @IBOutlet weak var GeolocalizandoView: UIView!
    
    @IBOutlet weak var origenIcono: UIImageView!
    @IBOutlet weak var mapaVista : GMSMapView!
    @IBOutlet weak var ExplicacionView: UIView!

    @IBOutlet weak var ExplicacionText: UILabel!
   
    
    @IBOutlet weak var destinoText: UITextField!
    @IBOutlet weak var origenText: UITextField!
    @IBOutlet weak var referenciaText: UITextField!
   
    
    @IBOutlet weak var formularioSolicitud: UIView!
    @IBOutlet weak var SolicitarBtn: UIButton!
    @IBOutlet weak var DatosConductor: UIView!
    
    //datos del conductor a mostrar
    @IBOutlet weak var ImagenCond: UIImageView!
    @IBOutlet weak var NombreCond: UILabel!
    @IBOutlet weak var MovilCond: UILabel!
    @IBOutlet weak var MarcaAut: UILabel!
    @IBOutlet weak var MatriculaAut: UILabel!
    @IBOutlet weak var DatosCondBtn: UIButton!
    @IBOutlet weak var ColorAut: UILabel!
    @IBOutlet weak var CancelarSolBtn: UIButton!
    
    @IBOutlet weak var EnviarSolBtn: UIButton!
    
    @IBOutlet weak var aceptarLocBtn: UIButton!
    @IBOutlet weak var CancelarEnvioBtn: UIButton!
   
    @IBOutlet weak var SolPendientesBtn: UIButton!
    @IBOutlet weak var TablaSolPendientes: UITableView!
    //@IBOutlet weak var SolicitudDetalleView: UIView!
    @IBOutlet weak var SolPendientesView: UIView!
    @IBOutlet weak var CantSolPendientes: UILabel!
    @IBOutlet weak var DetallesCarreraView: UIView!
    
    @IBOutlet weak var SolPendImage: UIImageView!
    
  
    @IBOutlet weak var PrimeraStart: UIButton!
    @IBOutlet weak var SegundaStar: UIButton!
    @IBOutlet weak var TerceraStar: UIButton!
    @IBOutlet weak var CuartaStar: UIButton!
    @IBOutlet weak var QuintaStar: UIButton!
    @IBOutlet weak var ComentarioText: UITextView!
   
    
    //@IBOutlet weak var SolicitudMapaView: UIView!
    
    @IBOutlet weak var DistanciaText: UILabel!
    @IBOutlet weak var DuracionText: UILabel!
    @IBOutlet weak var CostoText: UILabel!
    
    @IBOutlet weak var SolicitudAceptadaView: UIView!
    @IBOutlet weak var EvaluarBtn: UIButton!
    @IBOutlet weak var EvaluacionView: UIView!
    @IBOutlet weak var ComentarioEvalua: UIView!
    
    //@IBOutlet weak var LlamarBtn: UIButton!
    //@IBOutlet weak var OpcionesCancelView: UIView!
    //@IBOutlet weak var TablaOpcionesView: UITableView!
    @IBOutlet weak var SMSVozBtn: UIButton!
    @IBOutlet weak var MensajesBtn: UIButton!
    @IBOutlet weak var LlamarCondBtn: UIButton!
    
    
    @IBOutlet weak var MenuView: UIView!
    @IBOutlet weak var SelectOpcion: UIView!
    @IBOutlet weak var CallCEnterBtn: UIButton!

    //@IBOutlet weak var TaximetroBtn: UIButton!
    @IBOutlet weak var TarifarioBtn: UIButton!
    @IBOutlet weak var MapaBtn: UIButton!
    @IBOutlet weak var EsperandoTaxiActivity: UIActivityIndicatorView!
    
    @IBOutlet weak var CallCenterView: CSAnimationView!
    @IBOutlet weak var TablaCallCenter: UITableView!
    
    @IBOutlet weak var TablaSinInternet: UITableView!
   
    @IBOutlet weak var AlertaEsperaView: UIView!
    @IBOutlet weak var MensajeEspera: UITextView!
    
    //@IBOutlet weak var EsperaTaxisView: UIView!
    
    //Tarifario
    
    @IBOutlet weak var CancelarSolicitudProceso: UIButton!
    
    
    @IBOutlet weak var FondoClaveView: UIView!
    @IBOutlet weak var CambiarclaveView: UIView!
    @IBOutlet weak var ClaveActual: UITextField!
    @IBOutlet weak var ClaveNueva: UITextField!
    @IBOutlet weak var RepiteClaveNueva: UITextField!
    @IBOutlet weak var CambiarClave: UIButton!
    @IBOutlet weak var CancelaCambioClave: UIButton!
    
    @IBOutlet weak var AlertaSinConexion: UIView!
    @IBOutlet weak var CompartirTable: CSAnimationView!
    @IBOutlet weak var SinConexionText: UITextView!
    
    //TAXIMETRO
    @IBOutlet weak var TaximetroView: UIView!
    @IBOutlet weak var TaximetroBtn: UIButton!
    @IBOutlet weak var StarTaxBtn: UIButton!
    @IBOutlet weak var StopTaxBtn: UIButton!
    @IBOutlet weak var ApagarText: UILabel!
    @IBOutlet weak var TimeEsperaText: UILabel!
    @IBOutlet weak var TaximetroDistanciaText: UILabel!
    @IBOutlet weak var ArranqueText: UILabel!
    @IBOutlet weak var MinimaText: UILabel!
    @IBOutlet weak var TaximetroSpeedText: UILabel!
    @IBOutlet weak var AlertaTaximetroText: UILabel!
    @IBOutlet weak var AlertaTaximetroView: UIView!
   
    
    var TimerTemporal = Timer()
    
    override func viewDidLoad() {
       super.viewDidLoad()

        
        //LECTURA DEL FICHERO PARA AUTENTICACION
  
        mapaVista.delegate = self
        coreLocationManager = CLLocationManager()
        coreLocationManager.delegate = self
        coreLocationManager.requestAlwaysAuthorization() //solicitud de autorización para acceder a la localización del usuario
        coreLocationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        coreLocationManager.startUpdatingLocation()  //Iniciar servicios de actualiación de localización del usuario

        //INICIALIZACION DE LOS TEXTFIELD
        origenText.delegate = self
        referenciaText.delegate = self
        destinoText.delegate = self
        ComentarioText.delegate = self
        
        ClaveNueva.delegate = self
        ClaveActual.delegate = self
        RepiteClaveNueva.delegate = self
        
        
        let longesture = UILongPressGestureRecognizer(target: self, action: #selector(PantallaInicio.StopTaximetroFunction))
        StopTaxBtn.addGestureRecognizer(longesture)

        //UBICAR LOS BOTONES DEL MENU
       /* var espacioBtn = self.view.frame.width/5
        self.CallCEnterBtn.frame = CGRect(x: espacioBtn - 40, y: 5, width: 44, height: 44)
        self.SolPendientesBtn.frame = CGRect(x: (espacioBtn * 2 - 35), y: 5, width: 44, height: 44)
        self.TarifarioBtn.frame = CGRect(x: (espacioBtn * 3 - 15), y: 5, width: 44, height: 44)
        self.MapaBtn.frame = CGRect(x: (espacioBtn * 4 - 10), y: 5, width: 44, height: 44)
        self.SelectOpcion.frame = CGRect(x: MapaBtn.frame.origin.x - 5, y: 5, width: 55, height: 44)
        self.SolPendImage.frame = CGRect(x: (espacioBtn * 2 - 10), y: 5, width: 25, height: 22)
        self.CantSolPendientes.frame = CGRect(x: (espacioBtn * 2 - 10), y: 5, width: 25, height: 22)*/
        
        self.userAnotacion = GMSMarker()
        self.taxiLocation = GMSMarker()
        self.taxiLocation.icon = UIImage(named: "taxi_libre")
        self.origenAnotacion = GMSMarker()
        self.origenAnotacion.icon = UIImage(named: "origen")
        self.destinoAnotacion = GMSMarker()
        self.destinoAnotacion.icon = UIImage(named: "destino")
    
        if CConexionInternet.isConnectedToNetwork() == true{
            
            myvariables.socket = SocketIOClient(socketURL: URL(string: "http://www.xoait.com:5803")!, config: [.log(false), .forcePolling(true)])
            myvariables.socket.connect()
            
            //Inicializacion del mapa con una vista panoramica de guayaquil
            mapaVista.isMyLocationEnabled = false
            mapaVista.camera = GMSCameraPosition.camera(withLatitude: -2.137072,longitude:-79.903454,zoom: 15)
            //self.GeolocalizandoView.isHidden = false
            
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
            
            if read == "Vacio"
            {
                //self.LoginView.isHidden = false
            }else{
                self.Login()
            }
            }
            
        }else{
            ErrorConexion()
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
        let TitleString = NSAttributedString(string: "Sin Conexión", attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: 19), NSForegroundColorAttributeName : UIColor.black])
        alertaDos.setValue(TitleString, forKey: "attributedTitle")
        //let MessageString = NSAttributedString(string: Message, attributes: [NSFontAttributeName : UIFont.systemFontOfSize(15), NSForegroundColorAttributeName : MessageColor])
        
        self.present(alertaDos, animated: true, completion: nil)
    }
    func SocketEventos(){
        //Evento sockect para escuchar
        //TRAMA IN: #LoginPassword,loginok,idusuario,idrol,idcliente,nombreapellidos,cantsolpdte,idsolicitud,idtaxi,cod,fechahora,lattaxi,lngtaxi,latorig,lngorig,latdest,lngdest,telefonoconductor
        if self.appUpdateAvailable(){
    
            let alertaVersion = UIAlertController (title: "Versión de la aplicación", message: "Estimado cliente es necesario que actualice a la última versión de la aplicación disponible en la AppStore. ¿Desea hacerlo en este momento?", preferredStyle: .alert)
            alertaVersion.addAction(UIAlertAction(title: "Si", style: .default, handler: {alerAction in
                
                UIApplication.shared.openURL(URL(string: "itms://itunes.apple.com/us/app/apple-store/id1149206387?mt=8")!)
            }))
            alertaVersion.addAction(UIAlertAction(title: "No", style: .default, handler: {alerAction in
                exit(0)
            }))
            //Para hacer que la alerta se muestre usamos presentViewController, a diferencia de Objective C que como recordaremos se usa [Show Alerta]
            alertaVersion.view.tintColor = UIColor.black
            let subview = alertaVersion.view.subviews.last! as UIView
            let alertContentView = subview.subviews.last! as UIView
            alertContentView.backgroundColor = UIColor(red: 252.0/255.0, green: 238.0/255.0, blue: 129.0/255.0, alpha: 1.0)
            alertContentView.layer.cornerRadius = 5
            let TitleString = NSAttributedString(string: "Autenticación", attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: 19), NSForegroundColorAttributeName : UIColor.black])
            alertaVersion.setValue(TitleString, forKey: "attributedTitle")
            //let MessageString = NSAttributedString(string: Message, attributes: [NSFontAttributeName : UIFont.systemFontOfSize(15), NSForegroundColorAttributeName : MessageColor])
            self.present(alertaVersion, animated: true, completion: nil)
            //self.AlertaEsperaView.hidden = false
        }

               
       myvariables.socket.on("LoginPassword"){data, ack in
            let temporal = String(describing: data).components(separatedBy: ",")
        if (temporal[0] == "[#LoginPassword") || (temporal[0] == "#LoginPassword"){
                self.solpendientes = [CSolicitud]()
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
                    myvariables.cliente = CCliente(idUsuario: temporal[2],idcliente: temporal[4], user: self.login[1], nombre: temporal[5],email : temporal[3])
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
                    
                    let alertaDos = UIAlertController (title: "Autenticación", message: "Usuario y/o clave incorrectos", preferredStyle: UIAlertControllerStyle.alert)
                    alertaDos.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: {alerAction in
                       
                    }))
                    
                    //Para hacer que la alerta se muestre usamos presentViewController, a diferencia de Objective C que como recordaremos se usa [Show Alerta]
                    alertaDos.view.tintColor = UIColor.black
                    let subview = alertaDos.view.subviews.last! as UIView
                    let alertContentView = subview.subviews.last! as UIView
                    alertContentView.backgroundColor = UIColor(red: 252.0/255.0, green: 238.0/255.0, blue: 129.0/255.0, alpha: 1.0)
                    alertContentView.layer.cornerRadius = 5
                    let TitleString = NSAttributedString(string: "Autenticación", attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: 19), NSForegroundColorAttributeName : UIColor.black])
                    alertaDos.setValue(TitleString, forKey: "attributedTitle")
                    //let MessageString = NSAttributedString(string: Message, attributes: [NSFontAttributeName : UIFont.systemFontOfSize(15), NSForegroundColorAttributeName : MessageColor])
                    self.present(alertaDos, animated: true, completion: nil)
                case "version":
                    let alertaDos = UIAlertController (title: "Versión de la aplicación", message: "Estimado cliente es necesario que actualice a la última versión de la aplicación disponible en la AppStore. Desea hacerlo en este momento:", preferredStyle: UIAlertControllerStyle.alert)
                    alertaDos.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: {alerAction in
                        
                    }))
                    alertaDos.addAction(UIAlertAction(title: "Cancelar", style: .default, handler: {alerAction in
                        
                    }))
                    //Para hacer que la alerta se muestre usamos presentViewController, a diferencia de Objective C que como recordaremos se usa [Show Alerta]
                    alertaDos.view.tintColor = UIColor.black
                    let subview = alertaDos.view.subviews.last! as UIView
                    let alertContentView = subview.subviews.last! as UIView
                    alertContentView.backgroundColor = UIColor(red: 252.0/255.0, green: 238.0/255.0, blue: 129.0/255.0, alpha: 1.0)
                    alertContentView.layer.cornerRadius = 5
                    let TitleString = NSAttributedString(string: "Autenticación", attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: 19), NSForegroundColorAttributeName : UIColor.black])
                    alertaDos.setValue(TitleString, forKey: "attributedTitle")
                    //let MessageString = NSAttributedString(string: Message, attributes: [NSFontAttributeName : UIFont.systemFontOfSize(15), NSForegroundColorAttributeName : MessageColor])
                    self.present(alertaDos, animated: true, completion: nil)
                default: print("Problemas de conexion")
                }
            }
            else{
                //exit(0)
            }
        }
        
        //EVENTO PARA CARGAR TARIFAS
     /* myvariables.socket.on("CargarTarifas"){data, ack in
        let tarifario = String(describing: data).components(separatedBy: ",")
           var i = 2
            while (i < tarifario.count - 6){
                let unatarifa = CTarifa(horaInicio: tarifario[i], horaFin: tarifario[i+1], valorMinimo: Double(tarifario[i+2])!, tiempoEspera: Double(tarifario[i+3])!, valorKilometro: Double(tarifario[i+4])!, valorArranque: Double(tarifario[i+5])!)
               self.tarifas.append(unatarifa)
                i += 6
            }
        if myvariables.taximetroActive{
            let date = Date()
            let formatter:DateFormatter = DateFormatter()
            formatter.dateFormat = "HH:mm" //opción formateador
            let hora = formatter.string(from: date)
            let temporal = String(hora).components(separatedBy: ":")
            
            for var tarifatemporal in self.tarifas{
                if (Int(tarifatemporal.horaInicio) <= Int(temporal[0])!) && (Int(temporal[0])! <= Int(tarifatemporal.horaFin)){
                    self.taximetro.ActualizarTarifa(tarifatemporal)
                    self.MinimaText.text = String(tarifatemporal.valorMinimo)
                    self.ArranqueText.text = String(tarifatemporal.valorArranque)
                }
            }
            
        }
        }*/
        
        //Evento Posicion de taxis
        myvariables.socket.on("Posicion"){data, ack in
            let temporal = String(describing: data).components(separatedBy: ",")
            //self.MensajeEspera.text = String(temporal)
            //self.AlertaEsperaView.hidden = false
            if(temporal[1] == "0") {
                let alertaDos = UIAlertController(title: "Solicitud de Taxi", message: "No hay taxis disponibles en este momento, espere unos minutos y vuelva a intentarlo.", preferredStyle: UIAlertControllerStyle.alert )
                alertaDos.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: {alerAction in
                    self.Inicio()
                }))
                
                //Para hacer que la alerta se muestre usamos presentViewController, a diferencia de Objective C que como recordaremos se usa [Show Alerta]
                alertaDos.view.tintColor = UIColor.black
                let subview = alertaDos.view.subviews.last! as UIView
                let alertContentView = subview.subviews.last! as UIView
                alertContentView.backgroundColor = UIColor(red: 252.0/255.0, green: 238.0/255.0, blue: 129.0/255.0, alpha: 1.0)
                alertContentView.layer.cornerRadius = 5
                let TitleString = NSAttributedString(string: "Solicitud de Taxi", attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: 19), NSForegroundColorAttributeName : UIColor.black])
                alertaDos.setValue(TitleString, forKey: "attributedTitle")
                //let MessageString = NSAttributedString(string: Message, attributes: [NSFontAttributeName : UIFont.systemFontOfSize(15), NSForegroundColorAttributeName : MessageColor])

                self.present(alertaDos, animated: true, completion: nil)
            }
            else{
                self.MostrarTaxi(temporal)
            }
        }
        
        //Datos del conductor del taxi seleccionado
        myvariables.socket.on("Taxi"){data, ack in
           //"#Taxi,"+nombreconductor+" "+apellidosconductor+","+telefono+","+codigovehiculo+","+gastocombustible+","+marcavehiculo+","+colorvehiculo+","+matriculavehiculo+","+urlfoto+","+idconductor+",# \n";

            let datosConductor = String(describing: data).components(separatedBy: ",")
            
            self.NombreCond.text! = "Conductor: " + datosConductor[1]
            self.MarcaAut.text! = "Marca: " + datosConductor[5]
            self.ColorAut.text! = "Color: " + datosConductor[6]
            self.MatriculaAut.text! = "Matrícula: " + datosConductor[7]
            self.MovilCond.text! = "Movil: " + datosConductor[2]
            if datosConductor[9] != "null" && datosConductor[9] != ""{
                URLSession.shared.dataTask(with: URL(string: datosConductor[9])!, completionHandler: { (data, response, error) in
                    DispatchQueue.main.async {
                        _ = UIViewContentMode.scaleAspectFill
                        self.ImagenCond.image = UIImage(data: data!)
                    }
                }) 
            }else{
                self.ImagenCond.image = UIImage(named: "chofer")
            }
            self.AlertaEsperaView.isHidden = true
            self.DatosConductor.isHidden = false
        }
        
        //Respuesta de la solicitud enviada
        myvariables.socket.on("Solicitud"){data, ack in
            //Trama IN: #Solicitud, ok, idsolicitud, fechahora
            //Trama IN: #Solicitud, error
            let temporal = String(describing: data).components(separatedBy: ",")
            if temporal[1] == "ok"{
                self.MensajeEspera.text = "Solicitud enviada a todos los taxis cercanos. Esperando respuesta de un conductor."
                self.AlertaEsperaView.isHidden = false
                self.CancelarSolicitudProceso.isHidden = false
                self.ConfirmaSolicitud(temporal)
            }
            else{
                //exit(0)
            }
        }
        
        //GEOPOSICION DE TAXIS
       myvariables.socket.on("Geo"){data, ack in
        let temporal = String(describing: data).components(separatedBy: ",")
        if self.solpendientes.count != 0 {
            //self.MensajeEspera.text = temporal
            //self.AlertaEsperaView.hidden = false
            for solicitudpendiente in self.solpendientes{
                if (temporal[2] == solicitudpendiente.idTaxi){
                    solicitudpendiente.taximarker.position = CLLocationCoordinate2DMake(Double(temporal[3])!, Double(temporal[4])!)
                    if solicitudpendiente.taximarker.map == self.mapaVista{
                        solicitudpendiente.taximarker.map = nil
                        solicitudpendiente.taximarker.map = self.mapaVista
                        //self.TiempoTaxi.text = solicitudpendiente.TiempoTaxi()
                    }
                }
            }
        }
        }
        
        //RESPUESTA DE CANCELAR SOLICITUD
        myvariables.socket.on("Cancelarsolicitud"){data, ack in
            let temporal = String(describing: data).components(separatedBy: ",")
            if temporal[1] == "ok"{
                let alertaDos = UIAlertController (title: "Cancelar Solicitud", message: "Su solicitud fue cancelada.", preferredStyle: UIAlertControllerStyle.alert)
                alertaDos.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: {alerAction in
                    if self.solpendientes.count != 0{
                        self.TablaSolPendientes.isHidden = true
                        self.SolPendientesView.isHidden = true
                        self.CantSolPendientes.text = String(self.solpendientes.count)
                    }
                    else{
                        self.SolPendImage.isHidden = true
                    }
                    self.Inicio()
                }))
                
                //Para hacer que la alerta se muestre usamos presentViewController, a diferencia de Objective C que como recordaremos se usa [Show Alerta]
                alertaDos.view.tintColor = UIColor.black
                let subview = alertaDos.view.subviews.last! as UIView
                let alertContentView = subview.subviews.last! as UIView
                alertContentView.backgroundColor = UIColor(red: 252.0/255.0, green: 238.0/255.0, blue: 129.0/255.0, alpha: 1.0)
                alertContentView.layer.cornerRadius = 5
                let TitleString = NSAttributedString(string: "Cancelar Solicitud", attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: 19), NSForegroundColorAttributeName : UIColor.black])
                alertaDos.setValue(TitleString, forKey: "attributedTitle")
                //let MessageString = NSAttributedString(string: Message, attributes: [NSFontAttributeName : UIFont.systemFontOfSize(15), NSForegroundColorAttributeName : MessageColor])

                self.present(alertaDos, animated: true, completion: nil)
                
                }
        }
        
        //RESPUESTA DE CONDUCTOR A SOLICITUD
        
        myvariables.socket.on("Aceptada"){data, ack in
            self.AlertaEsperaView.isHidden = true
            let temporal = String(describing: data).components(separatedBy: ",")
            //#Aceptada, idsolicitud, idconductor, nombreApellidosConductor, movilConductor, URLfoto, idTaxi, Codvehiculo, matricula, marca, color, latTaxi, lngTaxi
            if temporal[0] == "#Aceptada" || temporal[0] == "[#Aceptada"{
                for solicitud in self.solpendientes{
                    if solicitud.idSolicitud == temporal[1]{
                        self.SolicitudAceptadaView.isHidden = false
                        self.SMSVozBtn.isHidden = false
                        self.EvaluarBtn.isHidden = false
                        //self.MensajesBtn.hidden = false
                        self.LlamarCondBtn.isHidden = false
                        self.AlertaEsperaView.isHidden = true
                        self.CancelarSolicitudProceso.isHidden = true
                        self.AgregarTaxiSolicitud(temporal)
                        
                        let alertaDos = UIAlertController (title: "Solicitud Aceptada", message: "Su vehículo se encuentra en camino, siga su trayectoria en el mapa y/o comuníquese con el conductor.", preferredStyle: .alert)
                        alertaDos.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: {alerAction in
                            self.SolicitudAceptadaView.isHidden = false
                            self.SMSVozBtn.isHidden = false
                            self.EvaluarBtn.isHidden = false
                            //self.MensajesBtn.hidden = false
                            self.LlamarCondBtn.isHidden = false
                            self.CantSolPendientes.text = String(self.solpendientes.count)
                            self.SolPendImage.isHidden = false
                            self.CantSolPendientes.isHidden = false
                        }))
                        
                        //Para hacer que la alerta se muestre usamos presentViewController, a diferencia de Objective C que como recordaremos se usa [Show Alerta]
                        alertaDos.view.tintColor = UIColor.black
                        let subview = alertaDos.view.subviews.last! as UIView
                        let alertContentView = subview.subviews.last! as UIView
                        alertContentView.backgroundColor = UIColor(red: 252.0/255.0, green: 238.0/255.0, blue: 129.0/255.0, alpha: 1.0)
                        alertContentView.layer.cornerRadius = 5
                        let TitleString = NSAttributedString(string: "Solicitud Aceptada", attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: 19), NSForegroundColorAttributeName : UIColor.black])
                        alertaDos.setValue(TitleString, forKey: "attributedTitle")
                        self.present(alertaDos, animated: true, completion: nil)
                    }
                }
            }
            else{
                if temporal[0] == "#Cancelada" {
                    //#Cancelada, idsolicitud
                  
                    let alertaDos = UIAlertController (title: "Estado de Solicitud", message: "Ningún vehículo acepto su solicitud, puede intentarlo más tarde.", preferredStyle: .alert)
                    alertaDos.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: {alerAction in
                        self.Inicio()
                    }))
                    
                    //Para hacer que la alerta se muestre usamos presentViewController, a diferencia de Objective C que como recordaremos se usa [Show Alerta]
                    alertaDos.view.tintColor = UIColor.black
                    let subview = alertaDos.view.subviews.last! as UIView
                    let alertContentView = subview.subviews.last! as UIView
                    alertContentView.backgroundColor = UIColor(red: 252.0/255.0, green: 238.0/255.0, blue: 129.0/255.0, alpha: 1.0)
                    alertContentView.layer.cornerRadius = 5
                    let TitleString = NSAttributedString(string: "Estado de Solicitud", attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: 19), NSForegroundColorAttributeName : UIColor.black])
                    alertaDos.setValue(TitleString, forKey: "attributedTitle")
                    //let MessageString = NSAttributedString(string: Message, attributes: [NSFontAttributeName : UIFont.systemFontOfSize(15), NSForegroundColorAttributeName : MessageColor])

                    self.present(alertaDos, animated: true, completion: nil)

                  }
            }
        }
        
        myvariables.socket.on("Cambioestadosolicitudconductor"){data, ack in
            let temporal = String(describing: data).components(separatedBy: ",")
            let alertaDos = UIAlertController (title: "Estado de Solicitud", message: "Solicitud cancelada por el conductor.", preferredStyle: UIAlertControllerStyle.alert)
            alertaDos.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: {alerAction in
                var pos = -1
                pos = self.BuscarPosSolicitudID(temporal[1])
                if  pos != -1{
                self.CancelarSolicitudes(pos, motivo: "Conductor")
                }
            }))
            
            //Para hacer que la alerta se muestre usamos presentViewController, a diferencia de Objective C que como recordaremos se usa [Show Alerta]
            alertaDos.view.tintColor = UIColor.black
            let subview = alertaDos.view.subviews.last! as UIView
            let alertContentView = subview.subviews.last! as UIView
            alertContentView.backgroundColor = UIColor(red: 252.0/255.0, green: 238.0/255.0, blue: 129.0/255.0, alpha: 1.0)
            alertContentView.layer.cornerRadius = 5
            let TitleString = NSAttributedString(string: "Estado de Solicitud", attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: 19), NSForegroundColorAttributeName : UIColor.black])
            alertaDos.setValue(TitleString, forKey: "attributedTitle")
            //let MessageString = NSAttributedString(string: Message, attributes: [NSFontAttributeName : UIFont.systemFontOfSize(15), NSForegroundColorAttributeName : MessageColor])

            self.present(alertaDos, animated: true, completion: nil)
        }
        //SOLICITUDES SIN RESPUESTA DE TAXIS
        myvariables.socket.on("SNA"){data, ack in
            let temporal = String(describing: data).components(separatedBy: ",")
            if self.solpendientes.count != 0{
                for solicitudenproceso in self.solpendientes{
                    if solicitudenproceso.idSolicitud == temporal[1]{
                        let alertaDos = UIAlertController (title: "Estado de Solicitud", message: "No se encontó ningún taxi disponible para ejecutar su solicitud. Por favor inténtelo más tarde.", preferredStyle: UIAlertControllerStyle.alert)
                        alertaDos.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: {alerAction in
                            self.CancelarSolicitudes(self.BuscarPosSolicitudID(temporal[1]), motivo: "")
                        }))
                        
                        //Para hacer que la alerta se muestre usamos presentViewController, a diferencia de Objective C que como recordaremos se usa [Show Alerta]
                        alertaDos.view.tintColor = UIColor.black
                        let subview = alertaDos.view.subviews.last! as UIView
                        let alertContentView = subview.subviews.last! as UIView
                        alertContentView.backgroundColor = UIColor(red: 252.0/255.0, green: 238.0/255.0, blue: 129.0/255.0, alpha: 1.0)
                        alertContentView.layer.cornerRadius = 5
                        let TitleString = NSAttributedString(string: "Estado de Solicitud", attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: 19), NSForegroundColorAttributeName : UIColor.black])
                        alertaDos.setValue(TitleString, forKey: "attributedTitle")
                        //let MessageString = NSAttributedString(string: Message, attributes: [NSFontAttributeName : UIFont.systemFontOfSize(15), NSForegroundColorAttributeName : MessageColor])
                        
                        self.present(alertaDos, animated: true, completion: nil)
                    }
                }
            }
            
        }
        
        //URl PARA AUDIO
        myvariables.socket.on("U"){data, ack in
            let temporal = String(describing: data).components(separatedBy: ",")
            self.UrlSubirVoz = temporal[1]
        }
        
        myvariables.socket.on("V"){data, ack in
            self.urlconductor = String()
            let temporal = String(describing: data).components(separatedBy: ",")
                self.urlconductor = temporal[1]
                self.MensajesBtn.setImage(UIImage(named: "mensajesnew"),for: UIControlState())
                self.MensajesBtn.isHidden = false
                self.SMSVoz.ReproducirMusica()
                if !self.grabando{
                    self.SMSVoz.ReproducirVozConductor(self.urlconductor)
                }
        }
        
        myvariables.socket.on("disconnect"){data, ack in
           self.timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(PantallaInicio.Reconect), userInfo: nil, repeats: true)
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
                self.GuardarTelefonos(temporal)
            }
        }
        
        //RECUPERAR CLAVES
        myvariables.socket.on("Recuperarclave"){data, ack in
         let temporal = String(describing: data).components(separatedBy: ",")
            if temporal[1] == "ok"{
                let alertaDos = UIAlertController (title: "Recuperación de clave", message: "Su clave ha sido recuperada satisfactoriamente, en este momento ha recibido un correo electronico a la dirección: " + temporal[2], preferredStyle: UIAlertControllerStyle.alert)
                alertaDos.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: {alerAction in
                }))
                
                //Para hacer que la alerta se muestre usamos presentViewController, a diferencia de Objective C que como recordaremos se usa [Show Alerta]
                alertaDos.view.tintColor = UIColor.black
                let subview = alertaDos.view.subviews.last! as UIView
                let alertContentView = subview.subviews.last! as UIView
                alertContentView.backgroundColor = UIColor(red: 252.0/255.0, green: 238.0/255.0, blue: 129.0/255.0, alpha: 1.0)
                alertContentView.layer.cornerRadius = 5
                let TitleString = NSAttributedString(string: "Recuperación de clave", attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: 19), NSForegroundColorAttributeName : UIColor.black])
                alertaDos.setValue(TitleString, forKey: "attributedTitle")
                //let MessageString = NSAttributedString(string: Message, attributes: [NSFontAttributeName : UIFont.systemFontOfSize(15), NSForegroundColorAttributeName : MessageColor])
                
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
                let alertaDos = UIAlertController (title: "Cambio de clave", message: "Su clave ha sido cambiada satisfactoriamente", preferredStyle: UIAlertControllerStyle.alert)
                alertaDos.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: {alerAction in
                    self.FondoClaveView.isHidden = true
                }))
                
                //Para hacer que la alerta se muestre usamos presentViewController, a diferencia de Objective C que como recordaremos se usa [Show Alerta]
                alertaDos.view.tintColor = UIColor.black
                let subview = alertaDos.view.subviews.last! as UIView
                let alertContentView = subview.subviews.last! as UIView
                alertContentView.backgroundColor = UIColor(red: 252.0/255.0, green: 238.0/255.0, blue: 129.0/255.0, alpha: 1.0)
                alertContentView.layer.cornerRadius = 5
                let TitleString = NSAttributedString(string: "Cambio de clave", attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: 19), NSForegroundColorAttributeName : UIColor.black])
                alertaDos.setValue(TitleString, forKey: "attributedTitle")
                //let MessageString = NSAttributedString(string: Message, attributes: [NSFontAttributeName : UIFont.systemFontOfSize(15), NSForegroundColorAttributeName : MessageColor])
                
                self.present(alertaDos, animated: true, completion: nil)
                
            }else{
                let alertaDos = UIAlertController (title: "Cambio de clave", message: "Se produjo un error al cambiar su clave. Revise la información ingresada e inténtelo más tarde.", preferredStyle: UIAlertControllerStyle.alert)
                alertaDos.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: {alerAction in
                    self.FondoClaveView.isHidden = true
                }))
                
                //Para hacer que la alerta se muestre usamos presentViewController, a diferencia de Objective C que como recordaremos se usa [Show Alerta]
                alertaDos.view.tintColor = UIColor.black
                let subview = alertaDos.view.subviews.last! as UIView
                let alertContentView = subview.subviews.last! as UIView
                alertContentView.backgroundColor = UIColor(red: 252.0/255.0, green: 238.0/255.0, blue: 129.0/255.0, alpha: 1.0)
                alertContentView.layer.cornerRadius = 5
                let TitleString = NSAttributedString(string: "Cambio de clave", attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: 19), NSForegroundColorAttributeName : UIColor.black])
                alertaDos.setValue(TitleString, forKey: "attributedTitle")
                //let MessageString = NSAttributedString(string: Message, attributes: [NSFontAttributeName : UIFont.systemFontOfSize(15), NSForegroundColorAttributeName : MessageColor])
                self.present(alertaDos, animated: true, completion: nil)
            }

        }
    }
    
    
    
    
  
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.miposicion = locations[locations.count - 1].coordinate
        if myvariables.taximetroActive{
            if locations[locations.count - 1].horizontalAccuracy < 10 && locations[locations.count - 1].speed > 0.5{
                let recorrido = locations[locations.count - 1].distance(from: self.taximetro.LastPosition) / 1000
                self.taximetro.Distancia += recorrido
                self.taximetro.ValorPagar += recorrido * self.taximetro.ValorKilometro
                self.taximetro.LastPosition = locations[locations.count - 1]
                self.TaximetroDistanciaText.text = String(format: "%.3f km", self.taximetro.Distancia)
            }
        }else{
            self.setuplocationMarker(miposicion)
            //GeolocalizandoView.isHidden = true
            self.SolicitarBtn.isHidden = false
            EvaluacionView.isHidden = true
            ComentarioEvalua.isHidden = true
        }

    }
    
    func setuplocationMarker(_ coordinate: CLLocationCoordinate2D) {
            self.userAnotacion.position = coordinate
            userAnotacion.snippet = "Cliente"
            userAnotacion.icon = UIImage(named: "origen")
            mapaVista.camera = GMSCameraPosition.camera(withLatitude: userAnotacion.position.latitude,longitude:userAnotacion.position.longitude,zoom: 14)
            self.origenIcono.isHidden = false
            ExplicacionText.text = "Localice el origen en el mapa"
            ExplicacionView.isHidden = false
            coreLocationManager.stopUpdatingLocation()
    }

    func mapView(_ mapView: GMSMapView!, didTapAt coordinate: CLLocationCoordinate2D) {
        if SelectOpcion.frame.origin.x == SolPendientesBtn.frame.origin.x - 5 || SelectOpcion.frame.origin.x == CallCEnterBtn.frame.origin.x - 5{
            self.TablaSolPendientes.isHidden = true
            SolPendientesView.isHidden = true
            self.CallCenterView.isHidden = true
            Inicio()
            //self.LoginView.endEditing(true)
        }
        
        self.formularioSolicitud.endEditing(true)
        self.ComentarioText.endEditing(true)
        CallCenterView.isHidden = true
    }
    
    func mapView(_ mapView: GMSMapView!, idleAt position: GMSCameraPosition!) {
        origenIcono.isHidden = true
        
        if SolicitarBtn.isHidden == false {
            origenAnotacion = GMSMarker(position: mapaVista.camera.target)
            self.DireccionDeCoordenada(self.origenAnotacion.position, directionText: origenText)
            origenAnotacion.icon = UIImage(named: "origen")
            origenAnotacion.snippet = origenText.text
            origenAnotacion.map = mapaVista
            //GeolocalizandoView.isHidden = false
        }
        else{
            if aceptarLocBtn.isHidden == false{
                destinoAnotacion = GMSMarker(position: mapaVista.camera.target)
                self.DireccionDeCoordenada(self.destinoAnotacion.position, directionText: origenText)
                destinoAnotacion.icon = UIImage(named: "destino")
                origenAnotacion.snippet = destinoText.text
                destinoAnotacion.map = mapaVista
            //GeolocalizandoView.isHidden = false
            }
        }
    }
    
    func mapView(_ mapView: GMSMapView!, didChange position: GMSCameraPosition!) {
        if DetallesCarreraView.isHidden == true && AlertaEsperaView.isHidden == true && SolicitudAceptadaView.isHidden == true && CancelarSolicitudProceso.isHidden == true{
            if SolicitarBtn.isHidden == false {
                origenIcono.isHidden = false
                origenAnotacion.map = nil
            }
            else{
                origenIcono.isHidden = false
                destinoAnotacion.map = nil
            }
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.ComentarioText.resignFirstResponder()
    }
    
    //OCULTAR TECLADO CON TECLA ENTER
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        //self.LoginView.endEditing(true)
        return true
    }
    
    //RECONECT SOCKET
    func Reconect(){
        if contador <= 5 {
            myvariables.socket.connect()
            contador += 1
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
            let TitleString = NSAttributedString(string: "Sin Conexión", attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: 19), NSForegroundColorAttributeName : UIColor.black])
            alertaDos.setValue(TitleString, forKey: "attributedTitle")

            self.present(alertaDos, animated: true, completion: nil)
        }
    }
    
    //NOTIFICACIÓN PARA BACKGROUND
    
       func Inicio(){
        mapaVista!.clear()
        self.coreLocationManager.startUpdatingLocation()
        self.origenAnotacion.position = (self.coreLocationManager.location?.coordinate)!
        self.origenIcono.image = UIImage(named: "origen2")
        self.origenAnotacion.snippet = "Cliente"
        self.origenAnotacion.icon = UIImage(named: "origen")
        mapaVista.camera = GMSCameraPosition.camera(withLatitude: self.origenAnotacion.position.latitude,longitude: self.origenAnotacion.position.longitude,zoom: 15)
        self.origenIcono.isHidden = false
        ExplicacionText.text = "Localice el origen"
        ExplicacionView.isHidden = false
        self.TablaSolPendientes.reloadData()
        if solpendientes.count != 0 {
            self.SolPendImage.isHidden = false
            self.CantSolPendientes.text = String(self.solpendientes.count)
            self.CantSolPendientes.isHidden = false
        }
        SolicitudAceptadaView.isHidden = true
        SMSVozBtn.isHidden = true
        EvaluarBtn.isHidden = true
        EvaluacionView.isHidden = true
        ComentarioEvalua.isHidden = true
        MensajesBtn.isHidden = true
        LlamarCondBtn.isHidden = true
        DetallesCarreraView.isHidden = true
        formularioSolicitud.isHidden = true
        self.SolicitarBtn.isHidden = false
        TablaSolPendientes.isHidden = true
        SolPendientesView.isHidden = true
        aceptarLocBtn.isHidden = true
        CancelarEnvioBtn.isHidden = true
        CancelarSolicitudProceso.isHidden = true
        AlertaEsperaView.isHidden = true
        CallCenterView.isHidden = true
        SelectOpcion.frame.origin.x = MapaBtn.frame.origin.x - 5
        self.TaximetroView.isHidden = true
       
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
                let TitleString = NSAttributedString(string: "Sin Conexión", attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: 19), NSForegroundColorAttributeName : UIColor.black])
                alertaDos.setValue(TitleString, forKey: "attributedTitle")
                //let MessageString = NSAttributedString(string: Message, attributes: [NSFontAttributeName : UIFont.systemFontOfSize(15), NSForegroundColorAttributeName : MessageColor])
                
                self.present(alertaDos, animated: true, completion: nil)
            }
        }else{
            ErrorConexion()
        }
    }
    
    //MOSTRAR TODOS LOS MARCADORES EN PANTALLA
    func fitAllMarkers(_ markers: [GMSMarker]) {
        var bounds = GMSCoordinateBounds()
        for marcador in markers{
            bounds = bounds.includingCoordinate(marcador.position)
        }
        mapaVista.animate(with: GMSCameraUpdate.fit(bounds))
    }
    
    //Crear las rutas entre los puntos de origen y destino
    func RutaCliente(_ origen: CLLocationCoordinate2D, destino: CLLocationCoordinate2D, taxi: CLLocationCoordinate2D)->[String]{

        var distancia = "???"
        var duracion = "???"
        let origentext = String(origen.latitude) + "," + String(origen.longitude)
        if ((taxi.latitude == 0.0 || taxi.latitude == 0) && destino.latitude != 0){
            let destinotext = String(destino.latitude) + "," + String(destino.longitude)
            let ruta = CRuta(origin: origentext, destination: destinotext)
            let routePolyline = ruta.drawRoute()
            let lines = GMSPolyline(path: routePolyline)
            lines.strokeWidth = 5
            lines.map = self.mapaVista
            lines.strokeColor = UIColor.green
            distancia = ruta.totalDistance
            duracion = ruta.totalDuration
        }
        else{
            if ((destino.latitude == 0) && (taxi.latitude != 0)){
                let taxitext = String(taxi.latitude) + "," + String(taxi.longitude)
                let ruta = CRuta(origin: origentext, destination: taxitext)
                let routePolyline = ruta.drawRoute()
                let lines = GMSPolyline(path: routePolyline)
                lines.strokeWidth = 5
                lines.map = self.mapaVista
                lines.strokeColor = UIColor.red
                distancia = ruta.totalDistance
                duracion = ruta.totalDuration
            }
            else{
                let destinotext = String(destino.latitude) + "," + String(destino.longitude)
                let taxitext = String(taxi.latitude) + "," + String(taxi.longitude)
                let rutataxi = CRuta(origin: origentext, destination: taxitext)
                let routePolylineTaxi = rutataxi.drawRoute()
                let linestaxi = GMSPolyline(path: routePolylineTaxi)
                    linestaxi.strokeWidth = 4
                    linestaxi.strokeColor = UIColor.red
                    linestaxi.map = self.mapaVista
                    duracion = rutataxi.totalDuration
                let ruta = CRuta(origin: origentext, destination: destinotext)
                let routePolyline = ruta.drawRoute()
                let lines = GMSPolyline(path: routePolyline)
                lines.strokeWidth = 5
                lines.map = self.mapaVista
                lines.strokeColor = UIColor.green
                distancia = ruta.totalDistance
            }
        }
        
        return [distancia, duracion]
    }
    
    
    //FUNCION DE AUTENTICACION
    func Login(){
        var readString = ""
        let filePath = NSHomeDirectory() + "/Library/Caches/log.txt"
        
        do {
            readString = try NSString(contentsOfFile: filePath, encoding: String.Encoding.utf8.rawValue) as String
        } catch {
        }
        self.login = String(readString).components(separatedBy: ",")
        EnviarSocket(readString)
        let datos = "#CargarTarifas"
        EnviarSocket(datos)
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
            solpendientes.append(solicitudpdte)
            if solicitudpdte.idTaxi != ""{
                myvariables.solicitudesproceso = true
            }
            i += 11
        }
        self.TablaSolPendientes.reloadData()
        self.CantSolPendientes.isHidden = false
        self.CantSolPendientes.text = String(self.solpendientes.count)
        self.SolPendImage.isHidden = false
    }


    //FUncion para mostrar los taxis
    func MostrarTaxi(_ temporal : [String]){
        //TRAMA IN: #Posicion,idtaxi,lattaxi,lngtaxi
        var i = 2
        while i  <= temporal.count - 6{ 
            let taxiTemp = GMSMarker(position: CLLocationCoordinate2DMake(Double(temporal[i + 2])!, Double(temporal[i + 3])!))
            taxiTemp.title = temporal[i]
            taxiTemp.icon = UIImage(named: "taxi_libre")
            taxiscercanos.append(taxiTemp)
            i += 6
        }
        DibujarIconos(taxiscercanos)
    }
    

    //Funcion para Mostrar Datos del Taxi seleccionado
    func AgregarTaxiSolicitud(_ temporal : [String]){
        //#Aceptada, idsolicitud, idconductor, nombreApellidosConductor, movilConductor, URLfoto, idTaxi, Codvehiculo, matricula, marca_modelo, color, latTaxi, lngTaxi
        for solicitud in solpendientes{
            if solicitud.idSolicitud == temporal[1]{
                myvariables.solicitudesproceso = true
                solicitud.DatosTaxiConductor(idtaxi: temporal[6], matricula: temporal[8], codigovehiculo: temporal[7], marcaVehiculo: temporal[9],colorVehiculo: temporal[10], lattaxi: temporal[11], lngtaxi: temporal[12], idconductor: temporal[2], nombreapellidosconductor: temporal[3], movilconductor: temporal[4], foto: temporal[5])
                solicitud.taximarker.map = mapaVista
                _ = RutaCliente(solicitud.origenCarrera.position, destino: solicitud.destinoCarrera.position, taxi: solicitud.taximarker.position)
                self.indexselect = solpendientes.count - 1
                if solicitud.tiempo != "0"{
                    DuracionText.text = solicitud.tiempo
                    DistanciaText.text = String(solicitud.distancia) + "KM"
                    CostoText.text = "$"+solicitud.costo
                    self.DetallesCarreraView.isHidden = false
                    //self.TiempoTaxi.text = solicitud.TiempoTaxi()
                }
                
            }
        }
        //let posicion = BuscarPosSolicitudID(temporal[1])
        
        self.NombreCond.text! = "Nombre: " + temporal[3]
        self.MovilCond.text! = "Movil: " + temporal[4]
        self.MarcaAut.text! = "Marca automovil: " + temporal[9]
        self.ColorAut.text! = "Color del automovil: " + temporal[10]
        self.MatriculaAut.text! = "Matrícula del automovil: " + temporal[8]
        if temporal[5] != "null" && temporal[5] != ""{
            URLSession.shared.dataTask(with: URL(string: temporal[5])!, completionHandler: { (data, response, error) in
                DispatchQueue.main.async {
                    _ = UIViewContentMode.scaleAspectFill
                    self.ImagenCond.image = UIImage(data: data!)
                }
            }) 
        }else{
            self.ImagenCond.image = UIImage(named: "chofer")
        }
    }
    
    //Respuesta de solicitud
    func ConfirmaSolicitud(_ Temporal : [String]){
        //Trama IN: #Solicitud, ok, idsolicitud, fechahora
        
       if Temporal[1] == "ok"{
        self.solpendientes.last!.RegistrarFechaHora(IdSolicitud: Temporal[2], FechaHora: Temporal[3])
        if self.solpendientes.last!.destinoCarrera.position.latitude != Double(0){
            let detalles = self.solpendientes.last!.DetallesCarrera(tarifas: tarifas)
            DistanciaText.text = detalles[0] + " KM"
            DuracionText.text = detalles[1]
            CostoText.text = "$" + detalles[2]
            DetallesCarreraView.isHidden = false
        }
        
        self.TablaSolPendientes.reloadData()
        self.CantSolPendientes.isHidden = false
        self.CantSolPendientes.text = String(self.solpendientes.count)
        self.SolPendImage.isHidden = false
       }
       else{
            if Temporal[1] == "error"{
                
            }
        }
    }
    //CANCELAR SOLICITUDES
    func MostrarMotivoCancelacion(){
        let motivoAlerta = UIAlertController(title: "", message: "Seleccione el motivo de cancelación.", preferredStyle: UIAlertControllerStyle.actionSheet)
        motivoAlerta.addAction(UIAlertAction(title: "No necesito", style: .default, handler: { action in
            //["No necesito","Demora el servicio","Tarifa incorrecta","Solo probaba el servicio", "Cancelar"]
            if self.AlertaEsperaView.isHidden == false{
                self.CancelarSolicitudes(self.solpendientes.count-1, motivo: "No necesito")
            }
            else{
                self.CancelarSolicitudes(self.indexselect, motivo: "No necesito")
            }
        }))
        motivoAlerta.addAction(UIAlertAction(title: "Demora el servicio", style: .default, handler: { action in
            //["No necesito","Demora el servicio","Tarifa incorrecta","Solo probaba el servicio", "Cancelar"]
            if self.AlertaEsperaView.isHidden == false{
                self.CancelarSolicitudes(self.solpendientes.count-1, motivo: "Demora el servicio")
            }
            else{
                self.CancelarSolicitudes(self.indexselect, motivo: "Demora el servicio")
            }
        }))
        motivoAlerta.addAction(UIAlertAction(title: "Tarifa incorrecta", style: .default, handler: { action in
            //["No necesito","Demora el servicio","Tarifa incorrecta","Solo probaba el servicio", "Cancelar"]
            if self.AlertaEsperaView.isHidden == false{
                self.CancelarSolicitudes(self.solpendientes.count-1, motivo: "Tarifa incorrecta")
            }
            else{
                self.CancelarSolicitudes(self.indexselect, motivo: "Tarifa incorrecta")
            }
        }))
        motivoAlerta.addAction(UIAlertAction(title: "Vehículo en mal estado", style: .default, handler: { action in
            //["No necesito","Demora el servicio","Tarifa incorrecta","Solo probaba el servicio", "Cancelar"]
            if self.AlertaEsperaView.isHidden == false{
                self.CancelarSolicitudes(self.solpendientes.count-1, motivo: "Vehículo en mal estado")
            }
            else{
                self.CancelarSolicitudes(self.indexselect, motivo: "Vehículo en mal estado")
            }
        }))
        motivoAlerta.addAction(UIAlertAction(title: "Solo probaba el servicio", style: .default, handler: { action in
            //["No necesito","Demora el servicio","Tarifa incorrecta","Solo probaba el servicio", "Cancelar"]
            if self.AlertaEsperaView.isHidden == false{
                self.CancelarSolicitudes(self.solpendientes.count-1, motivo: "Solo probaba el servicio")
            }
            else{
                self.CancelarSolicitudes(self.indexselect, motivo: "Solo probaba el servicio")
            }
        }))
        motivoAlerta.addAction(UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.destructive, handler: { action in
        }))
        
        motivoAlerta.view.tintColor = UIColor.black
        let subview = motivoAlerta.view.subviews.first! as UIView
        let alertContentView = subview.subviews.first! as UIView
        //let cancelbutton = alertContentView.subviews.last! as UIView
        alertContentView.backgroundColor = UIColor(red: 252.0/255.0, green: 238.0/255.0, blue: 129.0/255.0, alpha: 1.0)
        alertContentView.layer.cornerRadius = 5
        self.present(motivoAlerta, animated: true, completion: nil)
    }
    
    func CancelarSolicitudes(_ posicion: Int, motivo: String){
        //#Cancelarsolicitud, idSolicitud, idTaxi, motivo, "# \n"
        let Datos = "#Cancelarsolicitud" + "," + self.solpendientes[posicion].idSolicitud + "," + self.solpendientes[posicion].idTaxi + "," + motivo + "," + "# \n"
        self.solpendientes.remove(at: posicion)
        self.TablaSolPendientes.reloadData()
        if solpendientes.count == 0 {
            self.SolPendImage.isHidden = true
            CantSolPendientes.isHidden = true
            myvariables.solicitudesproceso = false
          }
        EnviarSocket(Datos)
    }
   
    //CREAR SOLICITUD CON LOS DATOS DEL CIENTE, SU LOCALIZACIÓN DE ORIGEN Y DESTINO
    func CrearSolicitud(_ nuevaSolicitud: CSolicitud){
        //#Solicitud, idcliente, nombrecliente, movilcliente, dirorig, referencia, dirdest,latorig,lngorig, latdest, lngdest, distancia, costo, #
        formularioSolicitud.isHidden = true
        origenIcono.isHidden = true
        self.solpendientes.append(nuevaSolicitud)
        self.referenciaText.text = ""
        self.origenText.text = ""

        let datoscliente = nuevaSolicitud.idCliente + "," + nuevaSolicitud.nombreApellidos + "," + nuevaSolicitud.user
        let datossolicitud = nuevaSolicitud.origenCarrera.snippet! + "," + nuevaSolicitud.referenciaorigen + "," + destinoText.text!
        let datosgeo = String(nuevaSolicitud.distancia) + "," + nuevaSolicitud.costo
        let Datos = "#Solicitud" + "," + datoscliente + "," + datossolicitud + "," + String(nuevaSolicitud.origenCarrera.position.latitude) + "," + String(nuevaSolicitud.origenCarrera.position.longitude) + "," + String(nuevaSolicitud.destinoCarrera.position.latitude) + "," + String(nuevaSolicitud.destinoCarrera.position.longitude) + "," + datosgeo + ",# \n"
        
        EnviarSocket(Datos)
        MensajeEspera.text = "Procesando..."
        self.AlertaEsperaView.isHidden = false
        
    }
    
   //FUNCION PARA DIBUJAR LAS ANOTACIONES
    
    func DibujarIconos(_ anotaciones: [GMSMarker]){
        if anotaciones.count == 1{
            mapaVista!.camera = GMSCameraPosition.camera(withLatitude: anotaciones[0].position.latitude, longitude: anotaciones[0].position.longitude, zoom: 12)
            anotaciones[0].map = mapaVista
        }
        else{
            for var anotacionview in anotaciones{
                if ((anotacionview.position.latitude != 0) && (anotacionview.position.longitude != 0)){
                anotacionview.map = mapaVista
                }
                fitAllMarkers(anotaciones)
            }
        }        
    }
    
    //FUNCION DETERMINAR DIRECCIÓN A PARTIR DE COORDENADAS
    func DireccionDeCoordenada(_ coordenada : CLLocationCoordinate2D, directionText : UITextField){
        let geocoder = GMSGeocoder()
        var address = ""
        if CConexionInternet.isConnectedToNetwork() == true {
            let temporaLocation = CLLocation(latitude: coordenada.latitude, longitude: coordenada.longitude)
            CLGeocoder().reverseGeocodeLocation(temporaLocation, completionHandler: {(placemarks, error) -> Void in

                
                if error != nil {
                    print("Reverse geocoder failed with error" + (error?.localizedDescription)!)
                    return
                }
                
                if (placemarks?.count)! > 0 {
                    let placemark = (placemarks?[0])! as CLPlacemark
                    if let name = placemark.addressDictionary?["Name"] as? String {
                        address += name
                    }
                    
                    if let city = placemark.addressDictionary?["City"] as? String {
                        address += ",\(city)"
                    }
                    
                    if let state = placemark.addressDictionary?["State"] as? String {
                        address += ",\(state)"
                    }
                    
                    if let country = placemark.country{
                        address += ",\(country)"
                    }
                    directionText.text = address
                    //self.GeolocalizandoView.isHidden = true
                }
                else {
                    directionText.text = "No disponible"
                    //self.GeolocalizandoView.isHidden = true
                }
            })

        }else{
            ErrorConexion()
        }
    }
    
    //FUNCION LIMPIAR MAPA Y OCULTAR VISTAS
    func OcultarVistas(){
        GeolocalizandoView.isHidden = true
        TablaSolPendientes.isHidden = true
        SolPendientesView.isHidden = true
        formularioSolicitud.isHidden = true
        ExplicacionView.isHidden = true
        //SolicitudMapaView.hidden = true
        SolicitarBtn.isHidden = true
        mapaVista.clear()
    }
    
    //FUNCIÓN BUSCA UNA SOLICITUD DENTRO DEL ARRAY DE SOLICITUDES PENDIENTES DADO SU ID
    func BuscarSolicitudID(_ id : String)->CSolicitud{
        var temporal : CSolicitud!
        for solicitudpdt in solpendientes{
            if solicitudpdt.idSolicitud == id{
                temporal = solicitudpdt
            }
        }
        return temporal
    }
    //devolver posicion de solicitud
    func BuscarPosSolicitudID(_ id : String)->Int{
        var temporal = 0
        var posicion = -1
        for solicitudpdt in solpendientes{
            if solicitudpdt.idSolicitud == id{
                posicion = temporal
            }
            temporal += 1
        }
        return posicion
    }
    
    //MOSTRAR DETALLES DE LAS SOLICITUDES PENDIENTES CUANDO EL CLIENTE SELECCIONA
   /* func MostrarDetalleSolicitud(_ posicion : Int){
        self.coreLocationManager.stopUpdatingLocation()
        SelectOpcion.frame.origin.x = MapaBtn.frame.origin.x - 5
        self.mapaVista.clear()
        var iconos = [GMSMarker]()
        iconos.append(self.solpendientes[posicion].origenCarrera)
        CancelarSolicitudProceso.isHidden = false
        if solpendientes[posicion].idTaxi != "null" && solpendientes[posicion].idTaxi != ""{
            iconos.append(solpendientes[posicion].taximarker)
            SMSVozBtn.isHidden = false
            EvaluarBtn.isHidden = false
            LlamarCondBtn.isHidden = false
            SolicitudAceptadaView.isHidden = false
            CancelarSolicitudProceso.isHidden = true
            self.AlertaEsperaView.isHidden = true
            //self.TiempoTaxi.text = solpendientes[posicion].TiempoTaxi()
        }
        if self.solpendientes[posicion].destinoCarrera.position.latitude != Double("0"){
            solpendientes[posicion].DetallesCarrera(tarifas: tarifas)
            DistanciaText.text = String(solpendientes[posicion].distancia) + " KM"
            DuracionText.text = solpendientes[posicion].tiempo
            CostoText.text = "$" + self.solpendientes[posicion].costo
            DetallesCarreraView.isHidden = false
            self.SMSVozBtn.setImage(UIImage(named:"smsvoz"),for: UIControlState())
            
            iconos.append(self.solpendientes[posicion].destinoCarrera)
        }
        
        self.TablaSolPendientes.isHidden = true
        SolPendientesView.isHidden = true
        self.SolicitarBtn.isHidden = true
        self.origenIcono.isHidden = true
        self.DibujarIconos(iconos)
        solpendientes[posicion].DibujarRutaSolicitud(mapa: mapaVista,AlertaSinConexión: self.AlertaSinConexion)
        
    }*/
    
    func GrabarSMSVoz(){
        DetallesCarreraView.isHidden = false
    }
    
    //ENVIAR EVALUACIÓN
    func EnviarEvaluacion(_ evaluacion: Int, comentario: String){
        ComentarioEvalua.isHidden = true
        EvaluacionView.isHidden = true
        ComentarioEvalua.isHidden = true
        SelectOpcion.frame.origin.x = MapaBtn.frame.origin.x - 5
        let idsolicitud = self.solpendientes[indexselect].idSolicitud
        let datos = "#Evaluar," + idsolicitud + "," + String(evaluacion) + "," + comentario + ",# \n"
        EnviarSocket(datos)
        Inicio()
    }
    
    //COMPARTIR POR WHATSAPP
    func CompartirWhatsapp(_ url: String){
        if let name = URL(string: url) {
            let objectsToShare = [name]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            self.present(activityVC, animated: true, completion: nil)
        }
        else
        {
            // show alert for not available
        }
    }
    //BOTONES DE INTERFAZ
    
    @IBAction func Solicitar(_ sender: AnyObject) {
        //TRAMA OUT: #Posicion,idCliente,latorig,lngorig
        self.origenIcono.isHidden = true
        self.origenAnotacion.position = mapaVista.camera.target
        //self.DireccionDeCoordenada(self.origenAnotacion.position, directionText: origenText)
        coreLocationManager.stopUpdatingLocation()
        self.destinoText.text = ""
        TablaSolPendientes.isHidden = true
        SolPendientesView.isHidden = true
        self.SolPendImage.isHidden = true
        CantSolPendientes.isHidden = true
        self.SolicitarBtn.isHidden = true
        ExplicacionView.isHidden = true
        self.formularioSolicitud.isHidden = false
        let datos = "#Posicion," + myvariables.cliente.idCliente + "," + "\(self.origenAnotacion.position.latitude)," + "\(self.origenAnotacion.position.longitude)," + "# \n"
        EnviarSocket(datos)
    }
    
    //Botones para solicitud
    // Boton Vista Mapa para origen
 
    //Boton Vista Mapa para Destino
    @IBAction func DestinoBtn(_ sender: UIButton) {
        //mapaVista.clear()
        self.formularioSolicitud.isHidden = true
        self.origenIcono.image = UIImage(named: "destino2@2x")
        self.origenIcono.isHidden = false
        ExplicacionText.text = "Localice el destino en el mapa"
        ExplicacionView.isHidden = false
        self.origenAnotacion.map = mapaVista
        mapaVista.camera = GMSCameraPosition.camera(withLatitude: self.origenAnotacion.position.latitude, longitude: self.origenAnotacion.position.longitude, zoom: 12)
        self.coreLocationManager.stopUpdatingLocation()
        self.aceptarLocBtn.isHidden = false
        self.CancelarEnvioBtn.isHidden = false
    }
    
    //Aceptar y Enviar solicitud desde Pantalla de Destino
    @IBAction func AceptarLoc(_ sender: UIButton) {
        self.DireccionDeCoordenada(mapaVista.camera.target, directionText: destinoText)
        //self.DireccionDeCoordenada(self.destinoAnotacion.position, directionText: destinoText)
        mapaVista.clear()
        let nuevaSolicitud = CSolicitud()
            nuevaSolicitud.DatosCliente(cliente: myvariables.cliente)
            nuevaSolicitud.destinoCarrera = GMSMarker(position: mapaVista.camera.target)
            nuevaSolicitud.DatosSolicitud(dirorigen: origenText.text!, referenciaorigen: referenciaText.text!, dirdestino: destinoText.text!,  latorigen: String(Double(origenAnotacion.position.latitude)), lngorigen: String(Double(origenAnotacion.position.longitude)), latdestino: String(nuevaSolicitud.destinoCarrera.position.latitude), lngdestino: String(nuevaSolicitud.destinoCarrera.position.longitude),FechaHora: "")
            nuevaSolicitud.destinoCarrera.snippet = destinoText.text
            self.destinoAnotacion = GMSMarker(position: nuevaSolicitud.destinoCarrera.position)
            self.destinoAnotacion.icon = UIImage(named: "destino")
            self.formularioSolicitud.isHidden = false
            ExplicacionView.isHidden = true
            self.aceptarLocBtn.isHidden = true
            self.CancelarEnvioBtn.isHidden = true
            self.CrearSolicitud(nuevaSolicitud)
            self.DibujarIconos([self.origenAnotacion, self.destinoAnotacion])
            nuevaSolicitud.DibujarRutaSolicitud(mapa: mapaVista)
    }
    
    //Aceptar y Enviar solicitud desde formulario solicitud
    @IBAction func AceptarSolicitud(_ sender: AnyObject) {
        mapaVista.clear()
        let nuevaSolicitud = CSolicitud()
        nuevaSolicitud.DatosCliente(cliente: myvariables.cliente)
        nuevaSolicitud.DatosSolicitud(dirorigen: origenText.text!, referenciaorigen: referenciaText.text!, dirdestino: "", latorigen: String(Double(origenAnotacion.position.latitude)), lngorigen: String(Double(origenAnotacion.position.longitude)), latdestino: "0", lngdestino: "0",FechaHora: "")
        self.CrearSolicitud(nuevaSolicitud)
        DibujarIconos([self.origenAnotacion])
    }
    
    //Boton para Cancelar Carrera
    @IBAction func CancelarSol(_ sender: UIButton) {
           self.formularioSolicitud.isHidden = true
            self.Inicio()
            self.origenText.text = " "
            self.destinoText.text = " "
            self.referenciaText.text = " "
            self.SolicitarBtn.isHidden = false
        if solpendientes.count != 0{
            self.SolPendImage.isHidden = false
            self.CantSolPendientes.text = String(solpendientes.count)
            self.CantSolPendientes.isHidden = false
        }
    }
    
    @IBAction func CancelarProcesoSolicitud(_ sender: AnyObject) {
       MostrarMotivoCancelacion()
    }
    
    //Boton Mostrar Datos Conductor
    @IBAction func DatosConductor(_ sender: AnyObject) {
        let datos = "#Taxi," + self.idusuario + "," + solpendientes[indexselect].idTaxi + ",# \n"
        self.EnviarSocket(datos)
        MensajeEspera.text = "Procesando..."
        AlertaEsperaView.isHidden = false
     }
    
    @IBAction func AceptarCond(_ sender: UIButton) {
        self.DatosConductor.isHidden = true
        
    }
    
   
    //Boton Cerrar la APP
   
   /* @IBAction func CerrarAPP(_ sender: Any) {
        if !myvariables.taximetroActive{
        let fileAudio = FileManager()
        let AudioPath = NSHomeDirectory() + "/Library/Caches/Audio"
        do {
            try fileAudio.removeItem(atPath: AudioPath)
        }catch{
        }
        let datos = "#SocketClose," + myvariables.cliente.idCliente + ",# \n"
        EnviarSocket(datos)
        let alertaDos = UIAlertController (title: "Cerrar sesión", message: "Si cierra su sesión tendrá que autenticarse la próxima vez que inicie la aplicación.", preferredStyle: UIAlertControllerStyle.alert)
        alertaDos.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: {alerAction in
                let fileManager = FileManager()
                let filePath = NSHomeDirectory() + "/Library/Caches/log.txt"
                do {
                try fileManager.removeItem(atPath: filePath)
                }catch{
            }
            exit(0)
        }))
        alertaDos.addAction(UIAlertAction(title: "Cancelar", style: .default, handler: {alerAction in
            exit(0)
        }))
        
        //Para hacer que la alerta se muestre usamos presentViewController, a diferencia de Objective C que como recordaremos se usa [Show Alerta]
        alertaDos.view.tintColor = UIColor.black
        let subview = alertaDos.view.subviews.last! as UIView
        let alertContentView = subview.subviews.last! as UIView
        alertContentView.backgroundColor = UIColor(red: 252.0/255.0, green: 238.0/255.0, blue: 129.0/255.0, alpha: 1.0)
        alertContentView.layer.cornerRadius = 5
        let TitleString = NSAttributedString(string: "Cerrar Sesión", attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: 19), NSForegroundColorAttributeName : UIColor.black])
        alertaDos.setValue(TitleString, forKey: "attributedTitle")
        self.present(alertaDos, animated: true, completion: nil)
        }else{
            self.AlertaTaximetroView.isHidden = false
            self.TaximetroView.isHidden = false
        }
    }*/
    //COMPARTIR LA APP
    @IBAction func CompartirApp(_ sender: AnyObject) {
        CompartirTable.isHidden = false
    }
    
    //IOS
    @IBAction func CompartirIOS(_ sender: AnyObject) {
        self.CompartirWhatsapp(compartirOpcions[0])
        CompartirTable.isHidden = true
    }
    
    
    //ANDROID
    @IBAction func CompartirAndroid(_ sender: AnyObject) {
        self.CompartirWhatsapp(compartirOpcions[1])
        CompartirTable.isHidden = true
    }
    
    
    //BOTON DE CANCELAR EL ENVIO DE LA SOLICITUD
    @IBAction func CancelarEnvioBtn(_ sender: AnyObject) {
        self.formularioSolicitud.isHidden = false
        Inicio()

    }

    //BOTONES VISTA MAPA SOLICITUD PENDIENTE
    @IBAction func SolicitarMapaBtn(_ sender: AnyObject) {
        Inicio()
        SelectOpcion.frame.origin.x = MapaBtn.frame.origin.x - 5
    }
    
    @IBAction func CancelarMapaBtn(_ sender: AnyObject) {
        MostrarMotivoCancelacion()
    }
    
    //BOTONES DEL MENÚ

    @IBAction func MostrarTelefonosCC(_ sender: AnyObject) {
        SelectOpcion.frame.origin.x = CallCEnterBtn.frame.origin.x - 5
        self.TablaCallCenter.frame = CGRect(x: 3, y: 3, width: 200, height: CGFloat(TelefonosCallCenter.count * 44))
        CallCenterView.frame = CGRect(x: 1, y: 105, width: 206, height: CGFloat(TelefonosCallCenter.count * 44 + 10))
        CallCenterView.isHidden = false
        TablaCallCenter.reloadData()
        
        TablaSolPendientes.isHidden = true
        SolPendientesView.isHidden = true
        DetallesCarreraView.isHidden = true
        ExplicacionView.isHidden = true
        SolicitarBtn.isHidden = true
        origenIcono.isHidden = true
        EvaluacionView.isHidden = true
        ComentarioEvalua.isHidden = true
        SolicitudAceptadaView.isHidden = true
        SMSVozBtn.isHidden = true
        EvaluarBtn.isHidden = true
        MensajesBtn.isHidden = true
        LlamarCondBtn.isHidden = true
        AlertaEsperaView.isHidden = true
        self.CancelarSolicitudProceso.isHidden = true
        self.TaximetroView.isHidden = true
    }
    
    @IBAction func MostrarSolPendientes(_ sender: AnyObject) {
        
        SelectOpcion.frame.origin.x = SolPendientesBtn.frame.origin.x - 5
        if solpendientes.count != 0{
        self.TablaSolPendientes.frame = CGRect(x: 65, y: 107, width: 240, height: CGFloat(solpendientes.count * 44))
        SolPendientesView.frame = CGRect(x: 63, y: 105, width: 250, height: CGFloat(solpendientes.count * 44 + 6))
        TablaSolPendientes.isHidden = false
        SolPendientesView.isHidden = false
        }
        else{
           SolPendientesView.isHidden = false
        }
        ExplicacionView.isHidden = true
        SolicitarBtn.isHidden = true
        origenIcono.isHidden = true
        SolicitudAceptadaView.isHidden = true
        SMSVozBtn.isHidden = true
        EvaluarBtn.isHidden = true
        MensajesBtn.isHidden = true
        LlamarCondBtn.isHidden = true
        DetallesCarreraView.isHidden = true
        AlertaEsperaView.isHidden = true
        self.CancelarSolicitudProceso.isHidden = true
        CallCenterView.isHidden = true
        EvaluacionView.isHidden = true
        ComentarioEvalua.isHidden = true
        self.TaximetroView.isHidden = true
        
    }

    @IBAction func TaximetroMenu(_ sender: AnyObject) {
        self.TaximetroView.isHidden = false
        SelectOpcion.frame.origin.x = TaximetroBtn.frame.origin.x - 5
    }
    
    @IBAction func TarifarioMenu(_ sender: AnyObject) {
        Inicio()
        SolicitarBtn.isHidden = true
        SelectOpcion.frame.origin.x = TarifarioBtn.frame.origin.x - 5
    }
    @IBAction func MapaMenu(_ sender: AnyObject) {
       Inicio()
       SelectOpcion.frame.origin.x = MapaBtn.frame.origin.x - 5
    }

   
    
    //BOTONES PARA EVALUCIÓN DE CARRERA
    @IBAction func EvaluarMapaBtn(_ sender: AnyObject) {
        evaluacion = CEvaluacion(botones: [PrimeraStart, SegundaStar,TerceraStar,CuartaStar,QuintaStar])
        SolicitudAceptadaView.isHidden = true
        DetallesCarreraView.isHidden = true
        EvaluacionView.isHidden = false
    }

    @IBAction func Star1(_ sender: AnyObject) {
        evaluacion.EvaluarCarrera(1)
        ComentarioEvalua.isHidden = false
    }
    @IBAction func Star2(_ sender: AnyObject) {
        evaluacion.EvaluarCarrera(2)
        ComentarioEvalua.isHidden = false
    }
    @IBAction func Star3(_ sender: AnyObject) {
        evaluacion.EvaluarCarrera(3)
        EnviarEvaluacion(self.evaluacion.PtoEvaluacion,comentario: "")
    }
    @IBAction func Star4(_ sender: AnyObject) {
        evaluacion.EvaluarCarrera(4)
       EnviarEvaluacion(self.evaluacion.PtoEvaluacion,comentario: "")
    }
    @IBAction func Star5(_ sender: AnyObject) {
        evaluacion.EvaluarCarrera(5)
        EnviarEvaluacion(self.evaluacion.PtoEvaluacion,comentario: "")
    }
    //Enviar comentario
    @IBAction func AceptarEvalucion(_ sender: AnyObject) {
        EnviarEvaluacion(self.evaluacion.PtoEvaluacion,comentario: self.ComentarioText.text)
        self.ComentarioText.endEditing(true)
    }
    
    
  //MENSAJES DE VOZ
   @IBAction func VozMensaje(_ sender: AnyObject) {
    if sender.state == .began{
        let dateFormato = DateFormatter()
        dateFormato.dateFormat = "yyMMddhhmmss"
        self.fechahora = dateFormato.string(from: Date())
        let name = solpendientes[self.indexselect].idSolicitud + "-" + solpendientes[self.indexselect].idTaxi + "-" + fechahora + ".m4a"
        SMSVoz.TerminarMensaje(name)
        self.SMSVozBtn.setImage(UIImage(named:"smsvoz2"), for: UIControlState())
        SMSVoz.ReproducirMusica()
        SMSVoz.SubirAudio(self.UrlSubirVoz, name: name)
        grabando = false
    }

    }
    
    @IBAction func RecordBegin(_ sender: AnyObject) {
        if sender.state == .began{
            SMSVoz.GrabarMensaje()
            SMSVoz.ReproducirMusica()
            grabando = true
        }
    }
    
    //LLAMAR CONDUCTOR
    @IBAction func LLamarConductor(_ sender: AnyObject) {
        if let url = URL(string: "tel://\(solpendientes[indexselect].movil)") {
            UIApplication.shared.openURL(url)
        }
    }
    @IBAction func ReproducirMensajesCond(_ sender: AnyObject) {
        SMSVoz.ReproducirVozConductor(self.urlconductor)
    }
    
    //CONTROL DE TECLADO VIRTUAL
    //Funciones para mover los elementos para que no queden detrás del teclado
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.textColor = UIColor.black
        textField.text = ""
        if textField.isEqual(destinoText){
            animateViewMoving(true, moveValue: 100, view: self.view)
        }
        else{
            if textField.isEqual(referenciaText){
                animateViewMoving(true, moveValue: 80, view: self.view)
            }
            else{
                if textField.isEqual(RepiteClaveNueva){
                        textField.tintColor = UIColor.black
                        if textField.isEqual(RepiteClaveNueva){
                            textField.isSecureTextEntry = true
                            animateViewMoving(true, moveValue: 155, view: self.CambiarclaveView)
                        }else{
                            animateViewMoving(true, moveValue: 155, view: self.view)
                        }
                    }else{
                        if textField.isEqual(ClaveNueva){
                            animateViewMoving(true, moveValue: 80, view: self.CambiarclaveView)
                        }

                        
                    }
            }
        }
    }
    func textFieldDidEndEditing(_ textfield: UITextField) {
        textfield.text = textfield.text!.replacingOccurrences(of: ",", with: ".")
        if textfield.isEqual(destinoText){
            animateViewMoving(false, moveValue: 100, view: self.view)
        }
        else{
            if textfield.isEqual(referenciaText) || textfield.isEqual(ClaveNueva){
                if textfield.isEqual(ClaveNueva){
                    animateViewMoving(false, moveValue: 80, view: self.CambiarclaveView)
                }else{
                    animateViewMoving(false, moveValue: 80, view: self.view)
                }
            }
            else{
                    if textfield.isEqual(RepiteClaveNueva){
                        if RepiteClaveNueva.text != ClaveNueva.text && textfield.isEqual(RepiteClaveNueva){
                            textfield.textColor = UIColor.red
                            textfield.text = "Las Claves Nuevas no coinciden"
                            textfield.isSecureTextEntry = false
                        }else{
                            CambiarClave.isEnabled = true
                        }
                        if textfield.isEqual(RepiteClaveNueva){
                            animateViewMoving(false, moveValue: 155, view: self.CambiarclaveView)
                        }else{
                            animateViewMoving(false, moveValue: 155, view: self.view)
                        }
                }
            }
        }
    }
    
    /*func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.isEqual(ComentarioText){
            animateViewMoving(false, moveValue: 50, view: self.ComentarioEvalua)
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.isEqual(ComentarioText){
            animateViewMoving(false, moveValue: 50,view: self.ComentarioEvalua)
        }
    }
    */
    func animateViewMoving (_ up:Bool, moveValue :CGFloat, view : UIView){
        let movementDuration:TimeInterval = 0.3
        let movement:CGFloat = ( up ? -moveValue : moveValue)
        UIView.beginAnimations( "animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration)
        view.frame = view.frame.offsetBy(dx: 0,  dy: movement)
        UIView.commitAnimations()
    }

    
    //FUNCIONES PARA LA TABLEVIEW
    
    func numberOfSectionsInTableView(_ tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
       if tableView.isEqual(TablaSolPendientes){
        return solpendientes.count
        }
       else{
            return TelefonosCallCenter.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        if tableView.isEqual(TablaSolPendientes){
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        // Configure the cell...
        cell.textLabel!.text = solpendientes[indexPath.row].fechaHora
            return cell
        }
        else{
            /* #Telefonos,cantidad,numerotelefono1,operadora1,siesmovil1,sitienewassap1,numerotelefono2,operadora2.......,#
            
            siesmovil  - 1 cuando es movil   0 cuando es fijo.
            sitienewasap  - 1 si tiene wasap  0 no tiene wasap.
            
            las operadoras vienen en mayúscula.   CLARO    MOVISTAR     CNT*/
            
                let callcenter = tableView.dequeueReusableCell(withIdentifier: "CALLCENTER", for: indexPath)
                callcenter.textLabel!.text = TelefonosCallCenter[indexPath.row].numero
            switch TelefonosCallCenter[indexPath.row].operadora{
                case "CLARO":
                    callcenter.imageView?.image = UIImage(named: "logo_claro")
                case "MOVISTAR":
                    callcenter.imageView?.image = UIImage(named: "logo_movistar")
                case "CNT":
                    callcenter.imageView?.image = UIImage(named: "logo_cnt")
                default: break
            }
            return callcenter
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath){
            if tableView.isEqual(TablaSolPendientes){
                indexselect = indexPath.row
                let vc = UIStoryboard(name:"Main", bundle:nil).instantiateViewController(withIdentifier: "SolPendientes") as! SolPendController
                vc.SolicitudPendiente = self.solpendientes[indexPath.row]
                self.navigationController?.show(vc, sender: nil)
                tableView.deselectRow(at: indexPath, animated: true)
                tableView.isHidden = true
                SolPendientesView.isHidden = true
            }
            else{
                if tableView.isEqual(TablaCallCenter) || tableView.isEqual(TablaSinInternet){
                    if let url = URL(string: "tel://\(TelefonosCallCenter[indexPath.row].numero)") {
                        UIApplication.shared.openURL(url)
                    }
                    TablaCallCenter.reloadData()
                }
                
            }
    }
    
    //GUARDAR LOS DATOS CON COREDATA
    
    func GuardarTelefonos(_ telefonos: [String]) {
        // create an instance of our managedObjectContext
        let moc = DataController().managedObjectContext
        
        //let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        //let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Telefonos")
        fetchRequest.returnsObjectsAsFaults = false
        
        do
        {
            let results = try moc.fetch(fetchRequest)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                moc.delete(managedObjectData)
            }
        } catch {
            //print("Detele all data in \(Telefonos) error : \(error) \(error.userInfo)")
        }
        
        //moc.delete(data)
        var i = 2
        while i <= telefonos.count - 4{
            let entity = NSEntityDescription.insertNewObject(forEntityName: "Telefonos", into: moc) as! Telefonos
            // add our data
            entity.setValue(telefonos[i], forKey: "numerotelefono")
            entity.setValue(telefonos[i + 1], forKey: "operadoratelefono")
            
            // we save our entity
            do {
                try moc.save()
            } catch {
                fatalError("Failure to save context: \(error)")
            }
            i += 4
        }
    }
    
    func CargarTelefonos() {
        let moc = DataController().managedObjectContext
        let telfonosobjeto = NSFetchRequest<NSFetchRequestResult>(entityName: "Telefonos")
        do {
            let telefonocargados = try moc.fetch(telfonosobjeto) as! [Telefonos]
            self.TelefonosCallCenter = [CTelefono]()
            var i = 0
            if telefonocargados.count == 0{
                self.TablaSinInternet.isHidden = true
                self.SinConexionText.text = "No se ha podido Conectar al servidor. Inténtelo más tarde."
            }else{
            while i < telefonocargados.count{
            let telefono = CTelefono(numero: telefonocargados[i].numerotelefono, operadora: telefonocargados[i].operadoratelefono, esmovil: "0", tienewhatsapp: "0")
            self.TelefonosCallCenter.append(telefono)
                i += 1
            }
                self.SinConexionText.text = "No se pudo conectar al servidor. Solicite su taxi llamando al call center, presione uno de los siguientes números:"
            }
        
        } catch {
            fatalError("Failed to fetch person: \(error)")
        }
        
    }
    //FUNCION PARA DETERMINAR SI HAY ALGUNA NUEVA VERSION EN APPSTORE
    
    func appUpdateAvailable() -> Bool
    {
        let storeInfoURL: String = "http://itunes.apple.com/lookup?bundleId=com.xoait.UnTaxi"
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
                                    if appStoreVersion != currentVersion {
                                        upgradeAvailable = true
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
      ///Volumes/Datos/Ecuador/Desarrollo/UnTaxi/UnTaxi/LocationManager.swift:635:31: Ambiguous use of 'indexOfObject'
        return upgradeAvailable
    }
    
    //LOGIN Y REGISTRO DE CLIENTE
   /* @IBAction func Autenticar(_ sender: AnyObject) {
        
        let writeString = "#LoginPassword," + self.Usuario.text! + "," + self.Clave.text! + ",# \n"
        //CREAR EL FICHERO DE LOGÍN
        let filePath = NSHomeDirectory() + "/Library/Caches/log.txt"
        
        do {
            _ = try writeString.write(toFile: filePath, atomically: true, encoding: String.Encoding.utf8)
            
        } catch {
            
        }
        self.Login()
    }*/
        
       
    @IBAction func CambiarClaveBtn(_ sender: AnyObject) {
        ClaveActual.text?.removeAll()
        ClaveNueva.text?.removeAll()
        RepiteClaveNueva.text?.removeAll()
        FondoClaveView.isHidden = false
    }
    @IBAction func EnviarCambioClave(_ sender: AnyObject) {
       // #Cambiarclave,idusuario,claveold,clavenew
        let datos = "#Cambiarclave," + self.idusuario + "," + ClaveActual.text! + "," + ClaveNueva.text! + ",# \n"
        EnviarSocket(datos)
    }
    
    @IBAction func CancelarCambioClave(_ sender: AnyObject) {
        FondoClaveView.isHidden = true
        self.ClaveActual.endEditing(true)
        self.ClaveNueva.endEditing(true)
        self.RepiteClaveNueva.endEditing(true)

    }
    
    @IBAction func SinInternetBtn(_ sender: AnyObject) {
        exit(0)
    }
    //TAXIMETRO
    @IBAction func IniciarTaximetro(_ sender: AnyObject) {

        myvariables.taximetroActive = true
        self.StopTaxBtn.isHidden = false
        self.StarTaxBtn.isHidden = true
        self.coreLocationManager.startUpdatingLocation()
        self.taximetro = CTaximetro(tarifas: tarifas, posicionInicio: self.miposicion)
        self.ArranqueText.text = "$ " + String(format: "%.2f", taximetro.ValorArranque)
        self.MinimaText.text = "$ " + String(format: "%.2f", taximetro.ValorMinimo)
        self.ApagarText.text = self.ArranqueText.text
        self.TaximetroDistanciaText.text = String(format: "%.3f km", self.taximetro.Distancia)
        self.TaximetroTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(PantallaInicio.ActualizarTiempoEspera), userInfo: nil, repeats: true)
        self.TaximetroTotalTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(PantallaInicio.ActualizarTiempoTotal), userInfo: nil, repeats: true)

    }
    @IBAction func DetenerTaximetro(_ sender: AnyObject) {
        /*let longesture = UILongPressGestureRecognizer(target: self, action: "StopTaximetroFunction")
        StopTaxBtn.addGestureRecognizer(longesture)*/
    }
    
    //DETENER TAXIMETRO
    func StopTaximetroFunction(){
        self.TaximetroTimer.invalidate()
        self.TaximetroTotalTimer.invalidate()
        myvariables.taximetroActive = false
        self.StopTaxBtn.isHidden = true
        self.StarTaxBtn.isHidden = false
        self.AlertaTaximetroView.isHidden = true
        
    }
    func ActualizarTiempoEspera(){

        var speed: CLLocationSpeed = CLLocationSpeed()
        speed = coreLocationManager.location!.speed
        if speed < 4{
            let temp = taximetro.ActualizaTiempoEspera()
            self.TimeEsperaText.text = String(format: "%02d", temp[2]) + ":" + String(format: "%02d", temp[1]) + ":" + String(format: "%02d", temp[0])
            if temp[0] % 10 == 0{
                self.taximetro.ValorPagar += self.taximetro.ValorEspera / 6
                
            }
        }
        self.ApagarText.text = "$ " + String(format:"%.2f", self.taximetro.ValorPagar)
        
    }
    func ActualizarTiempoTotal(){
        let tiempocarrera = taximetro.ActualizaTiempoTotal()
        self.TaximetroSpeedText.text = String(format: "%02d", tiempocarrera[2]) + ":" + String(format: "%02d", tiempocarrera[1]) + ":" + String(format: "%02d", tiempocarrera[0])
    }

}
