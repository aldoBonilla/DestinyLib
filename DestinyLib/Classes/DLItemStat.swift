//
//  ItemStatManifest.swift
//  Destiny2Api
//
//  Created by Aldo Rogelio Bonilla  Guerrero on 17/07/18.
//  Copyright © 2018 Aldo Rogelio Bonilla  Guerrero. All rights reserved.
//

import Foundation

public struct DLItemStat: EntityProtocol, CustomStringConvertible, Hashable {
    
    public let hash: Int
    public let value: Int
    public let maxValue: Int
    
    public init(dictionary: EntityDictionary) throws {
        guard let hash = dictionary["statHash"] as? Int,
              let value = dictionary["value"] as? Int,
              let maxValue = dictionary["maximumValue"] as? Int else {
                throw EntityNetworkingError.entityCantBeCreated(reason: "Key value missing")
        }
        
        self.hash = hash
        self.value = value
        self.maxValue = maxValue
    }
    
    public var description: String {
        return "Stat hash: \(hash), value: \(value), maxValue: \(maxValue)"
    }
    
    public var hashValue: Int {
        return hash
    }
    
    public static func == (lhs: DLItemStat, rhs: DLItemStat) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    public var dictionary: EntityDictionary {
        return [:]
    }
    
}

