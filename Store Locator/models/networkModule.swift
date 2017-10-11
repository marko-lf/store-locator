//
//  networkModule.swift
//  Store Locator
//
//  Created by Ilija Stevanovic on 10/9/17.
//  Copyright © 2017 Lotusflare. All rights reserved.
//

import Foundation
import Alamofire


public class NetworkModel
{
    
    public var storeModel:StoreModel?              //reference to the current store model instance

   
     func fetchJsonStoreData(usingMockData:Bool)
        {
              if usingMockData == true
            {
               let pathToStore = Bundle.main.path(forResource: "Store", ofType: "txt")
               let urlToStore = URL(fileURLWithPath: pathToStore!)
                do
                {
                 let dataForReturn = try Data(contentsOf: urlToStore)
                 self.storeModel!.storeCoreDataInit(dataForReturn)
                }
                catch {print(error)}
            }
            else
            {
                
                Alamofire.request("https://acko.lotusflare.com/storeList").responseJSON //store list API courtesy of Acko
                {
                    response in
                    
                    if let _ = response.data
                    {
                        self.storeModel!.storeCoreDataInit(response.data!)
                    }
                }
                
            }
        }
  //------------------------------------------------------------------------------------------------
    func fetchJsonStoreInfoData(usingMockData:Bool, idOfTheStore:Int )
    {
        if usingMockData == true
        {
            let pathToStore = Bundle.main.path(forResource: "StoreInfo", ofType: "txt")
            let urlToStore = URL(fileURLWithPath: pathToStore!)
            do
            {
                let dataForReturn = try Data(contentsOf: urlToStore)
                self.storeModel!.storeInfoParseRequest(dataForReturn, forStoreByID: idOfTheStore)
            }
            catch {print(error)}
        }
        else
        {
        
           let urlToApi:String = "https://acko.lotusflare.com/storeInfo?storeID=" + String(idOfTheStore)
            
           
           
            Alamofire.request(urlToApi).responseJSON //storeInfo API courtesy of Acko
                {
                    response in
                    
                    if let _ = response.data
                    {
                        self.storeModel!.storeInfoParseRequest(response.data!, forStoreByID: idOfTheStore)
                    }
            }
            
        }
    }

}
    
    
    
    

