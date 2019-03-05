//
//  InventoryItem.swift
//  Destiny2Api
//
//  Created by Aldo Rogelio Bonilla  Guerrero on 09/07/18.
//  Copyright © 2018 Aldo Rogelio Bonilla  Guerrero. All rights reserved.
//

import Foundation

public struct DLInventoryItem: EntityProtocol, CustomStringConvertible, Hashable {
    
    public let hash: Int
    public let instance: String?
    public let quantity: Int
    public let location: DLItemLocation
    public let lockable: Bool
    public let state: Int
    public let bucketHash: Int
    
    public init(dictionary: EntityDictionary) throws {
        
        guard let hash = dictionary["itemHash"] as? Int,
              let quantity = dictionary["quantity"] as? Int,
              let locationInt = dictionary["location"] as? Int,
              let lockable = dictionary["lockable"] as? Bool,
              let state = dictionary["state"] as? Int,
              let bucketHash = dictionary["bucketHash"] as? Int else {
                throw EntityNetworkingError.entityCantBeCreated(reason: "Key value missing")
        }
        
        self.hash = hash
        self.instance = dictionary["itemInstanceId"] as? String
        self.quantity = quantity
        self.location = DLItemLocation(rawValue: locationInt) ?? .unknown
        self.lockable = lockable
        self.state = state
        self.bucketHash = bucketHash
    }
    
    public var description: String {
        return "Item hash: \(hash), instance: \(instance ?? "")"
    }
    
    public var hashValue: Int {
        return hash
    }
    
    public static func == (lhs: DLInventoryItem, rhs: DLInventoryItem) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    public var dictionary: EntityDictionary {
        return [:]
    }
}
