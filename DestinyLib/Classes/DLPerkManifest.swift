//
//  PerkManifest.swift
//  Destiny2Api
//
//  Created by Aldo Rogelio Bonilla  Guerrero on 18/07/18.
//  Copyright © 2018 Aldo Rogelio Bonilla  Guerrero. All rights reserved.
//

import Foundation

public struct DLPerkManifest: EntityProtocol, CustomStringConvertible, Hashable {
    
    public let hash: Int
    public let display: DLDisplayManifest
    public let isDisplayable: Bool
    public let damageType: DLDamageType
    
    public init(dictionary: EntityDictionary) throws {
        guard let hash = dictionary["hash"] as? Int,
              let displayProp = dictionary["displayProperties"] as? EntityDictionary,
              let displayManifest = try? DLDisplayManifest(dictionary: displayProp),
            let isDisplayable = dictionary["isDisplayable"] as? Bool,
            let damageTypeInt = dictionary["damageType"] as? Int else {
                throw EntityNetworkingError.entityCantBeCreated(reason: "Key value missing")
        }
        
        self.hash = hash
        self.display = displayManifest
        self.isDisplayable = isDisplayable
        self.damageType = DLDamageType(rawValue: damageTypeInt) ?? .none
    }
    
    public var description: String {
        return "Perk with name: \(display.name), isDisplayable: \(isDisplayable)"
    }
    
    public var hashValue: Int {
        return hash.hashValue
    }
    
    public static func == (lhs: DLPerkManifest, rhs: DLPerkManifest) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    public var dictionary: EntityDictionary {
        return [:]
    }
}
