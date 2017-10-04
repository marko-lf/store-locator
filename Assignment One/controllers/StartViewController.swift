//
//  StartViewController.swift
//  Assignment One
//
//  Created by Ilija Stevanovic on 9/26/17.
//  Copyright © 2017 Lotusflare. All rights reserved.
//

import UIKit
import CoreData

class StartViewController: UIViewController {
    
    
    @IBOutlet weak var fidgetSpinner: UIActivityIndicatorView!
    var mockDataEnabled = true
   
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if mockDataEnabled
        {
            fidgetSpinner.isHidden = false;
            fidgetSpinner.startAnimating()
            
            //fake the delay
           Timer.scheduledTimer(timeInterval: RNG(), target: self, selector: #selector(StartViewController.mockDataFetch), userInfo: nil, repeats: false)
            
           
            
            
          
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    
    // MARK: - functions
    
    
    @objc func mockDataFetch() {
    
        parseJsonStore()
        parseJsonStoreInfo()
        fidgetSpinner.stopAnimating()
        fidgetSpinner.isHidden = true;
        performSegue(withIdentifier: "segIdent", sender: nil)
       
    }
    
    func RNG() -> Double {
        
        return min( ((Double(arc4random()) / Double(UINT32_MAX))*1.2)+0.03 , 1.2)
        
    }
    
    

    
    
    func parseJsonStoreInfo() {
        var insertIntoCoreDataNeeded:Int = 0 // This is an indicator that tells us that the current store in the scope needs to be inserted into the database.
        
        let path = Bundle.main.path(forResource: "StoreInfo", ofType: "txt")
        let url = URL(fileURLWithPath: path!)
        
        do {
            
            let data = try Data(contentsOf: url)
            let json = try JSONSerialization.jsonObject(with: data, options:.mutableContainers)
            
            guard let array = json as? [AnyObject]  else { return }
            
            //--------------------Fetch the data through JSON, prepare for potential database write
            
            for store in array {
                guard let storeDict = store as? [String:Any]            else {return}
                
                guard let storeId = storeDict["storeID"] as? String else {return}
                guard let storeAddress =  storeDict["storeAddress"] as? String  else {return}
                guard let storePhone = storeDict["storePhone"] as? String else {return}
                guard let storeHoursDict = storeDict["storeHours"] as? [String:Any] else {return}
                      let storeHours = storeHoursDict.description 
                
                
            //--------------------Is this Store already in the database?
                
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext  //Fetching the current context
                
                
            let fetchRequest:NSFetchRequest<Store> = Store.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "storeID == %@", storeId)
            let fetchedResults = try context.fetch(fetchRequest)
            if  fetchedResults.count == 0   {  insertIntoCoreDataNeeded = 1 }
                
           //--------------------write to database
            if (insertIntoCoreDataNeeded == 1)
              {
                insertIntoCoreDataNeeded = 0
                //insert into StoreInfo
                   let newStoreInfo = NSEntityDescription.insertNewObject(forEntityName: "Store", into: context) as NSManagedObject
                    newStoreInfo.setValue(Int(storeId), forKey: "storeID")
                    newStoreInfo.setValue(storeAddress, forKey: "storeAddress")
                    newStoreInfo.setValue(storePhone, forKey: "storePhone")
                    newStoreInfo.setValue(storeHours, forKey: "storeHours")
            
                    try context.save()
                   //print("object saved.")
              }
            else {
               // print("object is cached.")
            }
        }
        
        }
    catch {
    print(error)
    }
    
}

    
    
    
    func parseJsonStore() {
        
        var insertIntoCoreDataNeeded:Int = 0 // This is an indicator that tells us that the current store in the scope needs to be inserted into the database.
        
        let path = Bundle.main.path(forResource: "Store", ofType: "txt")
        let url = URL(fileURLWithPath: path!)
       
        do {
            
            let data = try Data(contentsOf: url)
            let json = try JSONSerialization.jsonObject(with: data, options:.mutableContainers)
            
            guard let array = json as? [AnyObject]  else {return}
           
                //--------------------Fetch the data through JSON, prepare for potential database write
            
            for storeInfo in array {
                guard let storeInfoDict = storeInfo as? [String:Any]            else {return}
                
                guard let storeId = storeInfoDict["storeID"] as? String else {return}
                guard let storeName =  storeInfoDict["storeName"] as? String  else {return}
                guard let storeImage = storeInfoDict["storeImageUrl"] as? String else {return}
                guard let storeImageSize = storeInfoDict["storeImageSize"] as? String else {return}
                guard let storeLongitude = storeInfoDict["storeLongitude"] as? String else {return}
                guard let storeLatitude = storeInfoDict["storeLatitude"] as? String else {return}
                
                
                
                //--------------------Is this Store already in the database?
                
                let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext  //Fetching the current context
                
                
                let fetchRequest:NSFetchRequest<Store> = Store.fetchRequest()
                    fetchRequest.predicate = NSPredicate(format: "storeID == %@", storeId)
                let fetchedResults = try context.fetch(fetchRequest)
                if  fetchedResults.count == 0   {  insertIntoCoreDataNeeded = 1 }
                
                //does the image need recaching?
                if insertIntoCoreDataNeeded == 0 || insertIntoCoreDataNeeded == 1
                {
                let fetchRequest:NSFetchRequest<Image> = Image.fetchRequest()
                    fetchRequest.predicate = NSPredicate(format: "storeID == %@ and imageSize== %@", storeId,storeImageSize)
                    let fetchedResults = try context.fetch(fetchRequest)
                    if  fetchedResults.count == 0
                    {
                        let newImage = NSEntityDescription.insertNewObject(forEntityName: "Image", into: context) as NSManagedObject
                        newImage.setValue(Int(storeImageSize), forKey: "imageSize")
                        newImage.setValue(Int(storeId), forKey: "storeID")
                        //set the actual image from link
                        let url = URL(string: storeImage)
                        let data = try? Data(contentsOf: url!)
                        newImage.setValue(data, forKey: "imageFile")
                        try context.save()
                    }
                
                
                }
                //--------------------write to database
                
                if (insertIntoCoreDataNeeded == 1)
                {
                insertIntoCoreDataNeeded = 0
                //insert into Store
                let newStore = NSEntityDescription.insertNewObject(forEntityName: "Store", into: context) as NSManagedObject
                newStore.setValue(Int(storeId), forKey: "storeID")
                newStore.setValue(storeName, forKey: "storeName")
                newStore.setValue(Double(storeLongitude), forKey: "storeLongitude")
                newStore.setValue(Double(storeLatitude), forKey: "storeLatitude")
                    
                //insert into Image
                let fetchRequest:NSFetchRequest<Image> = Image.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "storeID == %@ and imageSize== %@", storeId,storeImageSize)
                if  fetchedResults.count == 0
                 {
                    let newImage = NSEntityDescription.insertNewObject(forEntityName: "Image", into: context) as NSManagedObject
                    newImage.setValue(Int(storeImageSize), forKey: "imageSize")
                    newImage.setValue(Int(storeId), forKey: "storeID")
                    //set the actual image from link
                    let url = URL(string: storeImage)
                    let data = try? Data(contentsOf: url!)
                    newImage.setValue(data, forKey: "imageFile")
                 }
                    
                
                
                //save the context
                try context.save()
                //print("object saved.")
                }
                    
                else {
                //print("object is cached.")
                }
                
                
            }
            
        }
        catch {
            print(error)
        }
        
    }
    //--------------------Print function for testing purposes
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
        }
        catch { print(error) }

}
  
    
    
    
    
}
