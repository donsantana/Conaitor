//
//  Myvariables.swift
//  UnTaxi
//
//  Created by Donelkys Santana on 5/4/19.
//  Copyright © 2019 Done Santana. All rights reserved.
//

import Foundation
import SocketIO

struct GlobalVariables {
  static var socket: SocketIOClient!
  static var cliente : CCliente!
  static var solicitudesproceso: Bool = false
  static var taximetroActive: Bool = false
  static var solpendientes: [CSolicitud] = []
  static var ofertasList: [Oferta] = []
  static var grabando = false
  static var SMSProceso = false
  static var UrlSubirVoz:String!
  static var SMSVoz = CSMSVoz()
  static var urlconductor = ""
  static var userDefaults: UserDefaults!
}
