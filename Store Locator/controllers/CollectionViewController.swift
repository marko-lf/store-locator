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
import NVActivityIndicatorView








private let reuseIdentifier = "Cell"

class CollectionViewController: UICollectionViewController, NVActivityIndicatorViewable
{
    
    
    public var storeModule = StoreModel()
    public var locationModule = LocationModel()
    public var miscFuncionalities = Misc()
    @IBOutlet var colView: UICollectionView!
    public var reachability = Reachability()
    
    var enableUserInteraction:Bool = true
    {
        didSet(newValue)
        {
            if (newValue == true) {self.view.isUserInteractionEnabled = true }
            if (newValue == false) {self.view.isUserInteractionEnabled = false}
        }
    }
    
    var fidgetSpinner:NVActivityIndicatorView?
    
    //--------------------------------------------------------------------------------------------------
    lazy var refreshControl: UIRefreshControl =
        {
            
            let refreshControl = UIRefreshControl()
            
            refreshControl.addTarget(self, action:
                #selector(CollectionViewController.handleRefresh(_:)),
                                     for: UIControlEvents.valueChanged)
            
            
            refreshControl.isHidden = true
            refreshControl.tintColor = UIColor.black
            refreshControl.layer.zPosition = -1;
            
            
            return refreshControl
    }()
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl)
    {
        if (!Reachability.isConnectedToNetwork() && self.storeModule.mockDataMode == false)
        {
            miscFuncionalities.noDataAvailable(sender: self)
            refreshControl.endRefreshing()
            colView.contentOffset = .init()
            return
        }
        self.fidgetSpinner?.startAnimating()
        refreshControl.beginRefreshing()
        
        self.view.isUserInteractionEnabled = false
        storeModule.deleteAllData()
        
        storeModule.storeCoreDataInit()
        
        refreshControl.endRefreshing()
        
        
    }
    //-------------------------------------------------------------------------------------------------
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let fidgetSpinnerHolder = CGRect(x: colView.center.x - 25, y: colView.center.y, width: CGFloat(50), height: CGFloat(50))
        fidgetSpinner = NVActivityIndicatorView(frame: fidgetSpinnerHolder, type:NVActivityIndicatorType.ballClipRotatePulse, color: UIColor.white,  padding: CGFloat(0))
        
        self.view.addSubview(fidgetSpinner!)
        
        fidgetSpinner?.startAnimating()
        enableUserInteraction = false
        
        storeModule.storeModelDelegate = self
        locationModule.locationManager.delegate = self.locationModule
        locationModule.locationManager.requestWhenInUseAuthorization()
        locationModule.locationManager.startUpdatingLocation()
        locationModule.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        
        storeModule.storeCoreDataInit()
        
        self.colView.addSubview(self.refreshControl)
        if (!Reachability.isConnectedToNetwork() && self.storeModule.mockDataMode == false)
        {
            miscFuncionalities.noDataAvailable(sender: self)
            fidgetSpinner?.stopAnimating()
            enableUserInteraction = true
        }
        enableUserInteraction = true
    }
    //------------------------------------------------------------------------------------------------
    
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
        
        if (storeModule.stores.count != 0)
        {
            cell.storeName.text = storeModule.stores[indexPath.row].storeName
            
            cell.storeImage.image = UIImage(data: storeModule.images![(storeModule.stores[indexPath.row].storeID)]! as Data)
            cell.segueButton.tag = Int(storeModule.stores[indexPath.row].storeID)
            
            if (locationModule.location != nil)
            {
                let userLoc = locationModule.locationManager.location!
                let storeLoc = CLLocation(latitude: storeModule.stores[indexPath.row].storeLongitude, longitude: storeModule.stores[indexPath.row].storeLatitude)
                cell.storeDistance.isHidden = false
                cell.storeDistance.text = miscFuncionalities.calculateDistance(location1: userLoc, location2: storeLoc)
                
                cell.distanceActivityIndicator.isHidden = true
            }
        }
        else
        {
            cell.storeDistance.isHidden = true
            cell.distanceActivityIndicator.isHidden = false
            cell.distanceActivityIndicator.startAnimating()
        }
        
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.white.cgColor
        cell.bringSubview(toFront: cell.storeName)
        return cell
    }
    //------------------------------------------------------------------------------------------------
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if (!Reachability.isConnectedToNetwork() && self.storeModule.mockDataMode == false)
        {
            miscFuncionalities.noDataAvailable(sender: self)
        }
        
        if segue.identifier == "toStoreInfo"
        {
            
            let storeVC = segue.destination as? StoreViewController
            storeModule.storeInfoFetch(forStore:  ((sender as? UIButton)?.tag)!)
            storeVC?.storeID = (sender as? UIButton)?.tag
            storeModule.storeInfoModelDelegate = storeVC!
            storeVC?.storeModule = self.storeModule
            storeVC?.locationModule = self.locationModule
            
            
        }
    }
    //------------------------------------------------------------------------------------------------
}

extension CollectionViewController: NetworkModelDelegate
{
    func showError(withMessage:String)
    {
        let alert = UIAlertController(title: "Error!", message: withMessage, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}




extension CollectionViewController: StoreModelDelegate
{
    func dataFetchingended()
    {
        colView.reloadData()
        enableUserInteraction = true
        fidgetSpinner?.stopAnimating()
    }
    
    func didLoadData()
    {
        colView.reloadData()
    }
    
}






