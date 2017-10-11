//
//  MiscellaneousFunctions.swift
//  Store Locator
//
//  Created by Ilija Stevanovic on 10/11/17.
//  Copyright © 2017 Lotusflare. All rights reserved.
//

import Foundation
import UIKit


public struct Misc {
//------------------------------------------------------------------------------------------------
func RNG() -> Double  //Generates a random number between 0.03 and 1.2
{
    return min( ((Double(arc4random()) / Double(UINT32_MAX))*1.2)+0.03 , 1.2)
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
