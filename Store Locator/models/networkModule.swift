//
//  networkModule.swift
//  Store Locator
//
//  Created by Ilija Stevanovic on 10/9/17.
//  Copyright © 2017 Lotusflare. All rights reserved.
//

import Foundation
import Alamofire


protocol NetworkModelDelegate {
    func showError(withMessage:String)
}

public class NetworkModel
{
    
    func fetchJsonStoreData(completion: @escaping (Data?) -> ()) // ->
    {
        Alamofire.request("https://acko.lotusflare.com/storeList").responseJSON //store list API courtesy of Acko
        {
                response in
                completion(response.data)
        }
    }
    //------------------------------------------------------------------------------------------------
    func fetchJsonStoreInfoData(idOfTheStore:Int, completion: @escaping (Data?) -> ()) // ->
    {
        let urlToApi:String = "https://acko.lotusflare.com/storeInfo?storeID=" + String(idOfTheStore)
        Alamofire.request(urlToApi).responseJSON //store list API courtesy of Acko
        {
                response in
                completion(response.data)
        }
    }
    
}






