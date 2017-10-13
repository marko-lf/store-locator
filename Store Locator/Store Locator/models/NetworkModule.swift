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
    var networkModelDelegate:networkModelDelegate?
    
    public var storeModel:StoreModel?
    public var miscFunctions = Misc()
   
     func fetchJsonStoreData(usingMockData:Bool)
        { //takes care of both mockData requests and API reuqests
            
              if usingMockData == true
            {
               let pathToStore = Bundle.main.path(forResource: "Store", ofType: "txt")
               let urlToStore = URL(fileURLWithPath: pathToStore!)
                do
                {
                 let dataForReturn = try Data(contentsOf: urlToStore)
                 usleep(UInt32(miscFunctions.RNG()*1000000)) //mocking the delay for mockdata
                 self.storeModel!.storeCoreDataInit(dataForReturn)
                }
                catch
                {
                    networkModelDelegate?.showError(withMessage: "Could not fetch store data")
                }
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
                    else
                    {
                       self.networkModelDelegate?.showError(withMessage: "Could not fetch store data")                        
                    }
                }
                
            }
        }


}
    
    
    
    

