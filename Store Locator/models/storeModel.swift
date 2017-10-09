//
//  Stores.swift
//  Store Locator
//
//  Created by Ilija Stevanovic on 10/5/17.
//  Copyright © 2017 Lotusflare. All rights reserved.
//

import Foundation
import CoreLocation
import CoreData
import UIKit


public class storeModel: CLLocationManager, CLLocationManagerDelegate
{
    
    public var mockDataMode:Int?
    var locationManager = CLLocationManager()
    //-----------------------

    var distanceDict:[Int16:String]    //key ->> store ID; contains distance from user
    {
        get
        {
        
            var distDict:[Int16:String] = [ : ]
            
            for store in stores
            {
              //to check -> latitude and longitude in core data might be switched
              let storeLoc = CLLocation(latitude: store.storeLongitude, longitude: store.storeLatitude)
                let userLoc =  locationManager.location!
              let distance = storeLoc.distance(from: userLoc)
                 if (distance <= 500.0)
                 {
                    distDict.updateValue(String(Int(distance)) + "meters", forKey: store.storeID)
                 }
                 else
                 {
                    distDict.updateValue(String(Int(distance/1000)) + "km", forKey: store.storeID)
                 }
                
            }
            return distDict
        }
       
    }
    
    
    //-----------------------
    var stores:[Store]    // contains: all the information about the store from core data
    {
        get {
          
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext  //Fetching the current context
            let fetchRequest:NSFetchRequest<Store> = Store.fetchRequest()
            do
            {
                let fetchedResults = try  context.fetch(fetchRequest)
                return fetchedResults
            }
            catch
            {
                print(error)
                return []
            }
        }
     

    }
    //------------------------------------------------------------------------------------------------
    var images:[Int16:NSData]?  // contains: all the images from the core data
    {
        get
        {
            var imageDict:[Int16:NSData] = [:]
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext  //Fetching the current context
            let fetchRequest:NSFetchRequest<Image> = Image.fetchRequest()
            do
            {
                let fetchedResults = try  context.fetch(fetchRequest)
                for result in fetchedResults
                {
                    imageDict.updateValue(result.imageFile!, forKey: Int16(result.storeID))
                }
                return imageDict
            }
            catch
            {
                print(error)
                return [:]
            }
        }
    }
    //------------------------------------------------------------------------------------------------
    public func storeInfoFetchRequest(_ storeID:Int16)
    {
        var urlToStoreInfo:URL!
        if mockDataMode == 1
        {
        let pathToStoreInfo = Bundle.main.path(forResource: "StoreInfo", ofType: "txt")
             urlToStoreInfo = URL(fileURLWithPath: pathToStoreInfo!)
        }
        else
        {
             let urlStringToStore = "https://acko.lotusflare.com/storeInfo\?storeID\=" + String(storeID)
             urlToStoreInfo = URL(string: urlStringToStore)
        }
        
        do
        {
            let dataStoreInfo = try Data(contentsOf: urlToStoreInfo)
            let jsonStoreInfo = try JSONSerialization.jsonObject(with: dataStoreInfo, options:.mutableContainers)
            guard let arrayStoreInfo = jsonStoreInfo as? [AnyObject]  else { return }
            for storeInfo in arrayStoreInfo
            {
                guard let storeInfoDict = storeInfo as? [String:Any] else {return}
                guard let storeInfoID = storeInfoDict["storeID"] as? String else {return}
                if Int16(storeInfoID) == storeID
                {
                    guard let storeInfoHours = storeInfoDict["storeHours"] as? [String:String] else {return}
                    guard let storeInfoPhone = storeInfoDict["storePhone"] as? String else {return}
                    guard let storeInfoAddress = storeInfoDict["storeAddress"] as? String else {return}
                    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext  //Fetching the current context
                    let fetchRequest:NSFetchRequest<Store> = Store.fetchRequest()
                    fetchRequest.predicate = NSPredicate(format: "storeID == %@", storeInfoID)
                    let fetchedResults = try context.fetch(fetchRequest)
                    if  fetchedResults.count > 0
                    {
                        var workHrs=""
                        for hours in storeInfoHours
                        {
                            workHrs.append(hours.key + "-" + hours.value)
                            workHrs.append("\n")
                        }
                        workHrs = String(workHrs.dropLast())
                        
                        fetchedResults[0].setValue(workHrs, forKey: "storeHours")
                        fetchedResults[0].setValue(storeInfoAddress, forKey:"storeAddress")
                        fetchedResults[0].setValue(storeInfoPhone, forKey: "storePhone")
                        try context.save()
                    }
                }
            }
        } catch {print(error)}
    }
   
