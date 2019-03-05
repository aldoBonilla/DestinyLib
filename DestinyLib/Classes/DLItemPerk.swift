//
//  ItemPerk.swift
//  Destiny2Api
//
//  Created by Aldo Rogelio Bonilla  Guerrero on 17/07/18.
//  Copyright © 2018 Aldo Rogelio Bonilla  Guerrero. All rights reserved.
//

import Foundation

public final class DLItemPerk: EntityProtocol, CustomStringConvertible, Hashable {
    
    public let hash: Int
    public let icon: String
    public let isActive: Bool
    public let visible: Bool
    
    public init(dictionary: EntityDictionary) throws {
        guard let hash = dictionary["perkHash"] as? Int,
              let icon = dictionary["iconPath"] as? String,
              let active = dictionary["isActive"] as? Bool,
              let visible = dictionary["visible"] as? Bool else {
                throw EntityNetworkingError.entityCantBeCreated(reason: "Key value missing")
        }
        
        self.hash = hash
        self.icon = icon
        self.isActive = active
        self.visible = visible
    }
    
    public var description: String {
        return "Perk with Hash: \(hash)"
    }
    
    public var hashValue: Int {
        return hash
    }
    
    public static func == (lhs: DLItemPerk, rhs: DLItemPerk) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    public var perkIcon: URL? {
        return URL(string: "\(Endpoint().bungieImages)\(icon)")
    }
    
    public var dictionary: EntityDictionary {
        return [:]
    }
}
