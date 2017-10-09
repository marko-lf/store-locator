//
//  InitViewController.swift
//  Store Locator
//
//  Created by Ilija Stevanovic on 10/6/17.
//  Copyright © 2017 Lotusflare. All rights reserved.
//

import UIKit
import CoreLocation

class InitViewController: UIViewController
{
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    public var model = storeModel()
    
    public var mockDataMode = 0
    //--------------------------------------------------------------------------------------------------
    override func viewDidLoad()
    {
        
        super.viewDidLoad()
        activityIndicator.startAnimating()	
        model.locationManager.requestWhenInUseAuthorization()
        model.locationManager.startUpdatingLocation()
        model.locationManager.delegate = self.model
        model.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        
        Timer.scheduledTimer(timeInterval: model.RNG(), target: self, selector: #selector(InitViewController.leavingThisView), userInfo: nil, repeats: false)
    }
    //--------------------------------------------------------------------------------------------------
    override func didReceiveMemoryWarning()
    {
        
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //--------------------------------------------------------------------------------------------------
    @objc func leavingThisView()
    {
        let myNavBar = storyboard?.instantiateViewController(withIdentifier: "colView") as! UINavigationController
        let myVC = myNavBar.visibleViewController as? CollectionViewController
        self.model.mockDataMode = mockDataMode
        myVC?.model = self.model
        
        show(myNavBar, sender:self)
    }
   //--------------------------------------------------------------------------------------------------


}
