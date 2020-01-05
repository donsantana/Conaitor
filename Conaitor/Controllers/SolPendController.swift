//
//  SolPendController.swift
//  UnTaxi
//
//  Created by Done Santana on 28/2/17.
//  Copyright © 2017 Done Santana. All rights reserved.
//

import UIKit
import MapKit
import SocketIO
import AVFoundation
import GoogleMobileAds

class SolPendController: BaseController, MKMapViewDelegate, UITextViewDelegate,URLSessionDelegate, URLSessionTaskDelegate, URLSessionDataDelegate {
  
  var solicitudPendiente: Solicitud!
  var solicitudIndex: Int!
  var OrigenSolicitud = MKPointAnnotation()
  var TaxiSolicitud = MKPointAnnotation()
  var grabando = false
  var fechahora: String!
  var UrlSubirVoz = GlobalVariables.UrlSubirVoz
  
  
  //MASK:- VARIABLES INTERFAZ
  //@IBOutlet weak var MapaSolPen: GMSMapView!
  @IBOutlet weak var headerView: UIView!
  @IBOutlet weak var MapaSolPen: MKMapView!
  @IBOutlet weak var detallesView: UIView!
  @IBOutlet weak var distanciaText: UILabel!
  @IBOutlet weak var valorOferta: UILabel!
  @IBOutlet weak var direccionOrigen: UILabel!
  @IBOutlet weak var direccionDestino: UILabel!
  @IBOutlet weak var transpIcon: UIImageView!
  
  @IBOutlet weak var ComentarioEvalua: UIView!
  
  
  @IBOutlet weak var MensajesBtn: UIButton!
  @IBOutlet weak var LlamarCondBtn: UIButton!
  @IBOutlet weak var SMSVozBtn: UIButton!
  
  
  @IBOutlet weak var DatosConductor: UIView!
  //datos del conductor a mostrar
  @IBOutlet weak var conductorPreview: UIView!
  @IBOutlet weak var ImagenCond: UIImageView!
  @IBOutlet weak var NombreCond: UILabel!
  @IBOutlet weak var MovilCond: UILabel!
  @IBOutlet weak var MarcaAut: UILabel!
  @IBOutlet weak var ColorAut: UILabel!
  @IBOutlet weak var MatriculaAut: UILabel!
  
  @IBOutlet weak var AlertaEsperaView: UIView!
  @IBOutlet weak var MensajeEspera: UITextView!
  
  @IBOutlet weak var adsBannerView: GADBannerView!

  override func viewDidLoad() {
    super.viewDidLoad()
    self.solicitudPendiente = GlobalVariables.solpendientes[solicitudIndex]
    self.MapaSolPen.delegate = self
    self.OrigenSolicitud.coordinate = self.solicitudPendiente.origenCoord
    self.OrigenSolicitud.title = "origen"
    self.detallesView.addShadow()
    self.conductorPreview.addShadow()
    self.MostrarDetalleSolicitud()
    self.transpIcon.image = UIImage(named: "logo")
    
    self.LlamarCondBtn.addShadow()
    
    self.valorOferta.isHidden = solicitudPendiente.valorOferta == ""
    
    let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(SolPendController.longTap(_:)))
    longGesture.minimumPressDuration = 0.2
    self.SMSVozBtn.addGestureRecognizer(longGesture)
    
    //ADS BANNER VIEW
    self.adsBannerView.adUnitID = ""//"ca-app-pub-1778988557303127/8408614115" //"ca-app-pub-3940256099942544/2934735716"//"ca-app-pub-1778988557303127/8408614115"
    self.adsBannerView.rootViewController = self
    self.adsBannerView.load(GADRequest())
    self.adsBannerView.delegate = self

    if GlobalVariables.urlconductor != ""{
      self.MensajesBtn.isHidden = false
      self.MensajesBtn.setImage(UIImage(named: "mensajesnew"),for: UIControl.State())
    }
    
