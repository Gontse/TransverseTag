//
//  ViewController.swift
//  TransverseTag
//
//  Created by Gontse Ranoto on 2018/11/13.
//  Copyright © 2018 Gontse Ranoto. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON
import MapKit

//JSON Respose Structs
//struct Venue {
//
//    let Id: String
//    let name: String
//    let country: String
//    let city: String
//    let latitude: CLLocationDegrees
//    let longitude: CLLocationDegrees
//}
//
//struct User {
//
//    let firstName: String
//    let lastName: String
//
//}
//struct VenuePhoto {
//
//    let sourcedFrom: String
//    let user: User
//}



protocol DataOperationsDelegate {
    func addAnnotionsToMapView(annotations: [MKAnnotation]) -> Void
     func getVenueDetails(venueDetails: Venue) -> Void
}

//protocol DataDetailOperationsDelegate {
//
//}

class ViewController: UIViewController {
   
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var dataManagerDelegate: DataOperationsDelegate!

    
    let ClientId = "B4YA0Y1PZD5VRPP2S2GDKE2FOVJ01GRH4U1XYQZAMOHMJTWF"
    let ClientSecret = "RQXX3I2TP0DLWM1T3DQDJT1CX55KXQNMNNZQ0WPVRVNRWG0E"
    let apiVersion = "20180505"
    
    
 
    
    // Resource URLs:
    var venueId = ""
    let basePath = "https://api.foursquare.com/v2/"
    let searchEventUrl = "venues/search?"
    let venueDetailsUrl = ""
    let searchPhoto = "venues/"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


  
    func RequestData(coordinates: CLLocationCoordinate2D) {
        
        let parameter: Parameters = ["client_secret":ClientSecret , "client_id":ClientId, "v":apiVersion, "ll":"\(coordinates.latitude),\(coordinates.longitude)"]
        
         var annotations : [MKAnnotation] = []
        let searchUrl = basePath + searchEventUrl
            
        Alamofire.request(searchUrl, method: .get, parameters: parameter).responseJSON { response in
           // print("Request: \(String(describing: response.request))")   // original url request
           // print("Response: \(String(describing: response.response))") // http url response
           // print("Result: \(response.result)")                         // response serialization result
            
            if let json = response.result.value {
               // print("JSON: \(json)") // serialized json response
               let swiftResp = JSON(json)
               let count = swiftResp["response"]["venues"].count
                
                for i in 1..<count {
                    let annotation = MKPointAnnotation()
                    annotation.title = swiftResp["response"]["venues"][i]["name"].stringValue

                    annotation.subtitle = "(\(swiftResp["response"]["venues"][i]["categories"][0]["name"].stringValue))"
                   
                    annotation.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(swiftResp["response"]["venues"][i]["location"]["lat"].doubleValue), longitude: swiftResp["response"]["venues"][i]["location"]["lng"].doubleValue)
               
                    annotations.append(annotation)
                    
                    self.appDelegate.venuedict.updateValue(swiftResp["response"]["venues"][i]["id"].stringValue, forKey: swiftResp["response"]["venues"][i]["name"].stringValue)
                    
                }
                self.dataManagerDelegate.addAnnotionsToMapView(annotations: annotations)
            }
        }
    }
    
    func RequestDetailsData(venueId: String) {
        
    
        
        let parameter: Parameters = ["client_secret":ClientSecret , "client_id":ClientId, "v":apiVersion]
        let searchUrl = "https://api.foursquare.com/v2/venues/\(venueId)"
        
        Alamofire.request(searchUrl, method: .get, parameters: parameter).responseJSON { response in
            
            if let json = response.result.value {
           
                let resp = JSON(json)
               
                let address = resp["response"]["venue"]["location"]["formattedAddress"][0].stringValue + " " + resp["response"]["venue"]["location"]["formattedAddress"][1].stringValue + " " + resp["response"]["venue"]["location"]["formattedAddress"][2].stringValue
                let category = resp["response"]["venue"]["categories"][0]["name"].stringValue
                let phoneNUmber = resp["response"]["venue"]["contact"]["formattedPhone"].stringValue 
                let name = resp["response"]["venue"]["name"].stringValue
                let id = resp["response"]["venue"]["id"].stringValue
                let bestPhoto = resp["response"]["venue"]["bestPhoto"]["prefix"].stringValue  + resp["response"]["venue"]["bestPhoto"]["suffix"].stringValue
                
                let venueDetail = Venue(Id: id, name: name, description: "", phoneNumber: phoneNUmber, address: address, category: category, bestImg: bestPhoto)
            self.dataManagerDelegate.getVenueDetails(venueDetails: venueDetail)
                
                 }
            }
        }
    
}

class Venue {
    
    let Id: String
    let name: String
    let _description : String
    let phoneNumber: String
    let address: String
    let category: String
    let bestImg:String

    init(Id:String, name:String, description:String,  phoneNumber:String, address:String, category:String, bestImg:String ) {
        
        self.name = name
        self._description = description
        self.phoneNumber = phoneNumber
        self.address = address
        self.Id = Id
        self.category = category
        self.bestImg = bestImg
    }
    
    convenience init() {
        self.init(Id: "", name: "", description: "Sorry the venue manager(s) have not yet provided any description about the venue", phoneNumber: "No phone number", address: "" , category : "", bestImg: "")
    }
}


