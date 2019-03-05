//
//  StatGroupManifest.swift
//  Destiny2Api
//
//  Created by Aldo Rogelio Bonilla  Guerrero on 18/07/18.
//  Copyright © 2018 Aldo Rogelio Bonilla  Guerrero. All rights reserved.
//

import Foundation

public struct DLStatGroupManifest: EntityProtocol, CustomStringConvertible, Hashable {
    
    public let hash: Int
    public let uiPosition: Int
    public let scaledStats: [DLScaledStats]
    
    public init(dictionary: EntityDictionary) throws {
        guard let hash = dictionary["hash"] as? Int,
              let uiPosition = dictionary["uiPosition"] as? Int,
              let scaledStatsDicts = dictionary["scaledStats"] as? [EntityDictionary] else {
                throw EntityNetworkingError.entityCantBeCreated(reason: "Key Value Missing")
        }
        
        self.hash = hash
        self.uiPosition = uiPosition
        self.scaledStats = DLScaledStats.initEntities(dictionaries: scaledStatsDicts)
    }
    
    public var description: String {
        return "Group position: \(uiPosition) with \(scaledStats.count) stats"
    }
    
    public var hashValue: Int {
        return hash
    }
    
    public static func == (lhs: DLStatGroupManifest, rhs: DLStatGroupManifest) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    public var dictionary: EntityDictionary {
        return [:]
    }
}
