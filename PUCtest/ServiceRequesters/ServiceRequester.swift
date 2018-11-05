//
//  ServiceRequester.swift
//  PUCtest
//
//  Created by MAGNANIG-NB on 04/11/2018.
//  Copyright © 2018 MAGNANIG-NB. All rights reserved.
//

import UIKit

let SPORT_API = ""

class ServiceRequester {
    var sports: [Sport]?
    init() {}
    
    func makeRequest(completionHandler :  @escaping () -> Void,
                     errCompletionHandler :  ( (String) -> Void )?){
        
        let urlStr: String = SPORT_API
        let url = NSURL(string: urlStr)!
        
        let config = URLSessionConfiguration.default
        
        config.httpAdditionalHeaders = [
            "Accept": "application/json",
            "x-api-key": ""
        ]
        
        let urlSession = URLSession(configuration: config)
        
        let myQuery = urlSession.dataTask(with: url as URL, completionHandler: {
            data, response, error -> Void in
            if error != nil {
                print("error=\(String(describing: error))")
                errCompletionHandler!("api error")
                return
            }
            guard let responseModel = try? JSONDecoder().decode(ResponseSport.self, from: data!) else {
                errCompletionHandler!("parse error")
                return
            }
            
            self.sports = responseModel.data.list
            completionHandler()
            return
            
        })
        myQuery.resume()
    }
}

