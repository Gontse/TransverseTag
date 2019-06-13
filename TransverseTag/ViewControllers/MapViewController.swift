//
//  MapViewController.swift
//  TransverseTag
//
//  Created by Gontse Ranoto on 2018/11/13.
//  Copyright © 2018 Gontse Ranoto. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import RSLoadingView



class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, DataOperationsDelegate {
    
    
 
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    let VC = ViewController()
    let loadingView = RSLoadingView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.tintColor = UIColor.red
       
        self.mapView.showsUserLocation = true
        
        if CLLocationManager.locationServicesEnabled() == true {
            
            if CLLocationManager.authorizationStatus() == .restricted || CLLocationManager.authorizationStatus() == .denied || CLLocationManager.authorizationStatus() == .notDetermined {
                locationManager.requestWhenInUseAuthorization()
            }
            locationManager.desiredAccuracy = 1.0
            
           
        }
       
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        
        mapView.delegate = self
        mapView.showsScale = true
       // mapView.showsTraffic = true
        mapView.showsCompass = true
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    
          let identifier = "myAnnot"
           var annotationView : MKMarkerAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
       
        if #available(iOS 11.0, *) {
            var markerAnnotationView: MKMarkerAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
            if markerAnnotationView == nil {
                markerAnnotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                markerAnnotationView?.canShowCallout = true
            }
            
            markerAnnotationView?.glyphText = ""
            markerAnnotationView?.subtitleVisibility = .visible
            markerAnnotationView?.titleVisibility = .visible
            markerAnnotationView?.markerTintColor = UIColor.orange
            markerAnnotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            
            annotationView = markerAnnotationView
        }else{
            
            var pinAnnotationView: MKPinAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
            if pinAnnotationView == nil {
                pinAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                
                if pinAnnotationView == nil {
                    pinAnnotationView?.canShowCallout = true
                    pinAnnotationView?.pinTintColor = UIColor.orange
                }
               // annotationView = pinAnnotationView
            }
        }
        return annotationView
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView)
    {
        if let annotationTitle = view.annotation?.title
        {
            print("User tapped on annotation with title: \(annotationTitle!)")
        }
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        
        //loadingView.mainColor = UIColor.red
        loadingView.shouldTapToDismiss = true
        loadingView.show(on: self.view)
        
        if let annotationTitle = view.annotation?.title
          {
               let index = self.appDelegate.venuedict.index(forKey: annotationTitle!)
               print(self.appDelegate.venuedict[index!].value)
               self.VC.RequestDetailsData(venueId: self.appDelegate.venuedict[index!].value)
            }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getSearchLocationString(location:String) -> CLLocationCoordinate2D {
      
        var locationCoordinates = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
        
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(location, completionHandler: {
            placemarks, err in
           
            if let error = err {
                print(error)
                return
            }
            if let placemarks = placemarks {
                let placeMark = placemarks[0]
                if let location = placeMark.location {
                    //Get lat lon
                   locationCoordinates = location.coordinate
                }
            }
        })
        
            return locationCoordinates
    }
    //GET DIRECTION
//    func showDirection(placeMark : MKPlacemark) {
//        //guard let currentPlacemark = currentPlacemark
//        let directionRequest = MKDirectionsRequest()
//        directionRequest.source = MKMapItem.init(placemark: placeMark)
//        let destinationPlacemark = MKPlacemark(placemark: placeMark)
//    }
    
    //MARK:- CLLocation Manager
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude), span: MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002))
        self.mapView.setRegion(region, animated: true)
        VC.RequestData(coordinates: locations[0].coordinate);
        VC.dataManagerDelegate = self
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to start")
    }
    
    func addAnnotionsToMapView(annotations: [MKAnnotation]) {
        //Make adding annotations a priority
        DispatchQueue.main.async {
             self.mapView.showAnnotations(annotations, animated: true)
        }
        
    }
    
    func getVenueDetails(venueDetails: Venue) {
        
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VenueDetail") as? VenueDetailViewController{
            if let navigator = self.navigationController {
                
                
                
                viewController.vId = venueDetails.Id // appDelegate.venuedict.
                viewController.vAddress = venueDetails.address
                viewController.vDescription = venueDetails._description
                viewController.vPhoneNumber = venueDetails.phoneNumber
                viewController.vName = venueDetails.name
                viewController.vCategory = venueDetails.category
                
                navigator.pushViewController(viewController, animated: true)
                loadingView.hide()
                
            }
        }
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
