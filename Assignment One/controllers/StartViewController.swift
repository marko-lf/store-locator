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
    
    
    var mockDataEnabled = true
   

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if mockDataEnabled
        {
        parseJsonFileAndUpdateDatabaseFromLocalFile()
        printDatabaseContents()
           
        }
        
        else
        {
          return //TBD
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
    
    func parseJsonFileAndUpdateDatabaseFromLocalFile() {
        
        var insertIntoCoreDataNeeded:Int = 0 // This is an indicator that tells us that the current store in the scope needs to be inserted into the database.
        
        let path = Bundle.main.path(forResource: "Store", ofType: "txt")
        let url = URL(fileURLWithPath: path!)
       
        do {
            
            let data = try Data(contentsOf: url)
            let json = try JSONSerialization.jsonObject(with: data, options:.mutableContainers)
            
            guard let array = json as? [AnyObject]  else {return}
           
                //--------------------Fetch the data through JSON, prepare for potential database write
            
            for store in array {
                guard let storeDict = store as? [String:Any]            else {return}
                
                guard let storeId = storeDict["storeID"] as? String else {return}
                guard let storeName =  storeDict["storeName"] as? String  else {return}
                guard let storeImage = storeDict["storeImageUrl"] as? String else {return}
                guard let storeImageSize = storeDict["storeImageSize"] as? String else {return}
                guard let storeLongitude = storeDict["storeLongitude"] as? String else {return}
                guard let storeLatitude = storeDict["storeLatitude"] as? String else {return}
                
                
                
                //--------------------Is this Store already in the database?
                
                let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext  //Fetching the current context
                
                
                let fetchRequest:NSFetchRequest<Store> = Store.fetchRequest()
                    fetchRequest.predicate = NSPredicate(format: "storeID == %@", storeId)
                let fetchedResults = try context.fetch(fetchRequest)
                if  fetchedResults.count == 0   {  insertIntoCoreDataNeeded = 1 }
                
                //does the image need recaching?
                if insertIntoCoreDataNeeded == 0
                {
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
                        try context.save()
                    }
                
                
                }
                //--------------------Fetch the data through JSON, write to database
                
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
                print("object saved.")
                }
                    
                else {
                print("object is cached.")
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
                print(fetched.imageFile)
            }
        }
        catch { print(error) }

}
  
    
    
    
    
}
