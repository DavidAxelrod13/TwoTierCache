//
//  FileCache.swift
//  TwoTierCache
//
//  Created by David on 10/12/2017.
//  Copyright © 2017 David. All rights reserved.
//

import Foundation

class FileCache: TwoTierCacheProvider {
    
    private let cacheDirectory: String
    private let loggingEnabled: Bool
    
    init(cacheDirectory: String, enableLogging: Bool = true) {
        self.cacheDirectory = cacheDirectory
        self.loggingEnabled = enableLogging
    }
    
    func load(key: String) -> Data? {
        guard let path = fileURL(fileName: key) else { return nil }
            
        var data: Data?
        do {
            data = try Data(contentsOf: path)
        } catch let dataCreationErr {
            log("[TwoTierCache] Error creating data object: ", dataCreationErr.localizedDescription)
        }
        return data
    }
    
    func save(key: String, value: NSData?) {
        guard let path = fileURL(fileName: key) else { return }
        
        if let new = value as Data? {
            do {
                try new.write(to: path, options: .atomic)
            } catch let writtingErr {
                log("[TwoTierCache] Error writing data to the file: \(writtingErr.localizedDescription)")
            }
        } else {
            try? FileManager.default.removeItem(at: path)
        }
    }
    
    func clearCache() {
        deleteCacheDirectory()
    }
    
    private func fileURL(fileName name: String) -> URL? {
        guard let escapedName = name.addingPercentEncoding(withAllowedCharacters: .alphanumerics) else {
            return nil
        }
        
        var cachesDir: URL?
        do {
            cachesDir = try cachesDirectory()
        } catch {
            log("[TwoTierCache] Error getting caches directory: ", error)
            return nil
        }
        
        return cachesDir?.appendingPathComponent(escapedName)
        
    }
    
    private func cachesDirectory() throws -> URL? {
        
        var cachesDir: URL? = nil
        
        do {
            cachesDir = try FileManager
                .default
                .url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                .appendingPathComponent(cacheDirectory, isDirectory: true)
        } catch {
            throw error
        }
        
        guard let dir = cachesDir else {
            return nil
        }
        
        do {
            try FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true, attributes: nil)
        } catch {
            throw error
        }
        
        return dir
    }
    
    private func deleteCacheDirectory() {
        
        var cachesDir: URL?
        do {
            cachesDir = try cachesDirectory()
        } catch {
            log("[TwoTierCache] Error getting caches directory: ", error)
            return
        }
        
        guard let dir = cachesDir else {
            return
        }
        
        do {
            try FileManager.default.removeItem(at: dir)
        } catch {
            log("[TwoTierCache] Error deleting files from the caches directory: ", error)
        }
        
    }
    
    private func log(_ items: Any...) {
        guard loggingEnabled else {
            return
        }
        print(items)
    }
    
}
