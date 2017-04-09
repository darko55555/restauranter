//
//  JSONHandler.swift
//  restauranter
//
//  Created by Darko Dujmovic on 29/03/2017. ¯\_(ツ)_/¯
//  Copyright © 2017 Darko Dujmovic. All rights reserved.
//

import Foundation

class JSONHandler {
    
    
    var returnRestaurantsArray = [restac]()
    
    func fetchData(callback: @escaping (([restac])->())){
        
        
        URLSession.shared.dataTask(with: URL(string: "http://www.mocky.io/v2/54ef80f5a11ac4d607752717")!) { data, response, error in
            
            guard let data = data else { fatalError() }
            guard let json = (try? JSONSerialization.jsonObject(with: data)) as? [[String: Any]] else { fatalError() }
            
            var idCounter = 0
            for object in json {
                
                let nam = object["Name"]! as! String
                let lat = object["Latitude"]! as! Float
                let lon = object["Longitude"]! as! Float
                let add = object["Address"]! as! String
                
                var aRestaurant = restac(id: idCounter, name: nam, lat: lat, lon: lon, address: add, image: "")
                self.returnRestaurantsArray.append(aRestaurant)
                idCounter += 1
            }
            
            let cdHandling = coreDataHandler()
            cdHandling.saveData(restaurants: self.returnRestaurantsArray)
            
            
            
            callback(self.returnRestaurantsArray)
            
            }.resume()

    }
    
    
}
