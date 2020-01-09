//
//  FlickrAPI.swift
//  MyVTprojectvV1
//
//  Created by shahad almugrin on 1/7/20.
//  Copyright © 2020 shahad almugrin. All rights reserved.
//

import Foundation
import MapKit

struct FlickrAPI  {
    
   

    
    
    static func Urlphoto(with coordinate : CLLocationCoordinate2D , pageNNumber : Int ,
                              completion : @escaping ([URL]? , Error? , String?) -> () )  {
        
        let methodParameters = [Constants.Keys.Method : Constants.Values.SearchMethod  ,
                                Constants.Keys.APIKey  : Constants.Values.APIKey ,
                                Constants.Keys.BoundingBox : bboxString(for: coordinate) ,
                                Constants.Keys.SafeSearch : Constants.Values.UseSafeSearch,
                                Constants.Keys.Extras : Constants.Values.MediumURL ,
                                Constants.Keys.Format : Constants.Values.ResponseFormat,
                                Constants.Keys.NoJSONCallBack : Constants.Values.DisableJSONCallBack,
                                Constants.Keys.Page : pageNNumber ,
                                Constants.Keys.PerPage : Constants.Values.PerPage
        ] as [String : Any]
        
        
        
        let request = URLRequest(url: getURL(from: methodParameters))
        
        
        let task = URLSession.shared.dataTask(with: request) {
            (data , response , error ) in
            guard (error == nil ) else {
                completion(nil , error , nil)
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode , statusCode >= 200 && statusCode <= 299 else {
                completion(nil , nil , "your request returned a status code other than 2xx !")
                
                return
            }
            
            guard let data = data else {
                
                completion(nil , nil , "no returned Dataw!")
                
                return
                
            }
            
            print(String(data : data , encoding : .utf8)!)
            
            guard let result = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                completion(nil , nil , "Could not parse json")
                
                return
            }
            
            guard let stat = result["stat"] as? String , stat == "ok" else {
                completion(nil , nil , "Flickr API returned an error \(result)")
                return
            }
            
            
            guard let photosDictionary = result["photos"] as? [String : Any] else {
                completion(nil , nil , "cannot find key \(result)")
                return
            }
            
            
            guard let photosArray = photosDictionary["photo"] as?  [[String : Any]] else {
                completion(nil , nil , "cannot find key \(photosDictionary)")
                return
            }
            
            let photosURLs = photosArray.compactMap { photosDictionary -> URL? in
                guard let url = photosDictionary["url_m"] as? String else {
                    return nil
                }
                return URL(string : url)
            }
            completion(photosURLs , nil , nil)
            
            
            
            
        }
        task.resume()
        
        
        
       
        
    }
    
    static func bboxString(for coordinate : CLLocationCoordinate2D) -> String {
        
        let latitude = coordinate.latitude
        let longitude = coordinate.longitude
        let minLong = max(longitude - Constants.Flickr.SearchBoxHalfWidth, -180)
        
        let minLat = max(latitude - Constants.Flickr.SearchBoxHalfHeight, -90)
        
        let maxLong = min(longitude + Constants.Flickr.SearchBoxHalfWidth , 180)
        let maxLat =  min(latitude + Constants.Flickr.SearchBoxHalfHeight , 90)
        
        return "\(minLong), \(minLat) , \(maxLong) , \(maxLat)"
        
        
    }
    
    
    
    static func getURL(from parameters: [String : Any]) -> URL {
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = Constants.Flickr.APIHost
        components.path = Constants.Flickr.APIPath
        components.queryItems = [URLQueryItem]()
        
        for (key , value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        return components.url!
        
    }
    
    
    
    
    
    
}
