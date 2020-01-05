//
//  OurDate.swift
//  MovilClub
//
//  Created by Donelkys Santana on 8/12/19.
//  Copyright © 2019 Done Santana. All rights reserved.
//

import UIKit

struct OurDate{
  var date: Date!
  
  init(stringDate: String?) {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
    dateFormatter.timeZone = TimeZone.init(abbreviation:"GMT")
    if stringDate != nil{
      self.date = dateFormatter.date(from: stringDate!)
    }else{
      self.date = Date()
    }
  }
  
  init(date: Date){
    self.date = date
  }
  
  func isToday()->Bool{
    return (self.date <= Date())
  }
  
  func getISODate() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
    return dateFormatter.string(from: self.date)
  }
  
  func getOnlyDate() -> String {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_US")
    formatter.dateStyle = .medium
    formatter.timeStyle = .none
    return formatter.string(from: date)
  }
  
  func getOnlyTime() -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm:ss"
    formatter.dateStyle = .none
    formatter.timeStyle = .medium
    return formatter.string(from: date)
  }
  
  func dateTimeToShow()->String{
    let formatter = DateFormatter()
    formatter.dateFormat = "MMM dd,yyyy HH:mm:ss a"
    return formatter.string(from: date)
  }
}
