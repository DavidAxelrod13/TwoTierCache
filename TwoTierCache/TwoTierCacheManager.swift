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
    var cacheExpiration: Double? {
        didSet {
            checkCaches()
        }
    }
    
    private func checkCaches() {
        
        let fileManager = FileManager.default
        guard let expiryInSeconds = cacheExpiration else { return }
        
        guard let cacheDir = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first else { return }
        let twoTierCacheDir = cacheDir.appendingPathComponent("TwoTierCache")
        let twoTierCacheDirPath = twoTierCacheDir.path
        
        let attrFile: Dictionary? = try? fileManager.attributesOfItem(atPath: twoTierCacheDirPath)
        let createdAt = attrFile![FileAttributeKey.creationDate] as! Date
        let timeSinceCreation = fabs( createdAt.timeIntervalSinceNow )
        
        print(twoTierCacheDirPath)
        print( "file created at \(createdAt), \(timeSinceCreation) seconds ago" )
        
        if timeSinceCreation > expiryInSeconds {
            clearCache()
            print("Successfully cleared Cache with path: \(twoTierCacheDirPath)")
        }

    }
    
    convenience init(cacheExpiration: Double) {
        self.init()
        setCacheExpiration(cacheExpiration)
    }
    
    private func setCacheExpiration(_ cacheExpiration: Double) {
        self.cacheExpiration = cacheExpiration
    }
    
    
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



