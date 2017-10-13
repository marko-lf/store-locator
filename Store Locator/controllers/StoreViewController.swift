//
//  StoreViewController.swift
//  Store Locator
//
//  Created by Ilija Stevanovic on 10/6/17.
//  Copyright © 2017 Lotusflare. All rights reserved.
//

import UIKit
import MapKit

protocol storeInfoModelDelegate {
    func reloadData()
    func showError(withMessage:String)
}

class StoreViewController: UIViewController,storeInfoModelDelegate,networkModelDelegate {
    
    func reloadData()
    {
       updateUI()
    }
    
    func showError(withMessage:String) 
    {
        let alert = UIAlertController(title: "Error!", message: withMessage, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    public var storeModule:StoreModel?
    public var locationModule:LocationModel?
    public var netModule:NetworkModel?
    public var storeID:Int?
    var storePhone:String?
    var  storeAddressIfNotProvided:String?
    var storeLoc:CLLocationCoordinate2D?
    
    
    @IBOutlet weak var storeNameLabel: UILabel!
    @IBOutlet weak var storeAddressLabel: UILabel!
    @IBOutlet weak var storeHoursLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var phoneButton: UIButton!
    @IBOutlet weak var noPhoneNumberAvail: UILabel!
    @IBOutlet weak var zoomOnMapButton: UIButton!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var mapNavBar: UINavigationBar!
    
    @IBOutlet weak var mapNavBarTItle: UINavigationItem!
    
    //------------------------------------------------------------------------------------------------
    override func viewDidLoad()
    {
        storeModule?.storeInfoModelDelegate = self
        netModule?.networkModelDelegate = self
        super.viewDidLoad()
        updateUI()
        // Do any additional setup after loading the view.
    }
    //------------------------------------------------------------------------------------------------
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //------------------------------------------------------------------------------------------------
    @IBAction func callTheStore(_ sender: Any)
    {
        if storePhone == nil
        {
            noPhoneNumberAvail.isHidden = false
        }
        else
        {
          storeModule?.misc.callTheStore(storePhone!)
        }
    }
    //------------------------------------------------------------------------------------------------
    @IBAction func zoomOnMap(_ sender: UIButton)
    {
        self.mapView.frame.size.height = UIScreen.main.bounds.height
        self.view.bringSubview(toFront: mapView)
        self.navigationController!.navigationBar.isHidden = true
        mapNavBarTItle.title = self.storeNameLabel.text!
       
        mapView.showsUserLocation = true
        let mapSpan:MKCoordinateSpan = MKCoordinateSpanMake(0.1, 0.1)
        let region = MKCoordinateRegionMake(storeLoc!, mapSpan)
            
        self.mapView.setRegion(region, animated: true)
        
        
       // self.view.bringSubview(toFront: backFromMap)
    }
    //------------------------------------------------------------------------------------------------
    @IBAction func zoomOutMap(_ sender: UIBarButtonItem)
    {
         updateUI()
    }
    //------------------------------------------------------------------------------------------------
    func updateUI()
    {
    self.navigationController?.navigationBar.isHidden = false
    self.mapView.frame.size.height = UIScreen.main.bounds.height/3
    self.view.bringSubview(toFront: zoomOnMapButton)
    let store = storeModule?.storeForID(storeID!)
        storeNameLabel.text = store?.storeName
                distanceLabel.text = locationModule?.distanceDict[Int16(storeID!)]
            let storeAnnotation = MKPointAnnotation()
                storeAnnotation.title = store?.storeName
        storeAnnotation.coordinate =  CLLocationCoordinate2D(latitude: (store?.storeLongitude)!, longitude: (store?.storeLatitude)!)
        storeLoc = CLLocationCoordinate2D(latitude: (store?.storeLongitude)!, longitude: (store?.storeLatitude)!)
                self.mapView.addAnnotation(storeAnnotation)
            
                let mapSpan:MKCoordinateSpan = MKCoordinateSpanMake(0.1, 0.1)
        let region = MKCoordinateRegionMake(CLLocationCoordinate2D(latitude: (store?.storeLongitude)!, longitude: (store?.storeLatitude)!), mapSpan)
                self.mapView.setRegion(region, animated: true)
            
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
                   storePhone = nil
                   self.phoneButton.isHidden = true
                }
                else
                {
                    storePhone = store?.storePhone
                  self.phoneButton.isHidden = false
                }
            }


   //------------------------------------------------------------------------------------------------

 }
