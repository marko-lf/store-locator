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
import Foundation







private let reuseIdentifier = "Cell"

class CollectionViewController: UICollectionViewController, NVActivityIndicatorViewable, UITextFieldDelegate
{
    
    
    public var storeModule = StoreModel()
    public var locationModule = LocationModel()
    public var miscFuncionalities = Misc()
    @IBOutlet var colView: UICollectionView!
    public var reachability = Reachability()
    
    @IBOutlet weak var searchButton: UIBarButtonItem!
    @IBOutlet weak var closeSearchButton: UIBarButtonItem!
    @IBOutlet weak var searchTextField: UITextField!
    
    
    var storesForDisplay : [Store]? {
        didSet {
            colView.reloadData()
        }
    }
    
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
    
    @IBAction func searchTermsChanged(_ sender: Any) {
        
        storesForDisplay = storeModule.stores
        
        
        let searchTerms = searchTextField.text
        if searchTerms != ""
        {
            var i = 0
            while (i < storesForDisplay!.count)
            {
                if (storesForDisplay![i].storeName?.containsIgnoringCase(searchTerms!))!
                {
                   
                    i = i + 1
                }
                else
                {
                
                    storesForDisplay!.remove(at: i)
                }
            }
        }
        
        
    }
    
    @IBAction func searchButtonPressed(_ sender: Any) {
        storesForDisplay = storeModule.stores
        searchButton.isEnabled = false
        searchButton.tintColor = UIColor.black
        searchTextField.text = nil
        closeSearchButton.isEnabled = true
        closeSearchButton.tintColor = UIColor.white
        searchTextField.isEnabled = true
        searchTextField.backgroundColor = UIColor.white
        searchTextField.tintColor = UIColor.black
        searchTextField.frame.size.width = UIScreen.main.bounds.width * 5/7
        searchTextField.center.x = self.view.center.x
        self.navigationItem.title = ""
        searchTextField.becomeFirstResponder()
        
    }
    
    @IBAction func closeSearchButtonPressed(_ sender: Any) {
        searchButton.isEnabled = true
        self.navigationItem.title = "STORES"
        closeSearchButton.tintColor = UIColor.black
        searchTextField.frame.size.width = 0
        closeSearchButton.isEnabled = false
        searchButton.tintColor = UIColor.white
        searchTextField.isEnabled = false
        searchTextField.backgroundColor = UIColor.black
        searchTextField.tintColor = UIColor.black
        searchTextField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == searchTextField
        {
            closeSearchButtonPressed(self)
            print("ok")
        }
        return true
    }
    

    //-------------------------------------------------------------------------------------------------
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.searchTextField.delegate = self
        closeSearchButtonPressed(self)
        let fidgetSpinnerHolder = CGRect(x: colView.center.x - 25, y: colView.center.y, width: CGFloat(50), height: CGFloat(50))
        fidgetSpinner = NVActivityIndicatorView(frame: fidgetSpinnerHolder, type:NVActivityIndicatorType.ballClipRotatePulse, color: UIColor.white,  padding: CGFloat(0))
        storesForDisplay = storeModule.stores
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
        return (storesForDisplay?.count)!
    }
    //------------------------------------------------------------------------------------------------
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! StoreCollectionViewCell
        
        if (storesForDisplay?.count != 0)
        {
            cell.storeName.text = storesForDisplay?[indexPath.row].storeName
            
            if storeModule.images?.count != 0
            {
                cell.storeImage.image = UIImage(data: storeModule.images![(storesForDisplay?[indexPath.row].storeID)!]! as Data)
            }
            cell.segueButton.tag = Int((storesForDisplay?[indexPath.row].storeID)!)
            
            if (locationModule.location != nil)
            {
                let userLoc = locationModule.locationManager.location!
                let storeLoc = CLLocation(latitude: (storesForDisplay?[indexPath.row].storeLongitude)!, longitude: (storesForDisplay?[indexPath.row].storeLatitude)!)
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
        storesForDisplay = storeModule.stores
        colView.reloadData()
        enableUserInteraction = true
        fidgetSpinner?.stopAnimating()
    }
    
    func didLoadData()
    {
        colView.reloadData()
    }
    
}

extension String {
    
    func contains(_ find: String) -> Bool{
        return self.range(of: find) != nil
    }
    
    func containsIgnoringCase(_ find: String) -> Bool{
        return self.range(of: find, options: .caseInsensitive) != nil
    }
}






