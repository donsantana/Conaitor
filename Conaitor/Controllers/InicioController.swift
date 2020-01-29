//
//  InicioController.swift
//  UnTaxi
//
//  Created by Done Santana on 2/3/17.
//  Copyright © 2017 Done Santana. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import SocketIO
import Canvas
import AddressBook
import AVFoundation
import CoreData
import GoogleMobileAds

struct MenuData {
  var imagen: String
  var title: String
}

class InicioController: BaseController, CLLocationManagerDelegate, URLSessionDelegate, URLSessionTaskDelegate, URLSessionDataDelegate, UIApplicationDelegate, UIGestureRecognizerDelegate {
  var coreLocationManager : CLLocationManager!
  var miposicion = MKPointAnnotation()
  var origenAnotacion = MKPointAnnotation()
  var taxiLocation = MKPointAnnotation()
  var taxi : CTaxi!
  var login = [String]()
  var idusuario : String = ""
  var contador = 0
  var centro = CLLocationCoordinate2D()
  var opcionAnterior : IndexPath!
  var evaluacion: CEvaluacion!
  var transporteIndex: Int! = -1
  var tipoTransporte: String!
  
  var origenCell = Bundle.main.loadNibNamed("OrigenCell", owner: self, options: nil)?.first as! OrigenViewCell
  var ofertaDataCell = Bundle.main.loadNibNamed("OfertaDataCell", owner: self, options: nil)?.first as! OfertaDataViewCell
  var voucherCell = Bundle.main.loadNibNamed("VoucherCell", owner: self, options: nil)?.first as! VoucherViewCell
  var contactoCell = Bundle.main.loadNibNamed("ContactoCell", owner: self, options: nil)?.first as! ContactoViewCell
  
  var formularioDataCellList: [UITableViewCell] = []
  //var SMSVoz = CSMSVoz()
  
  //Reconect Timer
  var timer = Timer()
  //var fechahora: String!
  
  //Timer de Envio
  var EnviosCount = 0
  var emitTimer = Timer()
  
  var keyboardHeight:CGFloat!
  
  var DireccionesArray = [[String]]()//[["Dir 1", "Ref1"],["Dir2","Ref2"],["Dir3", "Ref3"],["Dir4","Ref4"],["Dir 5", "Ref5"]]//["Dir 1", "Dir2"]
  
  //Menu variables
  var MenuArray = [MenuData(imagen: "solicitud", title: "Solicitudes en proceso"), MenuData(imagen: "callCenter", title: "Operadora"),MenuData(imagen: "clave", title: "Perfil"),MenuData(imagen: "compartir", title: "Compartir app"), MenuData(imagen: "sesion", title: "Cerrar Sesion")]
  
  //variables de interfaz
  var TelefonoContactoText: UITextField!
  
  //CONSTRAINTS
  var btnViewTop: NSLayoutConstraint!
  
  @IBOutlet weak var origenIcono: UIImageView!
  @IBOutlet weak var mapaVista: MKMapView!
  @IBOutlet weak var headerView: UIView!
  
  @IBOutlet weak var transportIcon: UIImageView!
  
  @IBOutlet weak var LocationBtn: UIButton!
  @IBOutlet weak var SolicitarBtn: UIButton!
  @IBOutlet weak var formularioSolicitud: UIView!
  @IBOutlet weak var SolicitudView: UIView!
  
  
  //MENU BUTTONS
  @IBOutlet weak var MenuView1: UIView!
  @IBOutlet weak var MenuTable: UITableView!
  @IBOutlet weak var NombreUsuario: UILabel!
  @IBOutlet weak var TransparenciaView: UIVisualEffectView!
  
  @IBOutlet weak var SolPendientesView: UIView!
  
  @IBOutlet weak var AlertaEsperaView: UIView!
  @IBOutlet weak var MensajeEspera: UITextView!
  @IBOutlet weak var updateOfertaView: UIView!
  @IBOutlet weak var SendOferta: UIButton!
  @IBOutlet weak var newOfertaText: UILabel!
  @IBOutlet weak var up25: UIButton!
  @IBOutlet weak var down25: UIButton!
  @IBOutlet weak var solicitudInProcess: UILabel!
  
  @IBOutlet weak var CancelarSolicitudProceso: UIButton!
  
  @IBOutlet weak var solicitudFormTable: UITableView!
  
  @IBOutlet weak var tipoSolicitudSwitch: UISegmentedControl!
  
