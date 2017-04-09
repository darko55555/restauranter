//
//  ViewController.swift
//  restauranter
//
//  Created by Darko Dujmovic on 28/03/2017.
//  Copyright © 2017 Darko Dujmovic. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreData


class ViewController: UIViewController, GMSMapViewDelegate {
    
    
    @IBOutlet weak var restTitle: UILabel!
    @IBOutlet weak var optionsFooterView: UIView!
    @IBOutlet weak var optionsViewPosition: NSLayoutConstraint!
    @IBOutlet weak var optionsView: UIView!
    @IBOutlet weak var restaurantImage: UIImageView!
    @IBOutlet weak var restAddress: UILabel!
    
    var isOptionsViewShown = false
    var tappedMarker = GMSMarker()
    var tappedMarkerImage = UIImage()
    var currentUserLocation = CLLocationCoordinate2D()
    
    //variabla za provjeru da li je aplikacija pokrenuta prvi put
    let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")

    
    @IBAction func closeOptionsView(_ sender: Any) {
        UIView.animate(withDuration: 0.6) {
              self.optionsView.isHidden = true
        }
      
    }
    
    //edit restaurant data action
    @IBAction func optionsViewAction(_ sender: Any) {
        
        let a = tappedMarker.userData as! Restaurant
        print("Print marker info \(a.id)")

    }
    
    @IBOutlet weak var mpView: GMSMapView!
    
    //array za restorane
    var restaurants = [Restaurant](){
        didSet{
           print("Count restaurants = \(restaurants.count)")
           let restCount = restaurants.count
           addMarkers(restos: restaurants)
        }
    }

    //array za markere
    var markers = [GMSMarker]()
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        checkIfFirstRun()
        self.optionsView.isHidden = true
      //  self.optionsView.isHidden = false
        self.optionsView.setNeedsDisplay()
        self.optionsView.setNeedsLayout()
        self.optionsView.setNeedsFocusUpdate()
        
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mpView.delegate = self
        //checkIfFirstRun()
        DispatchQueue.global(qos: .background).async {
        self.addGestures()
        }
        
        
        
        //početna pozicija kamere
        
        let cameraPosition = GMSCameraPosition.camera(withLatitude:45.815399, longitude: 15.966568, zoom: 12)
        mpView.camera = cameraPosition
        mpView.isMyLocationEnabled = true
        mpView.settings.myLocationButton = true
        
        //opcijski view je hidean, pojavi se na marker tap
        self.optionsView.isHidden = true
        optionsView.center = CGPoint(x: (self.view.bounds.width/2), y: (self.view.bounds.height/2))

    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
            tappedMarker = marker
      
            self.optionsView.isHidden = false
            self.optionsView.layer.cornerRadius = 12
            self.optionsView.center = CGPoint(x: (self.view.bounds.width/2), y: (self.view.bounds.height/2))
            //add title
            self.restTitle.text = (marker.userData as! Restaurant).name
            //add address
            self.restAddress.text = (marker.userData as! Restaurant).address
        
            let storedImage = (marker.userData as! Restaurant).photo!
            let path = String(describing:getDocumentsDirectory())
            let url = URL(fileURLWithPath: path).appendingPathComponent(storedImage)
            let imageee = UIImage(contentsOfFile: url.path)
            if storedImage.isEmpty {
                self.restaurantImage.image = UIImage(named: "noPhoto")
                self.tappedMarkerImage = UIImage(named: "noPhoto")!
            }else{
            self.restaurantImage.image = imageee
            self.tappedMarkerImage = imageee!
                }
    
        return true
    }

    
    func addMarkers(restos: [Restaurant]){

        //google SDK zahtjeva da UI aktivnosti budu eksplicitno na main threadu
      DispatchQueue.main.async {
        for resto in restos{
            let marker = GMSMarker()
            let restLat = resto.latitude
            let restLon = resto.longitude
            marker.position = CLLocationCoordinate2D(latitude: CLLocationDegrees(restLat), longitude: CLLocationDegrees(restLon))
            marker.map = self.mpView
            marker.userData = resto
        }}
   
        
    }

    
    func fetchData(){

        //klasa JSON handler dohvaća JSON sa servera i ima closure kao input parametar koji se okida nakon dohvaćanja svih podataka
        DispatchQueue.global(qos: .background).async {
        let jsonHandler = JSONHandler()
        jsonHandler.fetchData() { (response) in
            let cdHandler = coreDataHandler()
            self.restaurants = cdHandler.loadCoreData()
            
        }

        }
    }
    
    func addGestures(){
        let tapGestureRecognizerForPhoto = UITapGestureRecognizer(target: self, action: #selector(openImage))
        restaurantImage.isUserInteractionEnabled=true
        restaurantImage.addGestureRecognizer(tapGestureRecognizerForPhoto)
    }
    func openImage(){
        print("Click on the image")
        performSegue(withIdentifier: "showImage", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "addPhoto"){
        let cameraVC = segue.destination as! CameraViewController
            cameraVC.callerMarker = tappedMarker}
        else if (segue.identifier == "showImage"){
        let showImageVC = segue.destination as! showImageViewController
        showImageVC.showImage = tappedMarkerImage
        }
        else if (segue.identifier == "editData"){
        let editDataVC = segue.destination as! editRestaurantViewController
        editDataVC.selectedMarker = tappedMarker
        }
    }
    
    func checkIfFirstRun(){
      
       //provjera da li je prvo pokretanje ili ne, na osnovu spremljenog statusa u user defaults
        if launchedBefore {
            print("\n++++++++++++++++++ Not the first launch, read from core data")
            let cdh = coreDataHandler()
            self.restaurants = cdh.loadCoreData()
        }else{
            print("\n++++++++++++++++++ First run, load data from JSON")
            UserDefaults.standard.set(true, forKey: "launchedBefore")
            fetchData()
        }
        
    }
    
}


