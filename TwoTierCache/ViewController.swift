//
//  ViewController.swift
//  TwoTierCache
//
//  Created by David on 10/12/2017.
//  Copyright © 2017 David. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let stringToSaveInCache = "Hello World!"
        
        let stringCache = TwoTierCache(cacheExpiration: 100)
        
//        stringCache["newElement"] = stringToSaveInCache.data(using: .utf8)
//        stringCache["newElement2"] = stringToSaveInCache.data(using: .utf8)
//        stringCache["newElement3"] = stringToSaveInCache.data(using: .utf8)

        if let retrievedData = stringCache["newElement"] {
            let retrievedString = String(data: retrievedData, encoding: String.Encoding.utf8)
            print(retrievedString ?? "")
        }
        
        if let retrievedData = stringCache["newElement2"] {
            let retrievedString = String(data: retrievedData, encoding: String.Encoding.utf8)
            print(retrievedString ?? "")
        }
        
        if let retrievedData = stringCache["newElement3"] {
            let retrievedString = String(data: retrievedData, encoding: String.Encoding.utf8)
            print(retrievedString ?? "")
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

