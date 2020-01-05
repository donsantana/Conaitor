//
//  InicioFormSolicitudExt.swift
//  MovilClub
//
//  Created by Donelkys Santana on 5/28/19.
//  Copyright © 2019 Done Santana. All rights reserved.
//

import UIKit

extension InicioController: UITableViewDelegate, UITableViewDataSource{
  //TABLA FUNCTIONS
  func numberOfSections(in tableView: UITableView) -> Int {
    // #warning Incomplete implementation, return the number of sections
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // #warning Incomplete implementation, return the number of rows
    switch tableView {
    case self.MenuTable:
      return self.MenuArray.count
    default:
      return self.formularioDataCellList.count
    }
  }
  
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch tableView {
    case self.MenuTable:
      let cell = tableView.dequeueReusableCell(withIdentifier: "MENUCELL", for: indexPath)
      cell.textLabel?.text = self.MenuArray[indexPath.row].title
      cell.textLabel?.font = UIFont(name: "HelveticaNeue", size: 21)
      cell.textLabel?.textColor = Customization.textColor
      cell.imageView?.image = UIImage(named: self.MenuArray[indexPath.row].imagen)?.imageWithColor(color1: Customization.textColor)
      return cell
    default:
      return self.formularioDataCellList[indexPath.row]
    }
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      self.MenuView1.isHidden = true
      self.TransparenciaView.isHidden = true
      tableView.deselectRow(at: indexPath, animated: false)
      switch tableView.cellForRow(at: indexPath)?.textLabel?.text{
      case "Solicitudes en proceso"?:
        if GlobalVariables.solpendientes.count > 0{
          let vc = R.storyboard.main.listaSolPdtes()
          vc!.solicitudesMostrar = GlobalVariables.solpendientes
          self.navigationController?.show(vc!, sender: nil)
        }else{
          super.topMenu.isHidden = false
          self.viewDidLoad()
          self.SolPendientesView.isHidden = false
        }
      case "Operadora":
        let vc = R.storyboard.main.callCenter()!
        vc.telefonosCallCenter = GlobalVariables.TelefonosCallCenter
        self.navigationController?.show(vc, sender: nil)
        
      case "Perfil":
        let vc = R.storyboard.main.perfil()!
        self.navigationController?.show(vc, sender: nil)
        
      case "Compartir app":
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
        GlobalVariables.userDefaults.set(nil, forKey: "\(Customization.nameShowed)-loginData")
        self.CloseAPP()
      default:
        print("nada")
      }
  }
  
  //FUNCIONES Y EVENTOS PARA ELIMIMAR CELLS, SE NECESITA AGREGAR UITABLEVIEWDATASOURCE
  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//    if tableView.isEqual(self.TablaDirecciones){
//      return true
//    }else{
      return false
//    }
  }
  
  func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
    return "Eliminar"
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//    if editingStyle == UITableViewCell.EditingStyle.delete {
//      self.EliminarFavorita(posFavorita: indexPath.row)
//      tableView.deleteRows(at: [indexPath as IndexPath], with: UITableView.RowAnimation.automatic)
//      if self.DireccionesArray.count == 0{
//        self.TablaDirecciones.isHidden = true
//      }
//      tableView.reloadData()
//    }
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    switch tableView {
    case self.MenuTable:
      return self.MenuTable.frame.height/CGFloat(self.MenuArray.count)
    case self.solicitudFormTable:
      switch indexPath.row {
      case 0:
        return 160
      case 1:
        return 104
      default:
        return 70
      }
    default:
      return 44
    }
  }
}
