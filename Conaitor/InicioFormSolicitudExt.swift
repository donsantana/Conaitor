//
//  InicioFormSolicitudExt.swift
//  TM
//
//  Created by Donelkys Santana on 5/28/19.
//  Copyright © 2019 Done Santana. All rights reserved.
//

import UIKit


class SolicitudFormViewDataSource: NSObject, UITableViewDataSource{

  func numberOfSections(in tableView: UITableView) -> Int {
    return myvariables.cliente.empresa != nil ? 3 : 2
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    var cell = UITableViewCell()
    
    switch indexPath.section {
    case 0:
      let origenCell = Bundle.main.loadNibNamed("OrigenCell", owner: self, options: nil)?.first as! OrigenViewCell
      cell = origenCell
    case 1:
      cell = tableView.numberOfSections == 3 ? Bundle.main.loadNibNamed("VoucherCell", owner: self, options: nil)?.first as! VoucherViewCell : Bundle.main.loadNibNamed("ContactoCell", owner: self, options: nil)?.first as! ContactoViewCell
    default:
      cell = Bundle.main.loadNibNamed("ContactoCell", owner: self, options: nil)?.first as! ContactoViewCell
    }
    return cell
  }
  

}

extension InicioController: UITableViewDelegate, UITableViewDataSource{
  //TABLA FUNCTIONS
  func numberOfSections(in tableView: UITableView) -> Int {
    // #warning Incomplete implementation, return the number of sections
    if tableView.isEqual(solicitudFormTable){
      return myvariables.cliente.empresa != nil ? 3 : 2
    }else{
      return 1
    }
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
      case "Operadora"?:
        let vc = UIStoryboard(name:"Main", bundle:nil).instantiateViewController(withIdentifier: "CallCenter") as! CallCenterController
        vc.telefonosCallCenter = self.TelefonosCallCenter
        self.navigationController?.show(vc, sender: nil)
      case "Perfil"?:
        let vc = UIStoryboard(name:"Main", bundle:nil).instantiateViewController(withIdentifier: "Perfil") as! PerfilController
        self.navigationController?.show(vc, sender: nil)
      case "Tipo de Transporte"?:
        let vc = R.storyboard.main.transpMenuView()
        let navController = UINavigationController(rootViewController: vc!)
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        appdelegate.window!.rootViewController = navController
        
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
        myvariables.userDefaults.set(nil, forKey: "\(Customization.nameShowed)-loginData")
        self.CloseAPP()
      default:
        print("nada")
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
