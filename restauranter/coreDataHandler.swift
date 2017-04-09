//
//  coreDataHandler.swift
//  restauranter
//
//  Created by Darko Dujmovic on 03/04/2017.
//  Copyright © 2017 Darko Dujmovic. All rights reserved.
//

import UIKit
import CoreData


class coreDataHandler: NSObject {
    
    
    var lastID:Int32 = 0

    func saveData (restaurants: [restac]){
       
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        for rest in restaurants {
            
            let entity = NSEntityDescription.entity(forEntityName: "Restaurant", in: managedContext)
            
            let restaurant = NSManagedObject(entity: entity!, insertInto: managedContext)

            restaurant.setValue(rest.address, forKey: "address")
            restaurant.setValue(rest.name, forKey: "name")
            restaurant.setValue(rest.id, forKey: "id")
            restaurant.setValue(rest.longitude, forKey: "longitude")
            restaurant.setValue(rest.latitude, forKey: "latitude")
            restaurant.setValue(rest.image, forKey: "photo")
           // print("\n\n ------ Saving \(rest.name )")
        }
        
        
        do{
            try managedContext.save()
        
        }catch let error as NSError{
            print("Can't save due to \(error)")
        }
    }
    
    func loadCoreData()->[Restaurant]{
        
        var restaurants = [Restaurant]()
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        let managedContext = appDelegate?.persistentContainer.viewContext
        
        do{
            let fetchRequest : NSFetchRequest<Restaurant> = Restaurant.fetchRequest()
            
            let result = try managedContext?.fetch(fetchRequest)
            
            for res in result! {
                restaurants.append(res)
            }
            self.lastID = (restaurants.last?.id)!
            print("Last id is \(self.lastID)")
            return restaurants
            
        }
        catch {
            fatalError("Error while trying to get core data")
        }
        print("Restaurants = \(restaurants[0])")
        return restaurants
    }
    
    func getLastId(forKey key: String)->Int32{
        
        var lastId = Int32()
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let managedContext =  appDelegate?.persistentContainer.viewContext
        do{
            let fetchRequest : NSFetchRequest<Restaurant> = Restaurant.fetchRequest()
            fetchRequest.fetchLimit = 1
            let sortDescriptor = NSSortDescriptor(key: key, ascending: false)
            fetchRequest.sortDescriptors = [sortDescriptor]
            let result = try managedContext?.fetch(fetchRequest)
            for rest in result!{
                lastId = rest.id
            }
            return lastId
        } catch{
            print("Can't get last ID")
        }
        return lastId
    }
    
    func addPhotoToRestaurant(markerID: Int32, photoAddress:String){
    
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        let managedContext = appDelegate?.persistentContainer.viewContext
        
        let fetchRequest : NSFetchRequest<Restaurant> = Restaurant.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id = %d", markerID)
        
        do{
          
            let result = try managedContext?.fetch(fetchRequest)
            
            for res in result! {
                res.setValue(photoAddress, forKey: "photo")
            }
           
        }
        catch {
            fatalError("Error while trying to get core data")
        }
        do{
            try managedContext?.save()
            
        }catch let error as NSError{
            print("Can't save due to \(error)")
        }

    }
    
    func editInfo(markerID: Int32, name:String, address:String){
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        let managedContext = appDelegate?.persistentContainer.viewContext
        
        let fetchRequest : NSFetchRequest<Restaurant> = Restaurant.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id = %d", markerID)
        
        do{
            
            let result = try managedContext?.fetch(fetchRequest)
            
            for res in result! {
                res.setValue(name, forKey: "name")
                res.setValue(address, forKey: "address")
            }
            
        }
        catch {
            fatalError("Error while trying to get core data")
        }
        do{
            try managedContext?.save()
            
        }catch let error as NSError{
            print("Can't save due to \(error)")
        }
        
    }


}
