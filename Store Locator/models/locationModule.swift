//
//  locationModule.swift
//  Store Locator
//
//  Created by Ilija Stevanovic on 10/10/17.
//  Copyright © 2017 Lotusflare. All rights reserved.
//

import Foundation
import CoreLocation



public class LocationModel: CLLocationManager, CLLocationManagerDelegate
{
    
    var locationManager = CLLocationManager()
    
    //------------------------------------------------------------------------------------------------
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
    }
    
}

