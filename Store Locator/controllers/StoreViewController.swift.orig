//
//  StoreViewController.swift
//  Store Locator
//
//  Created by Ilija Stevanovic on 10/6/17.
//  Copyright © 2017 Lotusflare. All rights reserved.
//

import UIKit
import MapKit
import NVActivityIndicatorView




class StoreViewController: UIViewController, NVActivityIndicatorViewable {
    

    
    public var storeModule:StoreModel?
    public var locationModule:LocationModel?
    public var storeID:Int?
    public var fidgetSpinner:NVActivityIndicatorView?
    var misc = Misc()
    
    @IBOutlet weak var storeNameLabel: UILabel!
    @IBOutlet weak var storeAddressLabel: UILabel!
    @IBOutlet weak var storeHoursLabel: UILabel!
    @IBOutlet weak var phoneButton: UIButton!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var activityIndicatorHolder: UIView!
    
    //------------------------------------------------------------------------------------------------
    override func viewDidLoad()
    {
        super.viewDidLoad()
        storeNameLabel.isHidden = true
        storeHoursLabel.isHidden = true
        distanceLabel.isHidden = true
        storeAddressLabel.isHidden = true
        phoneButton.isHidden = true
        
        let fidgetSpinnerHolder = CGRect(x: activityIndicatorHolder.center.x - 25, y: activityIndicatorHolder.center.y, width: CGFloat(50), height: CGFloat(50))
         fidgetSpinner = NVActivityIndicatorView(frame: fidgetSpinnerHolder, type:NVActivityIndicatorType.ballClipRotatePulse, color: UIColor.white,  padding: CGFloat(0))
        
        self.view.addSubview(fidgetSpinner!)
        
        fidgetSpinner?.startAnimating()
        
        self.view.addSubview(fidgetSpinner!)
        
        fidgetSpinner?.startAnimating()
        
    }
    //------------------------------------------------------------------------------------------------
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    //------------------------------------------------------------------------------------------------
    @IBAction func callTheStore(_ sender: Any)
    {
        misc.callTheStore((storeModule?.storeForID(storeID!).storePhone)!)
    }
    //------------------------------------------------------------------------------------------------

    func updateUI()
    {
    self.navigationController?.navigationBar.isHidden = false
    let store = storeModule?.storeForID(storeID!)
    storeNameLabel.text = store?.storeName
  
        if store?.storeHours == nil || store?.storeHours == ""
                {
                    storeHoursLabel.text = "No working hours info available"
                }
                else
                {
                    storeHoursLabel.text = store?.storeHours
                }
            
        if store?.storeAddress == nil || store?.storeAddress == ""
                {
                    storeAddressLabel.text = "No address available"
                }
                else
                {
                    storeAddressLabel.text = store?.storeAddress
                }
            
        if store?.storePhone == nil || store?.storePhone == ""
                {
                   self.phoneButton.isHidden = true
                }
                else
                {
                  self.phoneButton.isHidden = false
                }
        
        if (locationModule?.locationManager.location != nil) || (store != nil)
        {
            let userLoc = locationModule?.locationManager.location!
            let storeLoc = CLLocation(latitude: (store?.storeLongitude)!, longitude: (store?.storeLatitude)!)
            distanceLabel.text = misc.calculateDistance(location1: userLoc!, location2: storeLoc)
        }
    }
   //------------------------------------------------------------------------------------------------

 }

extension StoreViewController: storeInfoModelDelegate {
    
    func dataIsReady()
    {
        updateUI()
        storeNameLabel.isHidden = false
        storeHoursLabel.isHidden = false
        distanceLabel.isHidden = false
        storeAddressLabel.isHidden = false
        //phoneButton.isHidden = false
        activityIndicatorHolder.isHidden = true
        fidgetSpinner?.stopAnimating()
    }
    
    func showError(withMessage:String)
    {
        let alert = UIAlertController(title: "Error!", message: withMessage, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}

