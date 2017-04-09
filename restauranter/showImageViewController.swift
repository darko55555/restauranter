//
//  showImageViewController.swift
//  restauranter
//
//  Created by Darko Dujmovic on 08/04/2017.
//  Copyright © 2017 Darko Dujmovic. All rights reserved.
//

import UIKit
import GoogleMaps

class showImageViewController: UIViewController {

    @IBOutlet weak var closeBtn: UIButton!
    //var callerMarker = GMSMarker()
    var showImage = UIImage()
    @IBOutlet weak var bigImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        closeBtn.layer.cornerRadius = 20
        bigImage.image = showImage
        // Do any additional setup after loading the view.
    }

    @IBAction func closeImageView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

}
