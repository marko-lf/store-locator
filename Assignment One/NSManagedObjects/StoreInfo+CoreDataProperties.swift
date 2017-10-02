//
//  StoreInfo+CoreDataProperties.swift
//  Assignment One
//
//  Created by Ilija Stevanovic on 9/26/17.
//  Copyright © 2017 Lotusflare. All rights reserved.
//
//

import Foundation
import CoreData


extension StoreInfo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StoreInfo> {
        return NSFetchRequest<StoreInfo>(entityName: "StoreInfo")
    }

    @NSManaged public var storeID: Int16
    @NSManaged public var storeAddress: String?
    @NSManaged public var storePhone: String?
    @NSManaged public var storeHours: String?

}
