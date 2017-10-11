//
//  StoreCollectionViewCell.swift
//  Store Locator
//
//  Created by Ilija Stevanovic on 9/27/17.
//  Copyright © 2017 Lotusflare. All rights reserved.
//

import UIKit

class StoreCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var storeImage: UIImageView!
    @IBOutlet weak var storeName: UILabel! 
    @IBOutlet weak var storeDistance: UILabel!
    @IBOutlet weak var segueButton: UIButton!
    @IBOutlet weak var distanceActivityIndicator: UIActivityIndicatorView!
    
    override func prepareForReuse() {
       super.prepareForReuse()
        storeName.text=""
    }
}
