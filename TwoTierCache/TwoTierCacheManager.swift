//
//  TwoTierCacheManager.swift
//  TwoTierCache
//
//  Created by David on 10/12/2017.
//  Copyright © 2017 David. All rights reserved.
//

import Foundation

public protocol TwoTierCacheProvider {
    func load(key: String) -> Data?
    func save(key: String, value: NSData?)
    func clearCache()
}

protocol TwoTierCacheManager {
    
    var primaryCache: TwoTierCacheProvider { get set }
    var secondaryCache: TwoTierCacheProvider? { get set }
    subscript(key: String) -> Data? { get set }
    func clearCache()
}

class TwoTierCache: TwoTierCacheManager {
    
    public static let shared: TwoTierCacheManager = TwoTierCache()
    
    var primaryCache: TwoTierCacheProvider = MemoryCache()
    var secondaryCache: TwoTierCacheProvider? = FileCache(cacheDirectory: "TwoTierCache")
    
    subscript(key: String) -> Data? {
        get {
            guard let result = primaryCache.load(key: key) else {
                if let file = secondaryCache?.load(key: key) {
                    primaryCache.save(key: key, value: file as NSData?)
                    return file
                }
                return nil
            }
            return result
        }
        set (newValueToSave){
            let data: NSData? = newValueToSave as NSData?
            primaryCache.save(key: key, value: data)
            secondaryCache?.save(key: key, value: data)
        }
    }
    
    func clearCache() {
        primaryCache.clearCache()
        secondaryCache?.clearCache()
    }
    
}



