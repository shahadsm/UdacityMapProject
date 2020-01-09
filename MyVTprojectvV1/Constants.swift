//
//  Constants.swift
//  MyVTprojectvV1
//
//  Created by shahad almugrin on 1/7/20.
//  Copyright © 2020 shahad almugrin. All rights reserved.
//

import Foundation


struct Constants {
    
    
    struct Flickr {
        
        static let APIScheme = "https"
        static let APIHost = "api.flickr.com"
        static let APIPath = "/services/rest"
        
        static let SearchBoxHalfWidth = 1.0
        static let SearchBoxHalfHeight = 1.0
        static let SearchLatRange = (-90 , 90)
        static let SearchLongRange = (-180, 180)
       

        
    }
    
    struct Keys {
        
        static let Method = "method"
        static let APIKey = "api_key"
        static let Extras = "extras"
        static let Format = "format"
        static let NoJSONCallBack = "nojsoncallback"
        static let SafeSearch = "safe_search"
        static let Text = "text"
        static let Page = "page"
        static let PerPage = "per_page"
        static let BoundingBox = "bbox"
        
    }
    
    struct Values {
        
        static let SearchMethod = "flickr.photos.search"
        static let APIKey = "94fa1948b023e11c99eaf5c2d61cc7c2"
        static let ResponseFormat = "json"
        static let DisableJSONCallBack = "1"
        static let SafeSearch = "safe_search"
        static let GalleryPhotosMethod = "flickr.gallaries.getPhotos"
        static let MediumURL = "url_m"
        static let UseSafeSearch = "1"
        static let PerPage = 10
        
    }
    
    
    
}


