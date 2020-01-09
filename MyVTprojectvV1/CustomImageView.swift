//
//  CustomImageView.swift
//  MyVTprojectvV1
//
//  Created by shahad almugrin on 1/7/20.
//  Copyright © 2020 shahad almugrin. All rights reserved.
//

import Foundation
import UIKit




let imageCache = NSCache<NSString , AnyObject >()

class CustomImageView : UIImageView{
    
    var imageURL : URL!
    
    func setPhoto(_ newPhoto : Photo) {
        
        if photo != nil {
            
            return
        }
        
        photo = newPhoto
    
    }
    
    
    private var photo : Photo! {
        
        didSet{
            if let image = photo.getImage() {
                
               self.hideActivityIndicatorView()
                self.image = image
                
                return
            }
            
            guard let url = photo.imageURL else {
                return
            }
            
            loadImageUsingCache(with: url)
            
        }
    }
    
    
    
    func  loadImageUsingCache(with url : URL) {
        
        imageURL = url
        image = nil
        showActivityIndicatorView()
        
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString ) as? UIImage {
            
            image = cachedImage
            self.hideActivityIndicatorView()
            return
            
        }
        URLSession.shared.dataTask(with  : url ) {
            (data ,response ,  error ) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let downloadedImage = UIImage(data: data!) else { return }
            imageCache.setObject(downloadedImage, forKey: url.absoluteString as NSString)
            
            DispatchQueue.main.async {
                self.image = downloadedImage
                self.photo.set(image: downloadedImage)
                try? self.photo.managedObjectContext?.save()
                
                self.hideActivityIndicatorView()
                
            }
            
           
        }.resume()
        
    }
    
    lazy var activityIndicatorView: UIActivityIndicatorView = {
        
        let activityIndicatorView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
        self.addSubview(activityIndicatorView)
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        
        activityIndicatorView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        activityIndicatorView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
activityIndicatorView.color = .black
        activityIndicatorView.hidesWhenStopped = true
        return activityIndicatorView
        
    }()
    
    
    func showActivityIndicatorView() {
        
        DispatchQueue.main.async {
            self.activityIndicatorView.startAnimating()
        }
        
    }
    
    func hideActivityIndicatorView() {
        
        self.activityIndicatorView.stopAnimating()
        
    }
    
    
    
}
