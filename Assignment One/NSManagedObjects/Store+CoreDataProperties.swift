//
//  Store+CoreDataProperties.swift
//  Assignment One
//
//  Created by Ilija Stevanovic on 9/26/17.
//  Copyright © 2017 Lotusflare. All rights reserved.
//
//

import Foundation
import CoreData


extension Store {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Store> {
        return NSFetchRequest<Store>(entityName: "Store")
    }

    @NSManaged public var storeLatitude: Double
    @NSManaged public var storeLongitude: Double
    @NSManaged public var storeImageSize: Int32
    @NSManaged public var storeImageUrl: String?
    @NSManaged public var storeName: String?
    @NSManaged public var storeID: Int16

}
