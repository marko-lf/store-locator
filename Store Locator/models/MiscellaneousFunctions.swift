//
//  MiscellaneousFunctions.swift
//  Store Locator
//
//  Created by Ilija Stevanovic on 10/11/17.
//  Copyright © 2017 Lotusflare. All rights reserved.
//

import Foundation
import UIKit
import NVActivityIndicatorView
import CoreLocation

public struct Misc {
    
    
    //------------------------------------------------------------------------------------------------
    func RNG() -> Double  //Generates a random number between 0.03 and 1.2 in 90% cases or a 6 in 10% cases
    {
        let a = min( ((Double(arc4random()) / Double(UINT32_MAX))*1.2)+0.03 , 1.2) // [0.03 ... 1.20]
        let b = CGFloat(Float(arc4random()) / Float(UINT32_MAX)) // [0 ... 1]
        if ( b < 0.9) { return a }
        else   { return 6.0 }
    }
    //------------------------------------------------------------------------------------------------

    func PopUpTheErrorWindow(WithMessage:String) -> UIAlertController
    {
        let alert = UIAlertController(title: "Error", message: WithMessage, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        return alert
    }
    //------------------------------------------------------------------------------------------------    
    func noDataAvailable(sender: UIViewController)
    {
        let alert = UIAlertController(title: "Whoops!", message: "No data could be fetched from the server. Check your internet connection and try again", preferredStyle: UIAlertControllerStyle.alert)
        
        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: "Try again", style: UIAlertActionStyle.default, handler: { action in
            
            sender.viewDidLoad()
            
        }))
        
        alert.addAction(UIAlertAction(title: "Continue offline", style: UIAlertActionStyle.default, handler: { action in
            
            
            
        }))
        
        alert.addAction(UIAlertAction(title: "Exit", style: UIAlertActionStyle.destructive, handler: { action in
            
            exit(0)
            
        }))
        
        // show the alert
        sender.present(alert, animated: true, completion: nil)
    }
    //------------------------------------------------------------------------------------------------
    
    func calculateDistance(location1: CLLocation, location2:CLLocation) -> String
    {
        let distance = location1.distance(from: location2)
        var distanceString:String
        if (distance <= 500.0)
        {
            distanceString = String(Int(distance)) + " meters away"
        }
        else
        {
            distanceString = String(Int(distance/1000)) + "km away"
        }
        return distanceString
    }
    //------------------------------------------------------------------------------------------------
    func callTheStore(_ phoneNumber:String)
    {
        var formatedNumber:String = phoneNumber
        formatedNumber = formatedNumber.replacingOccurrences(of: "(", with: "")
        formatedNumber =   formatedNumber.replacingOccurrences(of: ")", with: "")
        formatedNumber =  formatedNumber.replacingOccurrences(of: " ", with: "")
        formatedNumber =   formatedNumber.replacingOccurrences(of: "-", with: "")
        if let phoneCallURL = URL(string: "tel://\(formatedNumber)")
        {
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL))
            {
                application.open(phoneCallURL, options: [:], completionHandler: nil)
            }
        }
    }

}

