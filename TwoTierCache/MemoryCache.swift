//
//  MemoryCache.swift
//  TwoTierCache
//
//  Created by David on 10/12/2017.
//  Copyright © 2017 David. All rights reserved.
//

import Foundation

class MemoryCache: TwoTierCacheProvider {
    
    private let cache: NSCache<NSString, NSData> = NSCache<NSString, NSData>()
    
    func load(key: String) -> Data? {
        return cache.object(forKey: NSString(string: key)) as Data?
    }
    
    func save(key: String, value: NSData?) {
        if let new = value {
            self.cache.setObject(new, forKey: NSString(string: key))
        } else {
            self.cache.removeObject(forKey: NSString(string: key))
        }
    }
    
    func clearCache() {
        cache.removeAllObjects()
    }
}
