//
//  CollectionViewController.swift
//  Assignment One
//
//  Created by Ilija Stevanovic on 9/27/17.
//  Copyright © 2017 Lotusflare. All rights reserved.
//

import UIKit
import CoreData
import MapKit
import CoreLocation

private let reuseIdentifier = "Cell"


class CollectionViewController: UICollectionViewController,  CLLocationManagerDelegate {
    
    
    var locationManager: CLLocationManager!
  
    
   var numOfStores:Int {
    
    get {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext  //Fetching the current context
    let fetchRequest:NSFetchRequest<Store> = Store.fetchRequest()
        
        do {
            let fetchedResults = try  context.fetch(fetchRequest)
            return fetchedResults.count }
        catch {print(error)
            return 0}
    }
    }
    
    var stores:[Store] {
        get {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext  //Fetching the current context
            let fetchRequest:NSFetchRequest<Store> = Store.fetchRequest()
            do {
                 let fetchedResults = try  context.fetch(fetchRequest)
                 return fetchedResults
            }
            catch {print(error)
                return []
            }
        }
    }
    
    var storeImages:[Image] {
        get {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext  //Fetching the current context
            let fetchRequest:NSFetchRequest<Image> = Image.fetchRequest()
            do {
                let fetchedResults = try  context.fetch(fetchRequest)
                print(fetchedResults.count)
                return fetchedResults
              
            }
            catch {print(error)
                return []
            }
        }
    }
    
    var images:[Image] {
        get {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext  //Fetching the current context
            let fetchRequest:NSFetchRequest<Image> = Image.fetchRequest()
            do {
                let fetchedResults = try  context.fetch(fetchRequest)
                return fetchedResults
            }
            catch {print(error)
                return []
            }
        }
    }
    
  
 

    
    

    override func viewDidLoad() {
        super.viewDidLoad()
       
       
       
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.

}
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
   override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numOfStores
    }
    
   override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! StoreCollectionViewCell
        cell.storeName.text = stores[indexPath.row].storeName
    for image in storeImages {
        
        if image.storeID == stores[indexPath.row].storeID
        {
            
            let imageData = image.imageFile
            cell.storeImage.image = UIImage(data: (imageData! as Data))
            //distance calculation
            
        }
    }
    
  
    
        return cell
    }
    
    
    
    
}


