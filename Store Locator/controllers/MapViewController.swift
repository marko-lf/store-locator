//
//  MapViewController.swift
//  Store Locator
//
//  Created by Ilija Stevanovic on 10/18/17.
//  Copyright © 2017 Lotusflare. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var closeTheMap: UIButton!
    
    public var storeID:Int?
    public var storeModule:StoreModel?
    public var locationModule:LocationModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.showsUserLocation = true
        UIApplication.shared.statusBarStyle = .default
        let storeAnnotation = MKPointAnnotation()
        storeAnnotation.title = storeModule?.storeForID(storeID!).storeName
        storeAnnotation.subtitle = storeModule?.storeForID(storeID!).storeAddress
        storeAnnotation.coordinate =  CLLocationCoordinate2D(latitude: (storeModule?.storeForID(storeID!).storeLongitude)!, longitude: (storeModule?.storeForID(storeID!).storeLatitude)!)
        self.mapView.addAnnotation(storeAnnotation)
        
        
        let mapSpan:MKCoordinateSpan = MKCoordinateSpanMake(0.1, 0.1)
        let region = MKCoordinateRegionMake(CLLocationCoordinate2D(latitude: (storeModule?.storeForID(storeID!).storeLongitude)!, longitude: (storeModule?.storeForID(storeID!).storeLatitude)!), mapSpan)
        self.mapView.setRegion(region, animated: true)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func closeMapView(_ sender: Any)
    {
        UIApplication.shared.statusBarStyle = .lightContent
        self.dismiss(animated: true, completion:nil)
    }
    

}
