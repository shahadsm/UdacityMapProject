//
//  alertFunction.swift
//  MyVTprojectvV1
//
//  Created by shahad almugrin on 1/7/20.
//  Copyright © 2020 shahad almugrin. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    //will be used throughout to print alert msgs
    
    func alert (title : String , message : String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        DispatchQueue.main.async {
            self.present(alert , animated: true , completion: nil)
        }
        
        
    }
}