    //PEDIR PERMISO PARA EL MICROPHONO
    switch AVAudioSession.sharedInstance().recordPermission {
    case AVAudioSession.RecordPermission.granted:
      print("Permission granted")
    case AVAudioSession.RecordPermission.denied:
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
    
    self.socketEventos()
  }
  
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    var anotationView = MapaSolPen.dequeueReusableAnnotationView(withIdentifier: "annotationView")
    anotationView = MKAnnotationView(annotation: self.OrigenSolicitud, reuseIdentifier: "annotationView")
    if annotation.title! == "origen"{
      anotationView?.image = UIImage(named: "origen")
    }else{
      anotationView?.image = UIImage(named: "taxi_libre")
    }
    return anotationView
  }
  
  //Dibujar la ruta
  func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
    let renderer = MKPolylineRenderer(overlay: overlay)
    renderer.strokeColor = UIColor.red
    renderer.lineWidth = 4.0
    
    return renderer
  }
  
  
  
  //MASK:- FUNCIONES PROPIAS
  @objc func longTap(_ sender : UILongPressGestureRecognizer){
    if sender.state == .ended {
      if !GlobalVariables.SMSVoz.reproduciendo && GlobalVariables.grabando{
        self.SMSVozBtn.setImage(UIImage(named: "smsvoz"), for: .normal)
        let dateFormato = DateFormatter()
        dateFormato.dateFormat = "yyMMddhhmmss"
        self.fechahora = dateFormato.string(from: Date())
        let name = "\(self.solicitudPendiente.id)-\(self.solicitudPendiente.idTaxi)-\(fechahora).m4a"
        GlobalVariables.SMSVoz.TerminarMensaje(name)
        GlobalVariables.SMSVoz.SubirAudio(GlobalVariables.UrlSubirVoz, name: name)
        GlobalVariables.grabando = false
        GlobalVariables.SMSVoz.ReproducirMusica()
      }
    }else if sender.state == .began {
      if !GlobalVariables.SMSVoz.reproduciendo{
        self.SMSVozBtn.setImage(UIImage(named: "smsvozRec"), for: .normal)
        GlobalVariables.SMSVoz.ReproducirMusica()
        GlobalVariables.SMSVoz.GrabarMensaje()
        GlobalVariables.grabando = true
      }
    }
  }
  
  //FUNCIÓN ENVIAR AL SOCKET
  func EnviarSocket(_ datos: String){
    if CConexionInternet.isConnectedToNetwork() == true{
      if GlobalVariables.socket.status.active{
        print(datos)
        GlobalVariables.socket.emit("data",datos)
      }else{
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
  
  func ErrorConexion(){
    let alertaDos = UIAlertController (title: "Sin Conexión", message: "No se puede conectar al servidor por favor revise su conexión a Internet.", preferredStyle: UIAlertController.Style.alert)
    alertaDos.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: {alerAction in
      exit(0)
    }))
    
    self.present(alertaDos, animated: true, completion: nil)
  }
  
  func MostrarDetalleSolicitud(){
    if self.solicitudPendiente.idTaxi != "null" && self.solicitudPendiente.idTaxi != ""{
      self.TaxiSolicitud.coordinate = self.solicitudPendiente.taximarker
      //self.MapaSolPen.addAnnotations([self.OrigenSolicitud, self.TaxiSolicitud])
      self.MapaSolPen.fitAll(in: [self.OrigenSolicitud, self.TaxiSolicitud], andShow: true)
      let temporal = self.solicitudPendiente.DistanciaTaxi()
      self.direccionOrigen.text = solicitudPendiente.dirOrigen
      self.direccionDestino.text = solicitudPendiente.dirDestino
      self.distanciaText.text = temporal + " KM"
      self.valorOferta.text = "$\(solicitudPendiente.valorOferta)"
      self.detallesView.isHidden = false
      self.SMSVozBtn.setImage(UIImage(named:"smsvoz"),for: UIControl.State())
    }else{
      self.MapaSolPen.addAnnotation(self.OrigenSolicitud)
    }
  }
  
  
  //CANCELAR SOLICITUDES
  func MostrarMotivoCancelacion(){
    //["No necesito","Demora el servicio","Tarifa incorrecta","Solo probaba el servicio", "Cancelar"]
    let motivoAlerta = UIAlertController(title: "", message: "Seleccione el motivo de cancelación.", preferredStyle: UIAlertController.Style.actionSheet)
    motivoAlerta.addAction(UIAlertAction(title: "No necesito", style: .default, handler: { action in
      self.CancelarSolicitud("No necesito")
    }))
    motivoAlerta.addAction(UIAlertAction(title: "Demora el servicio", style: .default, handler: { action in
      self.CancelarSolicitud("Demora el servicio")
    }))
    motivoAlerta.addAction(UIAlertAction(title: "Tarifa incorrecta", style: .default, handler: { action in
      self.CancelarSolicitud("Tarifa incorrecta")
    }))
    motivoAlerta.addAction(UIAlertAction(title: "Vehículo en mal estado", style: .default, handler: { action in
      self.CancelarSolicitud("Vehículo en mal estado")
    }))
    motivoAlerta.addAction(UIAlertAction(title: "Solo probaba el servicio", style: .default, handler: { action in
      self.CancelarSolicitud("Solo probaba el servicio")
    }))
    motivoAlerta.addAction(UIAlertAction(title: "Cancelar", style: UIAlertAction.Style.destructive, handler: { action in
    }))
    
    self.present(motivoAlerta, animated: true, completion: nil)
  }
  
  func CancelarSolicitud(_ motivo: String){
    //#Cancelarsolicitud, idSolicitud, idTaxi, motivo, "# \n"
    let Datos = self.solicitudPendiente.crearTramaCancelar(motivo: motivo)
    GlobalVariables.solpendientes.remove(at: self.solicitudIndex)
    //EnviarSocket(Datos)
    let vc = R.storyboard.main.inicioView()!
    vc.EnviarTimer(estado: 1, datos: Datos)
    self.navigationController?.show(vc, sender: nil)
  }
  
  override func homeBtnAction() {
    let vc = R.storyboard.main.inicioView()
    self.navigationController?.show(vc!, sender: nil)
  }
  
  //MASK:- ACCIONES DE BOTONES
  //LLAMAR CONDUCTOR
  @IBAction func LLamarConductor(_ sender: AnyObject) {
    if let url = URL(string: "tel://\(self.solicitudPendiente.movil)") {
      UIApplication.shared.open(url)
    }
  }
  @IBAction func ReproducirMensajesCond(_ sender: AnyObject) {
    if GlobalVariables.urlconductor != ""{
      GlobalVariables.SMSVoz.ReproducirVozConductor(GlobalVariables.urlconductor)
    }
  }
  
  //MARK:- BOTNES ACTION
  @IBAction func DatosConductor(_ sender: AnyObject) {
    let datos = "#Transporte," + GlobalVariables.cliente.idUsuario + "," + self.solicitudPendiente.idTaxi + ",# \n"
    self.EnviarSocket(datos)
    MensajeEspera.text = "Procesando..."
    AlertaEsperaView.isHidden = false
  }
  
  @IBAction func AceptarCond(_ sender: UIButton) {
    
    let alertaCompartir = UIAlertController (title: "Viaje seguro", message: "Para un viaje más seguro, puede compartir los datos de conductor con un amigo a familiar. ¿Desea compartir?", preferredStyle: UIAlertController.Style.alert)
    alertaCompartir.addAction(UIAlertAction(title: "Si", style: .default, handler: {alerAction in
      
      let datosAuto = self.MarcaAut.text! + ", " + self.ColorAut.text! + ", " + self.MatriculaAut.text!
      let datosConductor = self.NombreCond.text! + ", " + self.MovilCond.text! + ", " +  datosAuto
      let objectsToShare = [datosConductor]
      let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
      self.DatosConductor.isHidden = true
      self.present(activityVC, animated: true, completion: nil)
      
    }))
    alertaCompartir.addAction(UIAlertAction(title: "No", style: .default, handler: {alerAction in
      self.DatosConductor.isHidden = true
    }))
    self.present(alertaCompartir, animated: true, completion: nil)
  }
  
  @IBAction func NuevaSolicitud(_ sender: Any) {
    let vc = R.storyboard.main.inicioView()
    self.navigationController?.show(vc!, sender: nil)
  }

  @IBAction func CancelarProcesoSolicitud(_ sender: AnyObject) {
    MostrarMotivoCancelacion()
  }
  
  @IBAction func cerrarDatosConductor(_ sender: Any) {
    self.DatosConductor.isHidden = true
  }
}

extension SolPendController: GADBannerViewDelegate{
  
  func adViewDidReceiveAd(_ bannerView: GADBannerView) {
    print("get the ads")
  }
  
  func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
    print("Error receiving the ads \(error.description)")
  }
}
