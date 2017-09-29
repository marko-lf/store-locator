//
//  Image+CoreDataProperties.swift
//  Assignment One
//
//  Created by Ilija Stevanovic on 9/28/17.
//  Copyright © 2017 Lotusflare. All rights reserved.
//
//

import Foundation
import CoreData


extension Image {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Image> {
        return NSFetchRequest<Image>(entityName: "Image")
    }

    @NSManaged public var imageFile: NSData?
    @NSManaged public var imageSize: Int32
    @NSManaged public var storeID: Int32

}
