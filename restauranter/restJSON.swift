//
//  restJSON.swift
//  restauranter
//
//  Created by Darko Dujmovic on 29/03/2017.
//  Copyright © 2017 Darko Dujmovic. All rights reserved.
//

import Foundation

class restJSON {
    
    var id:Int
    var name: String
    var latitude: Float
    var longitude: Float
    var address: String
    
    init(id:Int, name:String, lat:Float, lon:Float, address:String){
        self.id = id
        self.name = name
        self.latitude = lat
        self.longitude = lon
        self.address = address
    }
}
