//
//  CollectionViewController.swift
//  Store Locator
//
//  Created by Ilija Stevanovic on 10/5/17.
//  Copyright © 2017 Lotusflare. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation

private let reuseIdentifier = "Cell"

class CollectionViewController: UICollectionViewController
{
    
    public var coreDataEnabled = true
    public var model : storeModel!
    
    @IBOutlet var colView: UICollectionView!
    
    //--------------------------------------------------------------------------------------------------
    lazy var refreshControl: UIRefreshControl =
    {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(CollectionViewController.handleRefresh(_:)),
                                 for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor.white
        refreshControl.layer.zPosition = -1;
        return refreshControl
    }()
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl)
    {
        self.view.isUserInteractionEnabled = false
        let ds = colView.dataSource!
        colView.dataSource = nil
        model.storeAPI()
        print("ok")
        refreshControl.endRefreshing()
        colView.dataSource = ds
        colView.reloadData()
        self.view.isUserInteractionEnabled = true
    }
    //-------------------------------------------------------------------------------------------------
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        model.storeAPI()
        self.colView.addSubview(self.refreshControl)
        
    }
    @IBAction func segueToStoreInfoView(_ sender: UIButton)
    {
        performSegue(withIdentifier: "toStoreInfo", sender: self)
      
    }
    //-------------------------------------------------------------------------------------------------
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    //------------------------------------------------------------------------------------------------
    override func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 1
    }
    //------------------------------------------------------------------------------------------------
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return model.stores.count
    }
    //------------------------------------------------------------------------------------------------
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! StoreCollectionViewCell
      
        cell.storeName.text = model.stores[indexPath.row].storeName
        cell.storeImage.image = UIImage(data: model.images![(model.stores[indexPath.row].storeID)]! as Data)
        cell.segueButton.tag = Int(model.stores[indexPath.row].storeID)
        cell.storeDistance.text = model.distanceDict[(model.stores[indexPath.row].storeID)]
        
        return cell
    }
    //------------------------------------------------------------------------------------------------
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "toStoreDetails"
        {
            let storeVC = segue.destination as? StoreViewController
                storeVC?.storeID = (sender as? UIButton)?.tag
                storeVC?.model = self.model
        }
    }
   //------------------------------------------------------------------------------------------------
}
