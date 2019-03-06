//
//  Solicitud+CoreDataProperties.swift
//  XTaxi
//
//  Created by Done Santana on 2/8/16.
//  Copyright © 2016 Done Santana. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Telefonos {

    @NSManaged var numerotelefono: String
    @NSManaged var operadoratelefono: String

}
