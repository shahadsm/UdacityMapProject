//
//  AppDelegate.swift
//  MyVTprojectvV1
//
//  Created by shahad almugrin on 1/7/20.
//  Copyright © 2020 shahad almugrin. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
      
        
        DataController.shared.load()
        
        return true
    }
    
    func saveViewContext(){
        
        try? DataController.shared.viewContext.save()
        
    }

   

    func applicationDidEnterBackground(_ application: UIApplication) {
            saveViewContext()

    }

  

    func applicationWillTerminate(_ application: UIApplication) {
        
        
        saveViewContext()
    }

   
    
}

