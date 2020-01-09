//
//  DataController.swift
//  MyVTprojectvV1
//
//  Created by shahad almugrin on 1/7/20.
//  Copyright © 2020 shahad almugrin. All rights reserved.
//

import Foundation
import CoreData

class DataController {
    
    static let shared = DataController()
    
    let persistentContainer = NSPersistentContainer(name: "VirtualTour")
    
    var viewContext : NSManagedObjectContext {
        
        return persistentContainer.viewContext
    }
    
    func load() {
        
        persistentContainer.loadPersistentStores{
            (storeDescription , error) in guard  error == nil else {
                fatalError(error!.localizedDescription)
            }
            
            
        }
        
    }
    
    
    
}
