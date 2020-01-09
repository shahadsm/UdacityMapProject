//
//  AlbumeViewController.swift
//  MyVTprojectvV1
//
//  Created by shahad almugrin on 1/7/20.
//  Copyright © 2020 shahad almugrin. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation
import MapKit


class AlbumVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, NSFetchedResultsControllerDelegate {
    
    
    var locationCoordinate : CLLocationCoordinate2D!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    @IBOutlet weak var newCollectionBtn: UIBarButtonItem!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var noImageLabel: UILabel!
    
    var fetchedResultsController : NSFetchedResultsController<Photo>!

    var pin: Pin!
    var pageNumber = 1
    var Deleting = false
    
    @IBOutlet weak var mapView: MKMapView!
    
    
    var context : NSManagedObjectContext {
        return DataController.shared.viewContext
        
    }
    
    var photospresent: Bool {
        return (fetchedResultsController.fetchedObjects?.count ?? 0 ) != 0
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = pin.coordinate
        mapView.addAnnotation(annotation)
        mapView.centerCoordinate = pin!.coordinate
        
        initMap()
       

        
        guard let pin = pin else {
                       return
                   }
        
        
        let viewRegion = MKCoordinateRegion(center: pin.coordinate, latitudinalMeters: 10, longitudinalMeters: 10)
        
        mapView.setRegion(viewRegion, animated: false)
        
          activityIndicator.isHidden = true
        
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = pin.coordinate
        mapView.addAnnotation(annotation)
        mapView.centerCoordinate = pin!.coordinate
        
        setupFechedResultsController()    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        pin = nil
        fetchedResultsController = nil
    }
    
    
    func setupFechedResultsController() {
        
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = pin.coordinate
        mapView.addAnnotation(annotation)
        mapView.centerCoordinate = pin!.coordinate
        
        
        let fetchRequest: NSFetchRequest<Photo> = Photo.fetchRequest()
        
        fetchRequest.sortDescriptors = [
            
            NSSortDescriptor(key: "createdAt", ascending: false)
            
        ]
        
        fetchRequest.predicate = NSPredicate(format: "pin == %@", pin )
        print("pin is \(String(describing: pin))")

        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
            if  fetchedResultsController.fetchedObjects?.count == 0 {
                  noImageLabel.isHidden = false
                
            }
            else {
                
                  noImageLabel.isHidden = true
            }
            if photospresent{
                
               
                updateUI(proccessing: false)
                
            } else {
                
                buttomButtonTapped(self)
            }
           
        }
        catch {
            
            fatalError("failed : \(error.localizedDescription)")
            
        }
    }
    
    
    @IBAction func buttomButtonTapped(_ sender: Any) {
        updateUI(proccessing: true)
        
        
        if   photospresent{
            
            Deleting = true
            
            for photo in fetchedResultsController.fetchedObjects! {
                
                context.delete(photo)
            }
            
            try? context.save()
            Deleting = false
        }
        
        guard let coordiante = pin?.coordinate else {
            print("coordiante is null")
            return
        }
        
        FlickrAPI.Urlphoto(with: coordiante, pageNNumber: pageNumber) {
            
            (urls , error , errorMessage) in
            DispatchQueue.main.async {
                self.updateUI(proccessing: false)
                
                
                guard (error == nil ) && (errorMessage == nil) else {
                    
                    self.alert(title: "error", message: error?.localizedDescription ?? errorMessage!)
                    
                    return }
                
                guard let urls = urls , !urls.isEmpty else {
                    self.noImageLabel.isHidden = false
                    
                    return}
                
                 self.noImageLabel.isHidden = true
                
                for url in urls {
                    
                    let photo = Photo(context: self.context)
                    
                    photo.imageURL = url
                    photo.pin = self.pin}
                try? self.context.save()
                
                  } }
        pageNumber += 1
        
    }
    
    func updateUI(proccessing : Bool) {
        
        collectionView.isUserInteractionEnabled = !proccessing
        
        if proccessing {
            newCollectionBtn.title = ""
              activityIndicator.isHidden = false
            activityIndicator.startAnimating() }
        else {
            newCollectionBtn.title = "REfresh"
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = true
             }
    }
    // MARK: Initializers
    func initMap() {
        //prerpare map view
      
        mapView.isZoomEnabled = false
        mapView.isScrollEnabled = false
        mapView.isUserInteractionEnabled = false
    }
    
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! CollectionVC
        
        let photo = fetchedResultsController.object(at: indexPath)
        cell.photoImage.setPhoto(photo)
        return cell}
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let photo = fetchedResultsController.object(at: indexPath)
context.delete(photo)
        try? context.save()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width-20) / 3
        return CGSize(width: width, height: width)
    }
    
    
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
   }
    
   func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        if let indexPath = indexPath , type == .delete && !Deleting{
            collectionView.deleteItems(at: [indexPath])
            return
        }
        
        if let indexPath = indexPath , type == .insert  {
            collectionView.insertItems(at: [indexPath])
            return
        }
        
        
        if let newIndexPath = newIndexPath , let oldIndexPath = indexPath , type == .move  {
            collectionView.moveItem(at: oldIndexPath, to: newIndexPath)
            return
        }
        
        
        if type != .update {
            
            collectionView.reloadData()
        }}
    
}

