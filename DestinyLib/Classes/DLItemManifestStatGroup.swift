//
//  ItemManifestStatGroup.swift
//  Destiny2Api
//
//  Created by Aldo Rogelio Bonilla  Guerrero on 18/07/18.
//  Copyright © 2018 Aldo Rogelio Bonilla  Guerrero. All rights reserved.
//

import Foundation

public struct DLItemManifestStatGroup: EntityProtocol, CustomStringConvertible, Hashable {
    
    public let hash: Int
    public let disablePrimaryStatDisplay: Bool
    public let stats: [String]
    
    public init(dictionary: EntityDictionary) throws {
        guard let hash = dictionary["statGroupHash"] as? Int,
              let disablePrimary = dictionary["disablePrimaryStatDisplay"] as? Bool,
              let statsDicts = dictionary["stats"] as? EntityDictionary else {
                throw EntityNetworkingError.entityCantBeCreated(reason: "Key Value missing")
        }
        self.hash = hash
        self.disablePrimaryStatDisplay = disablePrimary
        self.stats = Array(statsDicts.keys)
    }
    
    public var description: String {
        return "stat group hash: \(hash), number of stats: \(stats.count)"
    }
    
    public var hashValue: Int {
        return hash
    }
    
    public static func == (lhs: DLItemManifestStatGroup, rhs: DLItemManifestStatGroup) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    public var dictionary: EntityDictionary {
        return [:]
    }
}
