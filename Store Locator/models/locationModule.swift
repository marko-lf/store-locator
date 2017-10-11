//
//  locationModule.swift
//  Store Locator
//
//  Created by Ilija Stevanovic on 10/10/17.
//  Copyright © 2017 Lotusflare. All rights reserved.
//

import Foundation
import CoreLocation


//Data structure used for location managament and distance calculations
public class locationModel: CLLocationManager, CLLocationManagerDelegate
{
    
    public var storeModel:storeModel? //reference to the current store model instance
    public var initLoc:Int = 0        // prevents reloading of data when location changes when becomes 1
    var locationManager = CLLocationManager()
    var locModuleDelegate: locationModelDelegate?
    
    
    var distanceDict:[Int16:String]  //key ->> store ID; value ->> Distance between the user and the store;
    {
        get
        {
            var distDict:[Int16:String] = [ : ]
            
            for store in (storeModel?.stores)!
            {
                
                let storeLoc = CLLocation(latitude: store.storeLongitude, longitude: store.storeLatitude)
                let userLoc = locationManager.location!
                let distance = storeLoc.distance(from: userLoc)
                if (distance <= 500.0)
                {
                    distDict.updateValue(String(Int(distance)) + "meters", forKey: store.storeID)
                }
                else
                {
                    distDict.updateValue(String(Int(distance/1000)) + "km", forKey: store.storeID)
                }
                
            }
            return distDict
        }
    }
    
    
    //------------------------------------------------------------------------------------------------
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
//        if (initLoc == 0)
//        {
//       // locModuleDelegate?.reloadDataTable() //when locationManager initializes, reload the view with updated information
//        initLoc = initLoc + 1                //dont update the table anymore
//        }
    }                                        //Possible improvement: A timer that allows the refereshing of data in cells in a certain interval of time?



}
