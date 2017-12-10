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
        
        let stringCache = TwoTierCache()
        stringCache["newElement"] = stringToSaveInCache.data(using: .utf8)
        
        if let retrievedData = stringCache["newElement"] {
            let retrievedString = String(data: retrievedData, encoding: String.Encoding.utf8)
            print(retrievedString ?? "")
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

