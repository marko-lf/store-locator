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
import Alamofire


public class storeModel
{
  
    public var mockDataMode:Bool = false  // false -> real data; true -> mock data;
    var storeModelDelegate : storeModelDelegate?

    //------------------------------------------------------------------------------------------------
    var stores:[Store]    // contains: all the information about the store cached in core data
    {
        get
        {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
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
      //store info fetch goes here

  //------------------------------------------------------------------------------------------------

    func updateCoreDataWithJSON(_ jsonFile:Data)
        {
            do
            {
                let json = try? JSONSerialization.jsonObject(with: jsonFile, options: [])
                guard let arrayStore = json as? [AnyObject]  else { return }
                for store in arrayStore
            {
                
                guard let storeDict = store as? [String:Any]    else {return}

                guard let storeId = storeDict["storeID"] as? String else {return}
                guard let storeName =  storeDict["storeName"] as? String  else {return}
                guard let storeLongitude = storeDict["storeLongitude"] as? String else {return}
                guard let storeLatitude = storeDict["storeLatitude"] as? String else {return}
                guard let storeImage = storeDict["storeImageUrl"] as? String else {return}
                guard let storeImageSize = storeDict["storeImageSize"] as? Int else {return}
               
                let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext  //Fetching the current context
                let fetchRequest:NSFetchRequest<Store> = Store.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "storeID == %@", storeId )
                let fetchedResults = try context.fetch(fetchRequest)
                //--------is this store in the database?
                if (fetchedResults.count == 0)
                {
                    storeModelDelegate?.disableUserInteraction()
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
                
                storeModelDelegate?.reloadDataTable()
                storeModelDelegate?.enableUserInteraction()
            }
            
            catch { print(error) }
        }
          
    
    
    //------------------------------------------------------------------------------------------------
    public func printDatabaseContents() //Prints the contents of the core data in the console -> for testing purposes
    {
        do
        {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let fetchRequest:NSFetchRequest<Store> = Store.fetchRequest()
            
            let fetchedResults = try context.fetch(fetchRequest)
            for fetched in fetchedResults
            {
                print(fetched.storeName!)
            }
            print("---------------------------------------")
            let fetchRequest2:NSFetchRequest<Image> = Image.fetchRequest()
            
            let fetchedResults2 = try context.fetch(fetchRequest2)
            for fetched in fetchedResults2
            {
                print(fetched.imageSize)
            }
            print("---------------------------------------")
            
        }
        catch { print(error) }
        
    }
    //------------------------------------------------------------------------------------------------
    func RNG() -> Double  //Generates a random number between 0.03 and 1.2
    {
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
        if let phoneCallURL = URL(string: "tel://\(formatedNumber)")
        {
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL))
            {
                application.open(phoneCallURL, options: [:], completionHandler: nil)
            }
        }
    }
    //------------------------------------------------------------------------------------------------
    func deleteAllData() //Drops all the contents from the core data
    {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext  //Fetching the current context
        let ReqVar = NSFetchRequest<Store>(entityName: "Store")
        let DelAllReqVar = NSBatchDeleteRequest(fetchRequest: ReqVar as! NSFetchRequest<NSFetchRequestResult>)
        let ReqVar2 = NSFetchRequest<Image>(entityName: "Image")
        let DelAllReqVar2 = NSBatchDeleteRequest(fetchRequest: ReqVar2 as! NSFetchRequest<NSFetchRequestResult>)
        do
        {
         try context.execute(DelAllReqVar)
         try context.execute(DelAllReqVar2)
         printDatabaseContents()
        }
        catch { print(error) }
    }
    
}








