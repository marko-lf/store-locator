//
//  PinAnnotation.swift
//  Mappio
//
//  Created by Ilija Stevanovic on 9/25/17.
//  Copyright © 2017 Lotusflare. All rights reserved.
//

import Foundation
import MapKit


class PinAnnotation: NSObject, MKAnnotation {
    var title: String?
    //var subtitle: String?
    var coordinate: CLLocationCoordinate2D
    
    init(title: String,  coordinate: CLLocationCoordinate2D) {
        self.title = title
       // self.subtitle = subtitle
        self.coordinate = coordinate
        
    }
}
