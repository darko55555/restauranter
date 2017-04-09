//
//  addRestViewController.swift
//  restauranter
//
//  Created by Darko Dujmovic on 04/04/2017.
//  Copyright © 2017 Darko Dujmovic. All rights reserved.
//

import UIKit
import GoogleMaps

class addRestViewController: UIViewController, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    var location:CLLocation?

    @IBOutlet weak var nameInput: UITextField!
    @IBOutlet weak var addressInput: UITextField!
    @IBOutlet weak var addRestarantBtn: UIButton!
    @IBAction func cancelAddRestaurant(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        addRestarantBtn.layer.cornerRadius = 20
        nameInput.becomeFirstResponder()
      
        self.locationManager.delegate = self
        self.locationManager.startUpdatingLocation()
        
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.last!
        self.locationManager.stopUpdatingLocation()
    }
    
    @IBAction func addRestaurant(_ sender: Any) {
        
        if (nameInput.text?.isEmpty)!{
            nameInput.shakeAndColor()
       }
        else if (addressInput.text?.isEmpty)!{
            addressInput.shakeAndColor()
        }
        else{
            let nameOfRest = nameInput.text
            let address = addressInput.text
            let userLoc = location

            //id
            let cdh = coreDataHandler()
            let lastId = cdh.getLastId(forKey: "id")
            
            //current user location
            let userLocCoord = userLoc?.coordinate
            let userLocLat = userLocCoord?.latitude
            let userLocLon = userLocCoord?.longitude
     
            
            //create object
            let newRest = restac(id: (Int(lastId+Int32(1))), name: nameOfRest!, lat: Float(userLocLat!), lon: Float(userLocLon!), address: address!, image: "")
          
        
            
            //store to Core data
            cdh.saveData(restaurants: [newRest])
            
            
            self.cancelAddRestaurant(self)
        }
        
    }
    
}