  override func viewDidLoad() {
    super.hideMenuBtn = false
    super.barTitle = Customization.nameShowed
    super.topMenu.bringSubviewToFront(self.formularioSolicitud)
    super.viewDidLoad()
    //LECTURA DEL FICHERO PARA AUTENTICACION
    
    mapaVista.delegate = self
    coreLocationManager = CLLocationManager()
    coreLocationManager.delegate = self
    //    self.origenCell.referenciaText.delegate = self
    self.contactoCell.contactoNameText.delegate = self
    self.contactoCell.telefonoText.delegate = self
    //    self.origenCell.origenText.delegate = self
    //    self.origenCell.destinoText.delegate = self
    //    self.solicitudFormTable.delegate = self
    self.ofertaDataCell.detallesText.delegate = self
    
    self.navigationItem.title = Customization.nameShowed
    //solicitud de autorización para acceder a la localización del usuario
    self.NombreUsuario.text = GlobalVariables.cliente.nombreApellidos
    self.NombreUsuario.textColor = Customization.textColor

    self.MenuTable.delegate = self
    self.MenuView1.layer.borderColor = UIColor.lightGray.cgColor
    self.MenuView1.layer.borderWidth = 0.3
    self.MenuView1.layer.masksToBounds = false
    self.updateOfertaView.addShadow()
    self.AlertaEsperaView.addShadow()
    self.MensajeEspera.centerVertically()
    //    self.contactoCell.contactoNameText.setBottomBorder(borderColor: UIColor.lightGray)
    //    self.TelefonoContactoText.setBottomBorder(borderColor: UIColor.lightGray)
    
    self.SolicitudView.addShadow()
    
    self.MenuView1.backgroundColor = Customization.primaryColor
    //self.SolPendientesView.backgroundColor = Customization.primaryColor
    
    coreLocationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
    coreLocationManager.startUpdatingLocation()  //Iniciar servicios de actualiación de localización del usuario
    
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
    
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ocultarTeclado))
    tapGesture.delegate = self
    self.SolicitudView.addGestureRecognizer(tapGesture)
    
    let MenuTapGesture = UITapGestureRecognizer(target: self, action: #selector(ocultarMenu))
    self.TransparenciaView.addGestureRecognizer(MenuTapGesture)
    
    self.transportIcon.image = UIImage(named: "logo")
    
    //INITIALIZING INTERFACES VARIABLES
    self.TelefonoContactoText = self.contactoCell.telefonoText
    
    if let tempLocation = self.coreLocationManager.location?.coordinate{
      self.origenAnotacion.coordinate = (coreLocationManager.location?.coordinate)!
      self.origenAnotacion.title = "origen"
    }else{
      coreLocationManager.requestWhenInUseAuthorization()
      self.origenAnotacion.coordinate = (CLLocationCoordinate2D(latitude: -2.173714, longitude: -79.921601))
    }
    
    let span = MKCoordinateSpan.init(latitudeDelta: 0.005, longitudeDelta: 0.005)
    let region = MKCoordinateRegion(center: self.origenAnotacion.coordinate, span: span)
    self.mapaVista.setRegion(region, animated: true)
    
    self.origenCell.origenText.addTarget(self, action: #selector(textViewDidChange(_:)), for: .editingChanged)
    
    
    self.addEnvirSolictudBtn()
    
    GlobalVariables.socket.on("disconnect"){data, ack in
      self.timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.Reconect), userInfo: nil, repeats: true)
    }
    
    //PEDIR PERMISO PARA MICROPHONE
    switch AVAudioSession.sharedInstance().recordPermission {
    case AVAudioSession.RecordPermission.granted:
      print("Permission granted")
    case AVAudioSession.RecordPermission.denied:
      print("Pemission denied")
      let locationAlert = UIAlertController (title: "Error de Micrófono", message: "Estimado cliente es necesario que active el micrófono de su dispositivo.", preferredStyle: .alert)
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
    case AVAudioSession.RecordPermission.undetermined:
      AVAudioSession.sharedInstance().requestRecordPermission({(granted: Bool)-> Void in
        if granted {
          
        } else{
          
        }
      })
    default:
      break
    }
    
    GlobalVariables.socket.on("connect"){data, ack in
      let ColaHilos = OperationQueue()
      let Hilos : BlockOperation = BlockOperation ( block: {
        self.socketEventos()
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
    //self.tipoSolicitudSwitch.selectedSegmentIndex = 0
    self.socketEventos()
    self.loadFormularioData()
  }
  
  override func viewDidAppear(_ animated: Bool){
    self.contactoCell.contactoNameText.setBottomBorder(borderColor: UIColor.black)
    self.contactoCell.telefonoText.setBottomBorder(borderColor: UIColor.black)
    //self.btnViewTop = NSLayoutConstraint(item: self.BtnsView, attribute: .top, relatedBy: .equal, toItem: self.origenCell.origenText, attribute: .bottom, multiplier: 1, constant: 0)
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    self.miposicion.coordinate = (locations.last?.coordinate)!
    self.SolicitarBtn.isHidden = false
  }
  
  //MARK:- FUNCIONES PROPIAS
  
  func appUpdateAvailable() -> Bool
  {
    let storeInfoURL: String = GlobalConstants.storeInfoURL
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
    ///Volumes/Datos/Ecuador/Desarrollo/UnTaxi/UnTaxi/LocationManager.swift:635:31: Ambiguous use of 'indexOfObject'
    return upgradeAvailable
  }
  
  
  
  //RECONECT SOCKET
  @objc func Reconect(){
    if contador <= 5 {
      GlobalVariables.socket.connect()
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
  
  func sendPosicion(){
    //TRAMA OUT: #Posicion,idCliente,latorig,lngorig
    self.DireccionDeCoordenada(mapaVista.centerCoordinate, directionText: self.origenCell.origenText)
    super.topMenu.isHidden = true
    self.addEnvirSolictudBtn()
    self.origenAnotacion.coordinate = self.miposicion.coordinate
    
    let datos = "#Posicion,\(GlobalVariables.cliente.idCliente!),\(self.origenAnotacion.coordinate.latitude),\(self.origenAnotacion.coordinate.longitude),# \n"
    self.EnviarTimer(estado: 1, datos: datos)
  }
  
  func loadFormularioData(){
    self.formularioDataCellList.removeAll()
    self.formularioDataCellList.append(self.origenCell)
    if self.tipoSolicitudSwitch.selectedSegmentIndex == 0{
      self.ofertaDataCell.initContent()
      self.formularioDataCellList.append(self.ofertaDataCell)
    }else{
      if GlobalVariables.cliente.empresa != "null"{
        self.formularioDataCellList.append(self.voucherCell)
        self.tipoSolicitudSwitch.isHidden = false
      }
    }
    self.formularioDataCellList.append(self.contactoCell)
    self.solicitudFormTable.reloadData()
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
  @objc func EnviarSocket(_ datos: String){
    if CConexionInternet.isConnectedToNetwork() == true{
      if GlobalVariables.socket.status.active && self.EnviosCount <= 3{
        GlobalVariables.socket.emit("data",datos)
        print(datos)
        //self.EnviarTimer(estado: 1, datos: datos)
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
      if GlobalVariables.socket.status.active && self.EnviosCount <= 3 {
        self.EnviosCount += 1
        let userInfo = timer.userInfo as! Dictionary<String, AnyObject>
        var datos = (userInfo["datos"] as! String)
        GlobalVariables.socket.emit("data",datos)
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
  
  func Inicio(){
    mapaVista.removeAnnotations(self.mapaVista.annotations)
    self.view.endEditing(true)
    self.coreLocationManager.startUpdatingLocation()
    self.origenAnotacion.coordinate = (self.coreLocationManager.location?.coordinate)!
    self.origenIcono.image = UIImage(named: "origen")
    self.origenIcono.isHidden = true
    self.origenAnotacion.title = "origen"
    let span = MKCoordinateSpan.init(latitudeDelta: 0.005, longitudeDelta: 0.005)
    let region = MKCoordinateRegion(center: self.origenAnotacion.coordinate, span: span)
    self.mapaVista.setRegion(region, animated: true)
    self.mapaVista.addAnnotation(self.origenAnotacion)
    
    self.formularioSolicitud.isHidden = true
    self.SolicitarBtn.isHidden = false
    SolPendientesView.isHidden = true
    CancelarSolicitudProceso.isHidden = true
    AlertaEsperaView.isHidden = true
    super.topMenu.isHidden = false
    self.viewDidLoad()
  }
  
  //DIRECCIONES FAVORITAS
  func CargarFavoritas(){
    let path = NSHomeDirectory() + "/Library/Caches/"
    let url = NSURL(fileURLWithPath: path)
    let filePath = url.appendingPathComponent("dir.plist")?.path
    let fileManager = FileManager.default
    if fileManager.fileExists(atPath: filePath!) {
      let filePath = NSURL(fileURLWithPath: NSHomeDirectory() + "/Library/Caches/dir.plist") as URL
      do {
        self.DireccionesArray = NSArray(contentsOf: filePath) as! [[String]]
      }catch{
        
      }
    }
  }
  
  func GuardarFavorita(newFavorita: [String]){
    self.DireccionesArray.append(newFavorita)
    //CREAR EL FICHERO DE LOGÍN
    let filePath = NSURL(fileURLWithPath: NSHomeDirectory() + "/Library/Caches/dir.plist")
    
    do {
      _ = try (self.DireccionesArray as NSArray).write(to: filePath as URL, atomically: true)
      
    } catch {
      
    }
  }
  
  func EliminarFavorita(posFavorita: Int){
    self.DireccionesArray.remove(at: posFavorita)
    //CREAR EL FICHERO DE LOGÍN
    let filePath = NSURL(fileURLWithPath: NSHomeDirectory() + "/Library/Caches/dir.plist")
    
    do {
      _ = try (self.DireccionesArray as NSArray).write(to: filePath as URL, atomically: true)
    } catch {
      
    }
  }
  
  //  func getCoordinatesFromAddress(address: String)->CLLocationCoordinate2D {
  //    var resultCoordinates = CLLocationCoordinate2D()
  //    let geocoder = CLGeocoder()
  //    geocoder.geocodeAddressString(address, completionHandler: {(placemarks, error) -> Void in
  //      if((error) != nil){
  //        print("Error", error ?? "")
  //      }
  //      if let placemark = placemarks?.first {
  //        resultCoordinates = placemark.location!.coordinate
  //        print("Lat: \(resultCoordinates.latitude) -- Long: \(resultCoordinates.longitude)")
  //      }
  //    })
  //    return resultCoordinates
  //  }
  
  
  //FUNCION PARA LISTAR SOLICITUDES PENDIENTES
  func ListSolicitudPendiente(_ listado : [String]){
    /*#LoginPassword, loginok, idusuario, email, idcliente, nombreapellidos, foto, empresa, cantidadSolicitudes
    
     idsolicitud, idtaxi, cadenafecha, lattaxi, lngtaxi, latorigen, lngorigen, latdestino, lngdestino, dirorigen, dirdestino, cadfecha, importe, voucher, detalleoferta, tiempotaxiorigen */
    GlobalVariables.solpendientes.removeAll()
    var lattaxi = String()
    var longtaxi = String()
    var i = 9
    
    while i <= listado.count-16 {
      let solicitudpdte = Solicitud()
      if listado[i+4] == "null"{
        lattaxi = "0"
        longtaxi = "0"
      }else{
        lattaxi = listado[i + 3]
        longtaxi = listado[i + 4]
      }
      solicitudpdte.DatosCliente(cliente: GlobalVariables.cliente)
      solicitudpdte.DatosSolicitud(idSolicitud: listado[i], fechaHora: listado[i+2], dirOrigen: listado[i+9], referenciaOrigen: "", dirDestino: listado[i + 6], latOrigen: Double(listado[i + 5])!, lngOrigen: Double(listado[i + 6])!, latDestino: Double(listado[i + 7])!, lngDestino: Double(listado[i+8])!, valorOferta: listado[i+12], detallesOferta: listado[i+14],fechaReserva: listado[i + 11])
      if listado[i + 1] != "null"{
        solicitudpdte.DatosTaxiConductor(idtaxi: listado[i + 1], matricula: "", codigovehiculo: "", marcaVehiculo: "", colorVehiculo: "", lattaxi: Double(lattaxi)!, lngtaxi: Double(longtaxi)!, idconductor: "", nombreapellidosconductor: "", movilconductor: "", foto: "")
      }
      GlobalVariables.solpendientes.append(solicitudpdte)
      if solicitudpdte.idTaxi != ""{
        GlobalVariables.solicitudesproceso = true
      }
      i += 16
    }
  }
  
  //Funcion para Mostrar Datos del Taxi seleccionado
  //  func AgregarTaxiSolicitud(_ temporal : [String]){
  //    //#Aceptada, idsolicitud, idconductor, nombreApellidosConductor, movilConductor, URLfoto, idTaxi, Codvehiculo, matricula, marca_modelo, color, latTaxi, lngTaxi
  //    for solicitud in GlobalVariables.solpendientes{
  //      if solicitud.id == temporal[1]{
  //        GlobalVariables.solicitudesproceso = true
  //        solicitud.DatosTaxiConductor(idtaxi: temporal[6], matricula: temporal[8], codigovehiculo: temporal[7], marcaVehiculo: temporal[9],colorVehiculo: temporal[10], lattaxi: temporal[11], lngtaxi: temporal[12], idconductor: temporal[2], nombreapellidosconductor: temporal[3], movilconductor: temporal[4], foto: temporal[5])
  //      }
  //    }
  //  }
  
  
  //FUNCIÓN BUSCA UNA SOLICITUD DENTRO DEL ARRAY DE SOLICITUDES PENDIENTES DADO SU ID
  func BuscarSolicitudID(_ id : String)->Solicitud{
    return GlobalVariables.solpendientes.filter{$0.id == id}.first!
  }
  
  //devolver posicion de solicitud
  func BuscarPosSolicitudID(_ id : String)->Int{
    var temporal = 0
    var posicion = -1
    for solicitudpdt in GlobalVariables.solpendientes{
      if solicitudpdt.id == id{
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
      GlobalVariables.solpendientes.last!.RegistrarFechaHora(IdSolicitud: Temporal[2], FechaHora: Temporal[3])
      print(GlobalVariables.solpendientes.last!.fechaHora)
    }else{
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
  
  //CREAR SOLICITUD CON LOS DATOS DEL CIENTE, SU LOCALIZACIÓN DE ORIGEN Y DESTINO
  //  func crearTramaSolicitud(_ nuevaSolicitud: SolicitudOferta, voucher: String){
  //    //#SO,idcliente,nombreapellidos,movil,dirorigen,referencia,dirdestino,latorigen,lngorigen,ladestino,lngdestino,distanciaorigendestino,valor oferta,voucher,detalle oferta,fecha reserva,tipo transporte,#
  //    formularioSolicitud.isHidden = true
  //    origenIcono.isHidden = true
  //    GlobalVariables.solpendientes.append(nuevaSolicitud)
  //
  ////    let datoscliente = "\(nuevaSolicitud.idCliente), \(nuevaSolicitud.nombreApellidos), \(nuevaSolicitud.user)"
  ////    let datossolicitud = "\(nuevaSolicitud.dirOrigen), \(nuevaSolicitud.referenciaorigen), \(nuevaSolicitud.dirDestino), \(nuevaSolicitud.origenCoord.latitude), \(nuevaSolicitud.origenCoord.longitude), \(nuevaSolicitud.destinoCoord.latitude), \(nuevaSolicitud.destinoCoord.longitude)"
  ////    let datosgeo = "\(nuevaSolicitud.distancia), \(nuevaSolicitud.valorOferta), , \(nuevaSolicitud.fechaReserva), \(nuevaSolicitud.tipoTransporte)"
  //    let datos = "#SO,\(nuevaSolicitud.idCliente),\(nuevaSolicitud.nombreApellidos),\(nuevaSolicitud.user),\(nuevaSolicitud.dirOrigen),\(nuevaSolicitud.referenciaorigen),\(nuevaSolicitud.dirDestino),\(nuevaSolicitud.origenCarrera.latitude),\(nuevaSolicitud.origenCarrera.longitude),\(nuevaSolicitud.destinoCoord.latitude),\(nuevaSolicitud.destinoCoord.longitude),\(nuevaSolicitud.distancia),\(nuevaSolicitud.valorOferta),\(voucher),\(nuevaSolicitud.detallesOferta),\(nuevaSolicitud.getFechaISO()),1,# \n"
  //    self.EnviarTimer(estado: 1, datos: datos)
  //    MensajeEspera.text = "Procesando..."
  //    self.AlertaEsperaView.isHidden = false
  //    self.origenCell.origenText.text?.removeAll()
  //    self.origenCell.referenciaText.text?.removeAll()
  //  }
  
  //CANCELAR SOLICITUDES
  func MostrarMotivoCancelacion(){
    //["No necesito","Demora el servicio","Tarifa incorrecta","Solo probaba el servicio", "Cancelar"]
    let motivoAlerta = UIAlertController(title: "", message: "Seleccione el motivo de cancelación.", preferredStyle: UIAlertController.Style.actionSheet)
    motivoAlerta.addAction(UIAlertAction(title: "No necesito", style: .default, handler: { action in
      
      self.CancelarSolicitudes("No necesito")
      
    }))
    motivoAlerta.addAction(UIAlertAction(title: "Demora el servicio", style: .default, handler: { action in
      
      self.CancelarSolicitudes("Demora el servicio")
      
    }))
    motivoAlerta.addAction(UIAlertAction(title: "Tarifa incorrecta", style: .default, handler: { action in
      
      self.CancelarSolicitudes("Tarifa incorrecta")
      
    }))
    motivoAlerta.addAction(UIAlertAction(title: "Vehículo en mal estado", style: .default, handler: { action in
      
      self.CancelarSolicitudes("Vehículo en mal estado")
      
    }))
    motivoAlerta.addAction(UIAlertAction(title: "Solo probaba el servicio", style: .default, handler: { action in
      
      self.CancelarSolicitudes("Solo probaba el servicio")
      
    }))
    motivoAlerta.addAction(UIAlertAction(title: "Cancelar", style: UIAlertAction.Style.destructive, handler: { action in
    }))
    self.present(motivoAlerta, animated: true, completion: nil)
  }
  
  /*func CancelarSolicitudes(_ motivo: String){
   //#Cancelarsolicitud, idSolicitud, idTaxi, motivo, "# \n"
   let temp = (GlobalVariables.solpendientes.last?.idTaxi)! + "," + motivo + "," + "# \n"
   let Datos = "#Cancelarsolicitud" + "," + (GlobalVariables.solpendientes.last?.idSolicitud)! + "," + temp
   GlobalVariables.solpendientes.removeLast()
   if GlobalVariables.solpendientes.count == 0 {
   self.SolPendImage.isHidden = true
   CantSolPendientes.isHidden = true
   GlobalVariables.solicitudesproceso = false
   }
   if motivo != "Conductor"{
   EnviarSocket(Datos)
   }
   }*/
  
  func CancelarSolicitudes(_ motivo: String){
    //#Cancelarsolicitud, idSolicitud, idTaxi, motivo, "# \n"
    //let temp = (GlobalVariables.solpendientes.last?.idTaxi)! + "," + motivo + "," + "# \n"
    let Datos = GlobalVariables.solpendientes.last?.crearTramaCancelar(motivo: motivo)
    GlobalVariables.solpendientes.removeLast()
    if GlobalVariables.solpendientes.count == 0 {
      GlobalVariables.solicitudesproceso = false
    }
    if motivo != "Conductor"{
      EnviarSocket(Datos!)
    }
  }
  
  func CloseAPP(){
    let fileAudio = FileManager()
    let AudioPath = NSHomeDirectory() + "/Library/Caches/Audio"
    do {
      try fileAudio.removeItem(atPath: AudioPath)
    }catch{
    }
    let datos = "#SocketClose," + GlobalVariables.cliente.idCliente + ",# \n"
    EnviarSocket(datos)
    exit(3)
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
  
  
  //Validar los formularios
  func SoloLetras(name: String) -> Bool {
    // (1):
    let pat = "[0-9,.!@#$%^&*()_+-]"
    // (2):
    //let testStr = "x.wu@strath.ac.uk, ak123@hotmail.com     e1s59@oxford.ac.uk, ee123@cooleng.co.uk, a.khan@surrey.ac.uk"
    // (3):
    let regex = try! NSRegularExpression(pattern: pat, options: [])
    // (4):
    let matches = regex.matches(in: name, options: [], range: NSRange(location: 0, length: name.count))
    print(matches.count)
    if matches.count == 0{
      return true
    }else{
      return false
    }
  }
  
  @objc func ocultarMenu(){
    self.MenuView1.isHidden = true
    self.TransparenciaView.isHidden = true
    self.Inicio()
    super.topMenu.isHidden = false
  }
  
  //ADD FOOTER TO SOLICITDFORMTABLE
  func addEnvirSolictudBtn(){
    let enviarBtnView = UIView(frame: CGRect(x: 0, y: 0, width: self.SolicitudView.frame.width, height: 40))
    let button:UIButton = UIButton.init(frame: CGRect(x: 10, y: 15, width: enviarBtnView.frame.width - 20, height: 40))
    button.backgroundColor = .gray
    button.layer.cornerRadius = 5
    button.setTitleColor(.white, for: .normal)
    button.setTitle("ENVIAR SOLICITUD", for: .normal)
    button.titleLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: 20)
    button.addTarget(self, action: #selector(self.enviarSolicitud), for: .touchUpInside)
    let separatorView = UIView(frame: CGRect(x: 5, y: 0, width: enviarBtnView.frame.width - 10, height: 1))
    separatorView.backgroundColor = .darkGray
    
    enviarBtnView.addSubview(separatorView)
    enviarBtnView.addSubview(button)
    self.solicitudFormTable.tableFooterView = enviarBtnView
  }
  
  func converAddressToCoord(address: String)->CLLocationCoordinate2D{
    var coordinates = self.miposicion.coordinate
    var geocoder = CLGeocoder()
    geocoder.geocodeAddressString(address) {
      placemarks, error in
      let placemark = placemarks?.first
      coordinates = (placemark?.location!.coordinate)!
      let lat = placemark?.location?.coordinate.latitude
      let lon = placemark?.location?.coordinate.longitude
    }
    return coordinates
    
  }
  
  func crearTramaSolicitud(_ nuevaSolicitud: Solicitud, voucher: String){
    //#Solicitud, idcliente, nombrecliente, movilcliente, dirorig, referencia, dirdest,latorig,lngorig, latdest, lngdest, distancia, costo, #
    formularioSolicitud.isHidden = true
    origenIcono.isHidden = true
    GlobalVariables.solpendientes.append(nuevaSolicitud)
    let datos: String = nuevaSolicitud.crearTrama(voucher: voucher)
    print("solicitud \(datos)")
    //    if Customization.usaVoucher{
    //      datos = "#Solicitud,\(nuevaSolicitud.idCliente),\(nuevaSolicitud.nombreApellidos),\(nuevaSolicitud.user),\(nuevaSolicitud.dirOrigen),\(nuevaSolicitud.referenciaorigen),\(nuevaSolicitud.dirDestino),\(String(nuevaSolicitud.origenCarrera.latitude)),\(String(nuevaSolicitud.origenCarrera.longitude)),0.0,0.0,\(String(nuevaSolicitud.distancia)),\(nuevaSolicitud.costo),\(voucher),# \n"
    //    }else{
    //      datos = "#Solicitud,\(nuevaSolicitud.idCliente),\(nuevaSolicitud.nombreApellidos),\(nuevaSolicitud.user),\(nuevaSolicitud.dirOrigen),\(nuevaSolicitud.referenciaorigen),\(nuevaSolicitud.dirDestino),\(String(nuevaSolicitud.origenCarrera.latitude)),\(String(nuevaSolicitud.origenCarrera.longitude)),0.0,0.0,\(String(nuevaSolicitud.distancia)),\(nuevaSolicitud.costo),# \n"
    //    }
    //EnviarSocket(Datos)
    self.EnviarTimer(estado: 1, datos: datos)
    MensajeEspera.text = "Procesando..."
    self.AlertaEsperaView.isHidden = false
    self.origenCell.origenText.text?.removeAll()
    self.origenCell.referenciaText.text?.removeAll()
    self.origenCell.destinoText.text?.removeAll()
    //self.menuTabBar.selectedItem = self.solicitudeBtn
  }
  
//  func crearSolicitud(){
//    if !(self.origenCell.origenText.text?.isEmpty)! && !(self.origenCell.destinoText.text?.isEmpty)!{
//      print("heree")
//      let origen = self.cleanTextField(textfield: self.origenCell.origenText)
//
//      let referencia = !self.origenCell.referenciaText.text!.isEmpty ? self.cleanTextField(textfield: self.origenCell.referenciaText) : "No referencia"
//
//      let destino = self.origenCell.destinoText.text!.isEmpty ? "Sin destino" : self.cleanTextField(textfield: self.origenCell.destinoText)
//
//      let nombreContactar = self.contactoCell.contactoNameText.text!.isEmpty ? GlobalVariables.cliente.nombreApellidos : self.cleanTextField(textfield: self.contactoCell.contactoNameText)
//
//      let telefonoContactar = self.contactoCell.telefonoText.text!.isEmpty ? GlobalVariables.cliente.user : self.cleanTextField(textfield: self.contactoCell.telefonoText)
//
//      let clienteSolicitud = self.contactoCell.contactoNameText.text!.isEmpty ? GlobalVariables.cliente : CCliente(idUsuario: GlobalVariables.cliente.idUsuario, idcliente: GlobalVariables.cliente.idCliente, user: telefonoContactar!, nombre: nombreContactar!, email: GlobalVariables.cliente.email, empresa: GlobalVariables.cliente.empresa)
//
//      mapaVista.removeAnnotations(mapaVista.annotations)
//
//      let nuevaSolicitud = Solicitud()
//
//      nuevaSolicitud.DatosCliente(cliente: clienteSolicitud!)
//
//      nuevaSolicitud.DatosSolicitud(dirorigen: origen, referenciaorigen: referencia, dirdestino: destino,latorigen: String(Double(origenAnotacion.coordinate.latitude)), lngorigen: String(Double(origenAnotacion.coordinate.longitude)), latdestino: "0", lngdestino: "0",FechaHora: "")
//
//      let voucher = self.voucherCell.voucherSwitch.isOn ? "1" : "0"
//
//      self.crearTramaSolicitud(nuevaSolicitud,voucher: voucher)
//      DibujarIconos([self.origenAnotacion])
//      view.endEditing(true)
//    }else{
//      self.origenCell.origenText.becomeFirstResponder()
//    }
//
//  }
  
  func crearSolicitudOferta(){
    //#SO,idcliente,nombreapellidos,movil,dirorigen,referencia,dirdestino,latorigen,lngorigen,ladestino,lngdestino,distanciaorigendestino,valor oferta,voucher,detalle oferta,fecha reserva,tipo transporte,#
    
    if !self.origenCell.origenText.text!.isEmpty && !self.origenCell.destinoText.text!.isEmpty{
      
      let nombreContactar = self.contactoCell.contactoNameText.text!.isEmpty ? GlobalVariables.cliente.nombreApellidos : self.cleanTextField(textfield: self.contactoCell.contactoNameText)
      
      let telefonoContactar = self.contactoCell.telefonoText.text!.isEmpty ? GlobalVariables.cliente.user : self.cleanTextField(textfield: self.contactoCell.telefonoText)
      
      let clienteSolicitud = self.contactoCell.contactoNameText.text!.isEmpty ? GlobalVariables.cliente : CCliente(idUsuario: GlobalVariables.cliente.idUsuario, idcliente: GlobalVariables.cliente.idCliente, user: telefonoContactar!, nombre: nombreContactar!, email: GlobalVariables.cliente.email, empresa: GlobalVariables.cliente.empresa)
      
      let origen = self.cleanTextField(textfield: self.origenCell.origenText)
      
      let origenCoord = self.miposicion.coordinate
      
      let referencia = !self.origenCell.referenciaText.text!.isEmpty ? self.cleanTextField(textfield: self.origenCell.referenciaText) : "No referencia"
      
      
      let destino = self.cleanTextField(textfield: self.origenCell.destinoText)
      
      let destinoCoord = CLLocationCoordinate2D()
      
      let voucher = self.voucherCell.voucherSwitch.isOn ? "1" : "0"
      
      let detalleOferta = !self.ofertaDataCell.detallesText.text!.isEmpty ? self.ofertaDataCell.detallesText.text! : "No detalles"
      
      let fechaReserva = self.origenCell.fechaReserva.text
      
      let valorOferta = self.tipoSolicitudSwitch.selectedSegmentIndex != 0 ? "0" : self.ofertaDataCell.ofertaText.text!
      
      mapaVista.removeAnnotations(mapaVista.annotations)
      
      let nuevaSolicitud = Solicitud()
      nuevaSolicitud.DatosCliente(cliente: clienteSolicitud!)
      nuevaSolicitud.DatosSolicitud(idSolicitud: "test", fechaHora: "Date", dirOrigen: origen, referenciaOrigen: referencia, dirDestino: destino, latOrigen: origenCoord.latitude, lngOrigen: origenCoord.longitude, latDestino: destinoCoord.latitude, lngDestino: destinoCoord.longitude, valorOferta: valorOferta, detallesOferta: detalleOferta, fechaReserva: fechaReserva!)
      
      self.crearTramaSolicitud(nuevaSolicitud,voucher: voucher)
      DibujarIconos([self.origenAnotacion])
      view.endEditing(true)
      
    }else{
      let alertaDos = UIAlertController (title: "Error en el formulario", message: "Por favor debe llegar todos los campos subrayados con una línea roja porque son requeridos.", preferredStyle: UIAlertController.Style.alert)
      alertaDos.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: {alerAction in
        //self.origenCell.destinoText.becomeFirstResponder()
      }))
      self.present(alertaDos, animated: true, completion: nil)
    }
  }
  
  @objc func enviarSolicitud(){
    if self.tipoSolicitudSwitch.selectedSegmentIndex == 0 {
      if !(self.ofertaDataCell.ofertaText.text?.isEmpty)! && self.ofertaDataCell.ofertaText.text != "0"{
        self.crearSolicitudOferta()
      }else{
        let alertaDos = UIAlertController (title: "Error en el formulario", message: "Por favor debe ofertar un valor $ por el servicio.", preferredStyle: UIAlertController.Style.alert)
        alertaDos.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: {alerAction in
          //self.origenCell.destinoText.becomeFirstResponder()
        }))
        self.present(alertaDos, animated: true, completion: nil)
      }
    }else{
      self.crearSolicitudOferta()
    }
  }
  
  func updateOfertaValue(value: Double){
    self.newOfertaText.text = "\((self.newOfertaText.text! as NSString).doubleValue + value)"
  }
  //MARK:- CONTROL DE TECLADO VIRTUAL
  //Funciones para mover los elementos para que no queden detrás del teclado
  
  @objc func keyboardWillShow(notification: NSNotification) {
    if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
      self.keyboardHeight = keyboardSize.height
    }
  }
  
  func textViewDidBeginEditing(_ textView: UITextView) {
    
  }
  
  func textViewDidEndEditing(_ textView: UITextView) {
    animateViewMoving(false, moveValue: 60, view: self.view)
  }
  
  @objc func textViewDidChange(_ textView: UITextView) {
    
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    self.origenCell.referenciaText.resignFirstResponder()
  }
  
  @objc func ocultarTeclado(sender: UITapGestureRecognizer){
    //sender.cancelsTouchesInView = false
    self.SolicitudView.endEditing(true)
  }
  
  //  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
  //    if touch.view?.isDescendant(of: self.TablaDirecciones) == true {
  //      gestureRecognizer.cancelsTouchesInView = false
  //    }else{
  //      self.SolicitudView.endEditing(true)
  //    }
  //    return true
  //  }
  //
  func cleanTextField(textfield: UITextField)->String{
    var cleanedTextField = textfield.text?.uppercased()
    cleanedTextField = cleanedTextField!.replacingOccurrences(of: "Ñ", with: "N",options: .regularExpression, range: nil)
    cleanedTextField = cleanedTextField!.replacingOccurrences(of: "[,.]", with: "-",options: .regularExpression, range: nil)
    cleanedTextField = cleanedTextField!.replacingOccurrences(of: "[\n]", with: "-",options: .regularExpression, range: nil)
    cleanedTextField = cleanedTextField!.replacingOccurrences(of: "[#]", with: "No",options: .regularExpression, range: nil)
    return cleanedTextField!.folding(options: .diacriticInsensitive, locale: .current)
  }
  
  //  func showFormularioSolicitud(){
  //    self.CargarFavoritas()
  //    self.TablaDirecciones.reloadData()
  //    self.origenIcono.isHidden = true
  //    self.origenAnotacion.coordinate = mapaVista.centerCoordinate
  //    coreLocationManager.stopUpdatingLocation()
  //    self.SolicitarBtn.isHidden = true
  //    self.origenCell.origenText.becomeFirstResponder()
  //    if GlobalVariables.cliente.empresa != "null"{
  //      self.VoucherView.isHidden = false
  //      self.VoucherEmpresaName.text = GlobalVariables.cliente.empresa
  //      NSLayoutConstraint(item: self.BtnsView, attribute: .top, relatedBy: .equal, toItem: self.VoucherView, attribute:.bottom, multiplier: 1.0, constant:43.0).isActive = true
  //    }else{
  //      NSLayoutConstraint(item: self.BtnsView, attribute: .top, relatedBy: .equal, toItem: self.ContactoView, attribute:.bottom, multiplier: 1.0, constant:10.0).isActive = true
  //
  //    }
  //    self.formularioSolicitud.isHidden = false
  //  }
  
  //Date picker functions
  //  @objc func dateChange( datePicker: UIDatePicker) {
  //    let dateFormatter = DateFormatter()
  //    dateFormatter.dateFormat = "MM/dd/yyyy HH:mm:ss"
  //    //self.reservaDate.text = dateFormatter.string(from: datePicker.date)
  //  }
  //
  @objc func dismissPicker() {
    view.endEditing(true)
  }
  
  override func homeBtnAction(){
    self.MenuView1.isHidden = !self.MenuView1.isHidden
    self.MenuView1.startCanvasAnimation()
    self.TransparenciaView.isHidden = self.MenuView1.isHidden
    self.TransparenciaView.startCanvasAnimation()
    super.topMenu.isHidden = true
  }
  
  //FUNCION DETERMINAR DIRECCIÓN A PARTIR DE COORDENADAS
  func DireccionDeCoordenada(_ coordenada : CLLocationCoordinate2D, directionText : UITextField){
    let geocoder = CLGeocoder()
    var address = ""
    if CConexionInternet.isConnectedToNetwork() == true {
      let temporaLocation = CLLocation(latitude: coordenada.latitude, longitude: coordenada.longitude)
      CLGeocoder().reverseGeocodeLocation(temporaLocation, completionHandler: {(placemarks, error) -> Void in
        if error != nil {
          print("Reverse geocoder failed with error" + (error?.localizedDescription)!)
          return
        }
        
        if (placemarks?.count)! > 0 {
          let placemark = (placemarks?.first)! as CLPlacemark
          
          if let name = placemark.addressDictionary?["Name"] as? String {
            address += name
          }
          
          //            if let locality = placemark.addressDictionary?["City"] as? String {
          //              address += " \(locality)"
          //            }
          //
          //          if let state = placemark.addressDictionary?["State"] as? String {
          //            address += " \(state)"
          //          }
          //
          //          if let country = placemark.country{
          //            address += " \(country)"
          //          }
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
  
  //MARK:- BOTONES GRAFICOS ACCIONES
  @IBAction func MostrarMenu(_ sender: Any) {
    //    self.MenuView1.isHidden = !self.MenuView1.isHidden
    //    self.MenuView1.startCanvasAnimation()
    //    self.TransparenciaView.isHidden = self.MenuView1.isHidden
    //    //self.Inicio()
    //    self.TransparenciaView.startCanvasAnimation()
  }
  
  @IBAction func SalirApp(_ sender: Any) {
    //    let fileAudio = FileManager()
    //    let AudioPath = NSHomeDirectory() + "/Library/Caches/Audio"
    //    do {
    //      try fileAudio.removeItem(atPath: AudioPath)
    //    }catch{
    //    }
    //    let datos = "#SocketClose," + GlobalVariables.cliente.idCliente + ",# \n"
    //    EnviarSocket(datos)
    //    exit(3)
  }
  
  @IBAction func RelocateBtn(_ sender: Any) {
    let span = MKCoordinateSpan.init(latitudeDelta: 0.005, longitudeDelta: 0.005)
    let region = MKCoordinateRegion(center: self.origenAnotacion.coordinate, span: span)
    self.mapaVista.setRegion(region, animated: true)
    
  }
  //SOLICITAR BUTTON
  @IBAction func Solicitar(_ sender: AnyObject) {
    //TRAMA OUT: #Posicion,idCliente,latorig,lngorig
    self.DireccionDeCoordenada(mapaVista.centerCoordinate, directionText: self.origenCell.origenText)
    super.topMenu.isHidden = true
    self.addEnvirSolictudBtn()
    self.origenAnotacion.coordinate = self.miposicion.coordinate
    
    let datos = "#Posicion,\(GlobalVariables.cliente.idCliente!),\(self.origenAnotacion.coordinate.latitude),\(self.origenAnotacion.coordinate.longitude),# \n"
    self.EnviarTimer(estado: 1, datos: datos)
  }
  
  //Voucher check
  @IBAction func SwicthVoucher(_ sender: Any) {
    if self.voucherCell.voucherSwitch.isOn{
      self.origenCell.destinoText.isHidden = false
      self.origenCell.destinoText.becomeFirstResponder()
    }else{
      self.origenCell.destinoText.isHidden = true
      self.origenCell.destinoText.resignFirstResponder()
    }
  }
  
  //Boton para Cancelar Carrera
  @IBAction func CancelarSol(_ sender: UIButton) {
    self.formularioSolicitud.isHidden = true
    self.origenCell.referenciaText.endEditing(true)
    self.Inicio()
    self.origenCell.origenText.text?.removeAll()
    //    self.RecordarView.isHidden = true
    //    self.RecordarSwitch.isOn = false
    self.origenCell.referenciaText.text?.removeAll()
    self.SolicitarBtn.isHidden = false
  }
  
  // CANCELAR LA SOL MIENTRAS SE ESPERA LA FONFIRMACI'ON DEL TAXI
  @IBAction func CancelarProcesoSolicitud(_ sender: AnyObject) {
    MostrarMotivoCancelacion()
  }
  
  //  @IBAction func MostrarTelefonosCC(_ sender: AnyObject) {
  //    self.SolPendientesView.isHidden = true
  //    DispatchQueue.main.async {
  //      let vc = UIStoryboard(name:"Main", bundle:nil).instantiateViewController(withIdentifier: "CallCenter") as! CallCenterController
  //      vc.telefonosCallCenter = GlobalVariables.TelefonosCallCenter
  //      self.navigationController?.show(vc, sender: nil)
  //    }
  //  }
  //
  //  @IBAction func MostrarSolPendientes(_ sender: AnyObject) {
  //    if GlobalVariables.solpendientes.count > 0{
  //      DispatchQueue.main.async {
  //        let vc = UIStoryboard(name:"Main", bundle:nil).instantiateViewController(withIdentifier: "ListaSolPdtes") as! SolicitudesTableController
  //        vc.solicitudesMostrar = GlobalVariables.solpendientes
  //        self.navigationController?.show(vc, sender: nil)
  //      }
  //    }else{
  //      self.SolPendientesView.isHidden = !self.SolPendientesView.isHidden
  //    }
  //  }
  //
  //  @IBAction func MapaMenu(_ sender: AnyObject) {
  //    Inicio()
  //  }
  
  @IBAction func closeSolicitudForm(_ sender: Any) {
    Inicio()
  }
  
  @IBAction func downOferta(_ sender: Any) {
    self.updateOfertaValue(value: -0.25)
    self.down25.isEnabled = ((self.newOfertaText!.text! as NSString).doubleValue > (self.ofertaDataCell.ofertaText.text! as NSString).doubleValue)
  }
  
  @IBAction func upOferta(_ sender: Any) {
    self.down25.isEnabled = true
    self.updateOfertaValue(value: +0.25)
  }
  @IBAction func enviarNuevoValorOferta(_ sender: Any) {
    //#RSO.id,idcliente,nuevovaloroferta,#
    let datos = "#RSO,\(self.solicitudInProcess.text!),\(GlobalVariables.cliente.idCliente!),\(self.newOfertaText.text!),# \n"
    print(datos)
    self.EnviarSocket(datos)
  }
  
  @IBAction func tipoSolicitudSwitchChanged(_ sender: Any) {
    self.updateOfertaView.isHidden = self.tipoSolicitudSwitch.selectedSegmentIndex == 1
    self.loadFormularioData()
  }
  
}




