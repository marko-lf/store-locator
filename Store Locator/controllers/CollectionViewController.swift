//
//  CollectionViewController.swift
//  Store Locator
//
//  Created by Ilija Stevanovic on 10/5/17.
//  Copyright © 2017 Lotusflare. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation


protocol storeModelDelegate {
    func reloadData()
    func disableUserInteraction()
    func enableUserInteraction()
}

protocol locationModelDelegate
{
    func reloadData()
}


private let reuseIdentifier = "Cell"

class CollectionViewController: UICollectionViewController, storeModelDelegate, locationModelDelegate
{
   

    public var netModule =  NetworkModel()
    public var storeModule = StoreModel()
    public var locationModule = LocationModel()
    @IBOutlet var colView: UICollectionView!
  
    
   
  
    
    //--------------------------------------------------------------------------------------------------
    lazy var refreshControl: UIRefreshControl =
    {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(CollectionViewController.handleRefresh(_:)),
                                 for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor.white
        refreshControl.layer.zPosition = -1;
        return refreshControl
    }()
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl)
    {
       
        storeModule.deleteAllData()
        netModule.fetchJsonStoreData(usingMockData: storeModule.mockDataMode)
        locationModule.initLoc = 0  //refresh will be provided using the delegate called from locationModel
        
        refreshControl.endRefreshing()
    }
    //-------------------------------------------------------------------------------------------------
    override func viewDidLoad()
    {
        super.viewDidLoad()
       
        storeModule.storeModelDelegate = self
        locationModule.locModuleDelegate = self
        locationModule.locationManager.delegate = self.locationModule
        locationModule.locationManager.requestWhenInUseAuthorization()
        locationModule.locationManager.startUpdatingLocation()
        locationModule.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationModule.storeModel = self.storeModule
        netModule.storeModel = self.storeModule
        netModule.fetchJsonStoreData(usingMockData: storeModule.mockDataMode)
        self.colView.addSubview(self.refreshControl)
    }
     //------------------------------------------------------------------------------------------------
    @IBAction func segueToStoreInfoView(_ sender: UIButton)
    {
        print(sender.tag)
        performSegue(withIdentifier: "toStoreInfo", sender: self)
    }
    //-------------------------------------------------------------------------------------------------
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    //------------------------------------------------------------------------------------------------
    override func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 1
    }
    //------------------------------------------------------------------------------------------------
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return storeModule.stores.count
    }
    //------------------------------------------------------------------------------------------------
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! StoreCollectionViewCell
            cell.storeName.text=""
       
        if (storeModule.stores.count != 0)
        {
        cell.storeName.text = storeModule.stores[indexPath.row].storeName
        cell.storeImage.image = UIImage(data: storeModule.images![(storeModule.stores[indexPath.row].storeID)]! as Data)
        cell.segueButton.tag = Int(storeModule.stores[indexPath.row].storeID)
        
            if (locationModule.location != nil)
            {
            cell.storeDistance.isHidden = false
            cell.storeDistance.text = locationModule.distanceDict[(storeModule.stores[indexPath.row].storeID)]
            cell.distanceActivityIndicator.isHidden = true
            }
        }
        else
        {
           cell.storeDistance.isHidden = true
           cell.distanceActivityIndicator.isHidden = false
           cell.distanceActivityIndicator.startAnimating()
        }
        
        return cell
        }
    
    //------------------------------------------------------------------------------------------------
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "toStoreDetails"
        {
            let storeVC = segue.destination as? StoreViewController
                storeVC?.storeID = (sender as? UIButton)?.tag
            netModule.fetchJsonStoreInfoData(usingMockData: storeModule.mockDataMode, idOfTheStore:  ((sender as? UIButton)?.tag)! )
                storeVC?.storeModule = self.storeModule
                storeVC?.locationModule = self.locationModule
        }
    }
   //------------------------------------------------------------------------------------------------
    func reloadData()
    {
        colView.reloadData()
        print("refresh was called")
        
    }
   //------------------------------------------------------------------------------------------------
    func enableUserInteraction()
    {
        self.view.isUserInteractionEnabled = true
    }
    //------------------------------------------------------------------------------------------------
    func disableUserInteraction()
    {
        self.view.isUserInteractionEnabled = false
    }
    //------------------------------------------------------------------------------------------------
  

}
