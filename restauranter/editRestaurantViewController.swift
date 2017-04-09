//
//  editRestaurantViewController.swift
//  Pods
//
//  Created by Darko Dujmovic on 08/04/2017.
//
//

import UIKit
import GoogleMaps

class editRestaurantViewController: UIViewController {

    var selectedMarker = GMSMarker()
    let cdh = coreDataHandler()
    
    @IBAction func closeButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var saveDataBtn: UIButton!
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var addressText: UITextField!
    var idRest = Int32()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    saveDataBtn.layer.cornerRadius = 20
    nameText.becomeFirstResponder()
    fillInputFields()
    
        
        
    }
    
    func fillInputFields(){
    nameText.text = (selectedMarker.userData as! Restaurant).name
    addressText.text = (selectedMarker.userData as! Restaurant).address
    idRest = (selectedMarker.userData as! Restaurant).id
    }
    
    @IBAction func saveData(_ sender: Any) {
        let editedName = (nameText.text?.isEmpty)! ? "Name not entered" : nameText.text
        let editedAddress = (addressText.text?.isEmpty)! ? "Address not entered" : addressText.text
        let markerId = (selectedMarker.userData as! Restaurant).id
        DispatchQueue.global(qos: .background).async {
        self.cdh.editInfo(markerID: markerId, name: editedName!, address: editedAddress!)}
        
        closeButton(self)
    }
  



}
