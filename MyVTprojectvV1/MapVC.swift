//
//  MapVC.swift
//  MyVTprojectvV1
//
//  Created by shahad almugrin on 1/7/20.
//  Copyright © 2020 shahad almugrin. All rights reserved.
//
import UIKit
import MapKit
import CoreData
import CoreLocation

class MapVC: UIViewController , NSFetchedResultsControllerDelegate {
    
    var locationCoordinate : CLLocationCoordinate2D!
 var editMode = false
    var fetchedResultsController : NSFetchedResultsController<Pin>!
    
  
    @IBOutlet var navigationBar: UINavigationItem!
    
    var context : NSManagedObjectContext {
        return DataController.shared.viewContext
        
    }
    @IBOutlet weak var mapView: MKMapView!
     @IBOutlet weak var editBtn: UIBarButtonItem!
    
     override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.delegate = self
}
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
      setupFechedResultsController()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
         fetchedResultsController = nil
    }
    @IBAction func editBtnTapped(_ sender: UIBarButtonItem) {
           
           if editMode == false {
                editMode = true
               editBtn.title = "Done"
              
           }
           
           else {
               editMode = false
               editBtn.title = "Edit"
              
               
           }
           
           
           
       }
    func setupFechedResultsController() {
        
        let fetchRequest: NSFetchRequest<Pin> = Pin.fetchRequest()
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
        
              fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
            updateMapView()
        }
        catch {
            
            fatalError("failed!!! : \(error.localizedDescription)")
        }}
    // when longpress pin is dropped
    @IBAction func handleLongPress(_ sender: UILongPressGestureRecognizer) {
       let touchPoint = sender.location(in: mapView)
        
        let pin = Pin(context: context)
        
        pin.coordinate = mapView.convert(touchPoint , toCoordinateFrom: mapView)
      

        try? context.save()  }
    
    func updateMapView() {
        
        guard let pins = fetchedResultsController.fetchedObjects else {return}
        //saved pins are uploded
        for pin in pins {
            if mapView.annotations.contains(where: {pin.compare(to: $0.coordinate)}) {continue}
          let annotation = MKPointAnnotation()
             annotation.coordinate = pin.coordinate
          mapView.addAnnotation(annotation)}}
    // Go to photoCell
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GOPhotos" {
            let photosVC = segue.destination as! AlbumVC
            photosVC.pin = sender as? Pin }  }
 }


extension MapVC : MKMapViewDelegate {
    
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
    
      
        guard let annotationCo = view.annotation?.coordinate else {
    return
       }
       
         let pin = fetchedResultsController.fetchedObjects?.filter {$0.compare(to: annotationCo)}.first
      if editMode == false {
            performSegue(withIdentifier: "GOPhotos", sender: pin)
        }
        
        else {
            mapView.deselectAnnotation(view.annotation, animated: true)
           
            context.delete(pin!)
            try? context.save()
              self.mapView.removeAnnotation(view.annotation!)
            updateMapView() } }
    
   
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        updateMapView()
    }
    

}

