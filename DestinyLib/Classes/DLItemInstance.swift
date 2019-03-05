//
//  ItemInstance.swift
//  Destiny2Api
//
//  Created by Aldo Rogelio Bonilla  Guerrero on 09/07/18.
//  Copyright © 2018 Aldo Rogelio Bonilla  Guerrero. All rights reserved.
//

import Foundation

public final class DLItemInstance: EntityProtocol, CustomStringConvertible {
    
    public let damageType: DLDamageType
    public let primaryStat: DLItemStat
    public let level: Int
    public let quality: Int
    public let isEquipped: Bool
    public let canEquip: Bool
    public let equipRequiredLevel: Int
    
    public init(dictionary: EntityDictionary) throws {
        guard let damageTypeInt = dictionary["damageType"] as? Int,
              let primaryStatDict = dictionary["primaryStat"] as? EntityDictionary,
              let primaryStat = try? DLItemStat(dictionary: primaryStatDict),
              let level = dictionary["itemLevel"] as? Int,
              let quality = dictionary["quality"] as? Int,
              let isEquipped = dictionary["isEquipped"] as? Bool,
              let canEquip = dictionary["canEquip"] as? Bool,
              let requiredLevel = dictionary["equipRequiredLevel"] as? Int else {
                throw EntityNetworkingError.entityCantBeCreated(reason: "Key value missing")
        }
        
        self.damageType = DLDamageType(rawValue: damageTypeInt) ?? .none
        self.primaryStat = primaryStat
        self.level = level
        self.quality = quality
        self.isEquipped = isEquipped
        self.canEquip = canEquip
        self.equipRequiredLevel = requiredLevel
    }
    
    public var description: String {
        return "Item level: \(level) light: \(primaryStat.value)"
    }
    
    public var dictionary: EntityDictionary {
        return [:]
    }
}
