//
//  ItemBucket.swift
//  Destiny2Api
//
//  Created by Aldo Rogelio Bonilla  Guerrero on 16/07/18.
//  Copyright © 2018 Aldo Rogelio Bonilla  Guerrero. All rights reserved.
//

import Foundation

public struct DLItemBucket: EntityProtocol, CustomStringConvertible, Hashable {
    
    public let hash: Int
    public let display: DLDisplayManifest
    public let scope: Int
    public let category: DLBucketCategory
    public let order : Int
    public let location: Int
    
    public init(dictionary: EntityDictionary) throws {
        guard let hash = dictionary["hash"] as? Int,
              let displayProp = dictionary["displayProperties"] as? EntityDictionary,
              let displayManifest = try? DLDisplayManifest(dictionary: displayProp),
              let scope = dictionary["scope"] as? Int,
              let categoryInt = dictionary["category"] as? Int,
              let order = dictionary["buckerOrder"] as? Int,
              let location = dictionary["location"] as? Int else {
                throw EntityNetworkingError.entityCantBeCreated(reason: "Key value missing")
        }
        
        self.hash = hash
        self.display = displayManifest
        self.scope = scope
        self.category = DLBucketCategory(rawValue: categoryInt) ?? .invisible
        self.order = order
        self.location = location
    }
    
    public var hashValue: Int {
        return hash
    }
    
    public static func == (lhs: DLItemBucket, rhs: DLItemBucket) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    public var description: String {
        return "Bucket name: \(display.name)"
    }
    
    public var dictionary: EntityDictionary {
        return [:]
    }
}
