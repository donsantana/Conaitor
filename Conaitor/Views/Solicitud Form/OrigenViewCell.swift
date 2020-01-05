//
//  OrigenViewCell.swift
//  MovilClub
//
//  Created by Donelkys Santana on 5/26/19.
//  Copyright © 2019 Done Santana. All rights reserved.
//

import UIKit
import GooglePlaces

class OrigenViewCell: UITableViewCell {
  var reservaDate: OurDate!
//  var arrayAddress = [GMSAutocompletePrediction](){
//    didSet{
//      self.origenAddressTable.reloadData()
//      self.destinoAddressTable.reloadData()
//    }
//  }
  lazy var filter: GMSAutocompleteFilter = {
    let filter = GMSAutocompleteFilter()
    filter.type = .address
    return filter
  }()
  
  @IBOutlet weak var origenText: UITextField!
  @IBOutlet weak var reservaBtn: UIButton!
  @IBOutlet weak var referenciaText: UITextField!
  @IBOutlet weak var destinoText: UITextField!
 
  @IBOutlet weak var reservaView: UIView!
  @IBOutlet weak var fechaReserva: UITextField!
  

  
  private var datePicker: UIDatePicker?
  
  func initContent(){
    self.origenText.delegate = self
    self.destinoText.delegate = self
//    self.origenAddressTable.delegate = self
//    self.origenAddressTable.dataSource = self
//    self.origenAddressTable.allowsSelection = true
//    self.destinoAddressTable.delegate = self
//    self.destinoAddressTable.dataSource = self
//    self.destinoAddressTable.allowsSelection = true
    self.reservaBtn.addBorder()
    self.fechaReserva.text = "Al Momento"

    //binding textfield with datePicker
    datePicker = UIDatePicker()
    datePicker?.datePickerMode = .dateAndTime
    datePicker?.minimumDate = Calendar.current.date(byAdding: .year, value: 0, to: Date())
    datePicker?.addTarget(self, action: #selector(self.dateChange(datePicker:)), for: .valueChanged)
    fechaReserva.inputView = datePicker
    
    let toolBar = UIToolbar().ToolbarPiker(mySelect: #selector(self.dismissPicker))
    self.fechaReserva.inputAccessoryView = toolBar
    
    self.origenText.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
    self.destinoText.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
    //Register Cell
    //self.origenAddressTable.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
  }
  
  //Date picker functions
  @objc func dateChange( datePicker: UIDatePicker) {
    self.reservaDate = OurDate(date: datePicker.date)
    self.fechaReserva.text = self.reservaDate.dateTimeToShow()
  }
  
  @objc func dismissPicker() {
    self.endEditing(true)
  }
  
  @objc func textFieldDidChange(_ textField: UITextField) {
//    if !textField.text!.isEmpty{
//      GMSPlacesClient.shared().autocompleteQuery(textField.text!, bounds: nil, filter: filter, callback: {(result, error) in
//        if error == nil && result != nil{
//          self.arrayAddress = result!
//        }else{
//          print("here \(error.debugDescription)")
//        }
//      })
//    }else{
//      self.arrayAddress = [GMSAutocompletePrediction]()
//    }
//    self.origenAddressView.isHidden = self.arrayAddress.count == 0 || !textField.isEqual(self.origenText)
//    self.destinoAddressView.isHidden = self.arrayAddress.count == 0 || !textField.isEqual(self.destinoText)
  }
  
  @IBAction func showFechaReserva(_ sender: Any) {
    self.fechaReserva.isHidden = false
  }
  
  
}
//
//extension OrigenViewCell: UITableViewDelegate, UITableViewDataSource{
//  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//    self.origenAddressTable.isHidden = arrayAddress.count == 0
//    return arrayAddress.count
//  }
//
//  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//    var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
//    if cell == nil{
//      cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
//    }
//    cell?.textLabel?.attributedText = arrayAddress[indexPath.row].attributedFullText
//    cell?.textLabel?.font = UIFont.systemFont(ofSize: 14)
//    return cell!
//  }
//
//  func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
//    if tableView.isEqual(self.origenAddressTable){
//      self.origenText.text = self.arrayAddress[indexPath.row].attributedFullText.string
//      self.origenAddressView.isHidden = true
//    }else{
//      self.destinoText.text = self.arrayAddress[indexPath.row].attributedFullText.string
//      self.destinoAddressView.isHidden = true
//    }
//    self.arrayAddress.removeAll()
//    return true
//  }
//
//}

extension OrigenViewCell: UITextFieldDelegate{
  func textFieldDidBeginEditing(_ textField: UITextField) {
    textField.text?.removeAll()
  }
  
//  func textFieldDidEndEditing(_ textField: UITextField) {
//    self.origenAddressView.isHidden = true
//    self.destinoAddressView.isHidden = true
//  }
}
