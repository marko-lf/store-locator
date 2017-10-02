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
    
   let manager = CLLocationManager()
   var userLoc = CLLocation(latitude: 0, longitude: 0)
   //var selectedStoreID :Int?
    
   //vars for passing off to storeinfo
    var distance = ""
    var storeLoc : CLLocationCoordinate2D?

    

    
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
                //print(fetchedResults.count)
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
    
    //---------------- MARK: LOCATION RELATED STUFF
    

 

    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
       
     
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
    
        //distance calc
        let storeLatitude = stores[indexPath.row].storeLatitude
        let storeLongitude = stores[indexPath.row].storeLongitude
        let storeLocation = CLLocation(latitude: storeLongitude, longitude: storeLatitude)
            storeLoc = CLLocationCoordinate2D(latitude: storeLongitude, longitude: storeLatitude )
        let distanceInMeters = storeLocation.distance(from: userLoc)
         cell.segueButton.tag = Int(stores[indexPath.row].storeID)
        //
    

        if(distanceInMeters <= 500)
        {
          cell.storeDistance.text = String(Int(round(distanceInMeters))) + "m away"
          distance = String(Int(round(distanceInMeters))) + "m away"
        }
        else
        {
         cell.storeDistance.text = String(Int(round(distanceInMeters/1000))) + "km away"
         distance = String(Int(round(distanceInMeters/1000))) + "km away"
        }
        //
    
        //Prodavnica model update
    
   
    
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
    
  
    
    @IBAction func performSegway(_ sender: Any) {
        
        
    }
    
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toStoreDetails") {
            let storeVC = segue.destination as? StoreViewController
            storeVC?.storeID = (sender as? UIButton)?.tag
            storeVC?.distanceString = distance
            storeVC?.storeLoc = storeLoc
        }
    }
    
 
    
    
    
    
}