  //------------------------------------------------------------------------------------------------
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
        {
             let userLocation:CLLocation = locations.last!
            // print(userLocation)
        }
  //------------------------------------------------------------------------------------------------
    func storeAPI()
    {
       var urlToStore:URL!
       if (mockDataMode == 1)
       {
        let pathToStore = Bundle.main.path(forResource: "Store", ofType: "txt")
        urlToStore = URL(fileURLWithPath: pathToStore!)
       }
        else
       {
          urlToStore = URL(string: "https://acko.lotusflare.com/storeList")
       }
        do
        {
            let dataStore = try Data(contentsOf: urlToStore)
            let jsonStore = try JSONSerialization.jsonObject(with: dataStore, options:.mutableContainers)
            guard let arrayStore = jsonStore as? [AnyObject]  else { return }
            for store in arrayStore
            {
                guard let storeDict = store as? [String:Any]    else  {return}
                
                guard let storeId = storeDict["storeID"] as? String else {return}
                guard let storeName =  storeDict["storeName"] as? String  else {return}
                guard let storeLongitude = storeDict["storeLongitude"] as? String else {return}
                guard let storeLatitude = storeDict["storeLatitude"] as? String else {return}
                guard let storeImage = storeDict["storeImageUrl"] as? String else {return}
                guard let storeImageSize = storeDict["storeImageSize"] as? String else {return}
                //--------is this store in the database?
                let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext  //Fetching the current context
                let fetchRequest:NSFetchRequest<Store> = Store.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "storeID == %@", storeId)
                let fetchedResults = try context.fetch(fetchRequest)
                
                if (fetchedResults.count == 0)
                {
                    let newStore = NSEntityDescription.insertNewObject(forEntityName: "Store", into: context) as NSManagedObject
                    newStore.setValue(Int(storeId),  forKey: "storeID")
                    newStore.setValue(storeName, forKey: "storeName")
                    newStore.setValue(Double(storeLongitude), forKey: "storeLongitude")
                    newStore.setValue(Double(storeLatitude), forKey: "storeLatitude")
                    
                    
                    let newImage = NSEntityDescription.insertNewObject(forEntityName: "Image", into: context) as NSManagedObject
                    newImage.setValue(Int(storeImageSize), forKey: "imageSize")
                    newImage.setValue(Int(storeId), forKey:"storeID")
                    let imageURL = URL(string: storeImage)!
                    let imageData = try Data(contentsOf: imageURL)
                    newImage.setValue(imageData, forKey: "imageFile")
                    
                    try context.save()
                }
                
                if (fetchedResults.count == 1)
                {
                    
                    //TO INSERT: WHEN SOMETHING CHANGES -> UPDATE IT IN THE CORE DATA
                    
                }
                
            }
        }
        catch { print(error) }
    }
    //------------------------------------------------------------------------------------------------
    func storeInfoAPI(_ storeIDForDisplay:Int) -> [String:String]
    {
       var returnDict:[String:String] = [:]
       for store in stores
       {
        if store.storeID == Int16(storeIDForDisplay)
        {
            if store.storeHours != nil {  returnDict.updateValue(store.storeHours!, forKey: "storeHours") }
            if store.storePhone != nil {  returnDict.updateValue(store.storePhone!, forKey: "storePhone") }
            if store.storeAddress != nil {  returnDict.updateValue(store.storeAddress!, forKey: "storePhone") }
            if returnDict.count == 3 { return returnDict }
        }
        
        //potential update of info:
        
        var urlToStore:URL!
        if (mockDataMode == 1)
        {
        let pathToStore = Bundle.main.path(forResource: "Store", ofType: "txt")
            urlToStore = URL(fileURLWithPath: pathToStore!)
        }
        else
        {
            let pathToStore = Bundle.main.path(forResource: "Store", ofType: "txt")
            urlToStore = URL(fileURLWithPath: pathToStore!)
        }
        
        do
        {
            let dataStore = try Data(contentsOf: urlToStore)
            let jsonStore = try JSONSerialization.jsonObject(with: dataStore, options:.mutableContainers)
            
            guard let arrayStore = jsonStore as? [AnyObject]  else { return returnDict}
            for store in arrayStore
            {
                guard let storeDict = store as? [String:Any]    else  {return returnDict}
            }
            
        }
        catch {print(error)}
        
        
        
       }
      
        return returnDict
    }
     //------------------------------------------------------------------------------------------------
    public func printDatabaseContents()
    {
        do
        {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext  //Fetching the current context
            let fetchRequest:NSFetchRequest<Store> = Store.fetchRequest()
            
            let fetchedResults = try context.fetch(fetchRequest)
            for fetched in fetchedResults{
                print(fetched.storeName!)
            }
            print("---------------------------------------")
            let fetchRequest2:NSFetchRequest<Image> = Image.fetchRequest()
            
            let fetchedResults2 = try context.fetch(fetchRequest2)
            for fetched in fetchedResults2{
                print(fetched.imageSize)
            }
            print("---------------------------------------")
            
        }
        catch { print(error) }
        
    }
    //------------------------------------------------------------------------------------------------
    func RNG() -> Double
    {    //Generates a random number between 0.03 and 1.2
        
        return min( ((Double(arc4random()) / Double(UINT32_MAX))*1.2)+0.03 , 1.2)
        
    }
    //------------------------------------------------------------------------------------------------
    func callTheStore(_ phoneNumber:String)
    {
        var formatedNumber:String = phoneNumber
      formatedNumber = formatedNumber.replacingOccurrences(of: "(", with: "")
      formatedNumber =   formatedNumber.replacingOccurrences(of: ")", with: "")
      formatedNumber =  formatedNumber.replacingOccurrences(of: " ", with: "")
      formatedNumber =   formatedNumber.replacingOccurrences(of: "-", with: "")
        if let phoneCallURL = URL(string: "tel://\(formatedNumber)") {
            
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                application.open(phoneCallURL, options: [:], completionHandler: nil)
            }
        }
    }
    //------------------------------------------------------------------------------------------------
}








