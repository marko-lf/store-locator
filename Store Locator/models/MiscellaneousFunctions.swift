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

public struct Misc {
    
    weak var displayIndicatorActive:NVActivityIndicatorView?
    
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
//------------------------------------------------------------------------------------------------

    func PopUpTheErrorWindow(WithMessage:String) -> UIAlertController
{
    let alert = UIAlertController(title: "Error", message: WithMessage, preferredStyle: UIAlertControllerStyle.alert)
    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
    return alert
}
    
    
mutating func displayTheIndicator(forView: UIView)
{
    self.displayIndicatorActive?.isHidden = false
    let x = forView.frame.width / 2 - 50
    let y = forView.frame.height / 2 - 30
    let frame = CGRect(x: x, y: y, width: 100, height: 100)
    let activityIndicatorView = NVActivityIndicatorView(frame: frame,
                                                        type: NVActivityIndicatorType(rawValue: 5))
    displayIndicatorActive = activityIndicatorView
    
    activityIndicatorView.padding = 0
    
    forView.addSubview(activityIndicatorView)
    forView.bringSubview(toFront: self.displayIndicatorActive!)
    activityIndicatorView.startAnimating()
    self.displayIndicatorActive = activityIndicatorView
}
    
mutating func hideTheIndicator()
{
    self.displayIndicatorActive?.isHidden = true
   
}

mutating func showTheIndicator()
{
    self.displayIndicatorActive?.isHidden = false
}


}

    
    

