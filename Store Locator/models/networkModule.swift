//
//  networkModule.swift
//  Store Locator
//
//  Created by Ilija Stevanovic on 10/9/17.
//  Copyright © 2017 Lotusflare. All rights reserved.
//

import Foundation
import Alamofire


public class networkModel
{
    
    public var storeModel:storeModel?              //reference to the current store model instance

   
     func fetchJsonStoreData(usingMockData:Bool)
    {
          if usingMockData == true
        {
           let pathToStore = Bundle.main.path(forResource: "Store", ofType: "txt")
           let urlToStore = URL(fileURLWithPath: pathToStore!)
            do
            {
             let dataForReturn = try Data(contentsOf: urlToStore)
             self.storeModel!.updateCoreDataWithJSON(dataForReturn)
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
                    self.storeModel!.updateCoreDataWithJSON(response.data!)
                }
            }
            
        }
    }
  //------------------------------------------------------------------------------------------------
    

}
    
    
    
    

