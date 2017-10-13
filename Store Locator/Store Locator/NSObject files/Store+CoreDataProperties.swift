//
//  Store+CoreDataProperties.swift
//  Store Locator
//
//  Created by Ilija Stevanovic on 10/6/17.
//  Copyright © 2017 Lotusflare. All rights reserved.
//
//

import Foundation
import CoreData


extension Store {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Store> {
        return NSFetchRequest<Store>(entityName: "Store")
    }

    @NSManaged public var storeAddress: String?
    @NSManaged public var storeHours: String?
    @NSManaged public var storeID: Int16
    @NSManaged public var storeLatitude: Double
    @NSManaged public var storeLongitude: Double
    @NSManaged public var storeName: String?
    @NSManaged public var storePhone: String?

}
