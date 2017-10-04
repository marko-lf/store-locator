//
//  StartViewControllerBetterOne.swift
//  Assignment One
//
//  Created by Ilija Stevanovic on 9/28/17.
//  Copyright © 2017 Lotusflare. All rights reserved.
//

import UIKit
import CoreData

class StartViewControllerBetterOne: UIViewController {
    
    @IBOutlet weak var fidgetSpinner: UIActivityIndicatorView!
    
    var mockDataEnabled = true

    override func viewDidLoad() {
        super.viewDidLoad()

        if mockDataEnabled
        {
            
            fidgetSpinner.isHidden = false;
            fidgetSpinner.startAnimating()
            
            //fake the delay
            Timer.scheduledTimer(timeInterval: RNG(), target: self, selector: #selector(StartViewControllerBetterOne.parseMockData), userInfo: nil, repeats: false)
           // fidgetSpinner.stopAnimating()
          
        }
        else
        {
           printDatabaseContents()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    //MARK: Functions:
    
    @objc func parseMockData()
    {
    
      let pathToStore = Bundle.main.path(forResource: "Store", ofType: "txt")
      let pathToStoreInfo = Bundle.main.path(forResource: "StoreInfo", ofType: "txt")
      
      let urlToStore = URL(fileURLWithPath: pathToStore!)
      let urlToStoreInfo = URL(fileURLWithPath: pathToStoreInfo!)
      
      do
        {
          let dataStore = try Data(contentsOf: urlToStore)
          let jsonStore = try JSONSerialization.jsonObject(with: dataStore, options:.mutableContainers)
          let dataStoreInfo = try Data(contentsOf: urlToStoreInfo)
          let jsonStoreInfo = try JSONSerialization.jsonObject(with: dataStoreInfo, options:.mutableContainers)
          
          guard let arrayStore = jsonStore as? [AnyObject]  else { return }
          guard let arrayStoreInfo = jsonStoreInfo as? [AnyObject] else { return }
          
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
            
          }
          for storeInfo in arrayStoreInfo
          {
            guard let storeInfoDict = storeInfo as? [String:Any]    else  {return}
            
             guard let storeId = storeInfoDict["storeID"] as? String else {return}
             guard let storeAddress =  storeInfoDict["storeAddress"] as? String  else {return}
            // guard let storeImage = storeInfoDict["storeImageUrl"] as? String else {return}
            // guard let storeImageSize = storeInfoDict["storeImageSize"] as? String else {return}
             guard let storePhone = storeInfoDict["storePhone"] as? String else {return}
             guard let storeHoursDict = storeInfoDict["storeHours"] as? [String:Any] else {return}
                   let storeHours = storeHoursDict.description
            
             let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext  //Fetching the current context
             let fetchRequest:NSFetchRequest<StoreInfo> = StoreInfo.fetchRequest()
             fetchRequest.predicate = NSPredicate(format: "storeID == %@", storeId)
             let fetchedResults = try context.fetch(fetchRequest)
             if (fetchedResults.count == 0)
             {
                let newStoreInfo = NSEntityDescription.insertNewObject(forEntityName: "StoreInfo", into: context) as NSManagedObject
                    newStoreInfo.setValue(Int(storeId),  forKey: "storeID")
                    newStoreInfo.setValue(storeHours,  forKey: "storeHours")
                    newStoreInfo.setValue(storePhone, forKey: "storePhone")
                    newStoreInfo.setValue(storeAddress, forKey: "storeAddress")
                    try context.save()
             }
            
             performSegue(withIdentifier: "segIdent", sender: nil)
            
          }
          
      
            
            
        }
          catch { print(error) }
        
    }
    
    func RNG() -> Double {    //Generates a random number between 0.03 and 1.2
        
        return min( ((Double(arc4random()) / Double(UINT32_MAX))*1.2)+0.03 , 1.2)
        
    }
    
    private func printDatabaseContents() {
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
    

    

}
