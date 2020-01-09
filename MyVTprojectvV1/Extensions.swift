//
//  Extension.swift
//  MyVTprojectvV1
//
//  Created by shahad almugrin on 1/7/20.
//  Copyright © 2020 shahad almugrin. All rights reserved.
//




import Foundation
import MapKit
import CoreData

extension Pin {
    
    var coordinate : CLLocationCoordinate2D{
        set {
            
            latitude = newValue.latitude
            longitude = newValue.longitude
        }
        
        get {
            return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
        
        
        
    }
    
    func compare(to coordinate:CLLocationCoordinate2D ) -> Bool {
        
        return (latitude == coordinate.latitude && longitude == coordinate.longitude)
        
    }
    
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        createdAt = Date()
    }
    
    
}


extension Photo {
    
    func set(image : UIImage){
        
        self.image = image.pngData()
    }
    
    func getImage() -> UIImage? {
        
        return (image == nil ) ? nil : UIImage(data: image!)
    }
    
    
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        
        createdAt = Date()
    }
    
}
