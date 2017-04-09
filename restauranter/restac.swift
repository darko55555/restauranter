//
//  restac.swift
//  restauranter
//
//  Created by Darko Dujmovic on 30/03/2017.
//  Copyright © 2017 Darko Dujmovic. All rights reserved.
//

import UIKit

class restac: NSObject {
    
    var id:Int
    var name: String
    var latitude: Float
    var longitude: Float
    var address: String
    var image: String
    
    init(id:Int, name:String, lat:Float, lon:Float, address:String, image:String){
        self.id = id
        self.name = name
        self.latitude = lat
        self.longitude = lon
        self.address = address
        self.image = image
    }

}
