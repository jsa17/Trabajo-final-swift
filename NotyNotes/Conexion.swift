//
//  Conexion.swift
//  NotyNotes
//
//  Created by Joselin S.A. on 05-10-21.
//

import Foundation
import CoreData
import UIKit

class Conexion{
    func contexto()->NSManagedObjectContext{
        let delegate = UIApplication.shared.delegate as! AppDelegate
        return delegate.persistentContainer.viewContext
        
        
        
    }
}
