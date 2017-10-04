//
//  StoreViewController.swift
//  Assignment One
//
//  Created by Ilija Stevanovic on 10/2/17.
//  Copyright © 2017 Lotusflare. All rights reserved.
//

import UIKit
import CoreData
import MapKit
import CoreLocation

class StoreViewController: UIViewController {
    
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var storeName: UILabel!
    @IBOutlet weak var workingHours: UILabel!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var noDataMessage: UILabel!
    @IBOutlet weak var nophoneNumber: UILabel!
    
    public var distanceString:String?
    public var storeLoc:CLLocationCoordinate2D?
    public var phoneNumber: String?
    public var storeHours:String?
    
    
    var stores:[Store] {
        get {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext  //Fetching the current context
            let fetchRequest:NSFetchRequest<Store> = Store.fetchRequest()
            do {
                let fetchedResults = try  context.fetch(fetchRequest)
                return fetchedResults
            }
            catch {print(error)
                return []
            }
        }
    }
    
    var storesInfo:[StoreInfo] {
        get {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext  //Fetching the current context
            let fetchRequest:NSFetchRequest<StoreInfo> = StoreInfo.fetchRequest()
            do {
                let fetchedResults = try  context.fetch(fetchRequest)
                return fetchedResults
            }
            catch {print(error)
                return []
            }
        }
    }
    
    
    @IBOutlet weak var navigationTitle: UINavigationBar!
    @IBOutlet weak var test: UILabel!
    
    public var storeID:Int?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        UpdateUI()
        let singleTapRecognizer = UITapGestureRecognizer(target:self, action: #selector(onMapClicked))
        singleTapRecognizer.delegate = self
        map.addGestureRecognizer(singleTapRecognizer)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
   
    func UpdateUI() {
        for store in stores {
            
            if Int(store.storeID) == storeID!
            {
               storeName.text = store.storeName
               distance.text = distanceString
                
                let annotation = MKPointAnnotation()
                let centerCoordinate = storeLoc
                
                let span: MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
               // let myLocation = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
                let region:MKCoordinateRegion = MKCoordinateRegionMake(centerCoordinate!, span)
                map.setRegion(region, animated: true)
                
                annotation.coordinate = centerCoordinate!
                annotation.title = store.storeName
                map.addAnnotation(annotation)
            }
        }
        
        var storeInfoFound = false
        for storeinfo in storesInfo {
            
            if (Int(storeinfo.storeID) == storeID!)
            {
                address.isHidden = false
                workingHours.isHidden = false
                
                nophoneNumber.isHidden = true
                storeInfoFound = true
                noDataMessage.isHidden = true
                address.text = storeinfo.storeAddress
                workingHours.text = storeHours
                
            }
            if (storeInfoFound == false)
            {
              address.isHidden = true
              workingHours.isHidden = true
              noDataMessage.isHidden = false
              nophoneNumber.isHidden = true
            }
        }
    }
    
    
    @objc func onMapClicked() {
        print("tu sam")
    }
    
    @IBAction func phoneButtonClicked(_ sender: Any) {
        if (phoneNumber != nil)
        {
        phoneNumber = phoneNumber?.replacingOccurrences(of: "(", with: "", options: NSString.CompareOptions.literal, range:nil)
        phoneNumber = phoneNumber?.replacingOccurrences(of: ")", with: "", options: NSString.CompareOptions.literal, range:nil)
        phoneNumber = phoneNumber?.replacingOccurrences(of: " ", with: "", options: NSString.CompareOptions.literal, range:nil)
        callNumber(phoneNumber: phoneNumber!)
        }
        else
        {
            nophoneNumber.isHidden = false
        }
    }
    
    private func callNumber(phoneNumber:String) {
        
              let phoneUrlString = "tel://\(phoneNumber)"
              let phoneCallURL = URL(string:phoneUrlString)
            
            let application:UIApplication = UIApplication.shared
            //if (application.canOpenURL(phoneCallURL)) {
                application.open(phoneCallURL!, options: [:], completionHandler: nil)
            //}
        
    }
    
    
    @IBAction func zoomOnMap(_ sender: UIButton) {
        
        let margins = view.layoutMarginsGuide
         map.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
         map.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension StoreViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return touch.view!.frame.equalTo(map.frame)
    }
}
