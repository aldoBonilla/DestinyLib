//
//  Item.swift
//  Destiny2Api
//
//  Created by Aldo Rogelio Bonilla  Guerrero on 05/07/18.
//  Copyright © 2018 Aldo Rogelio Bonilla  Guerrero. All rights reserved.
//

import Foundation

public struct DLItemUI: CustomStringConvertible {
    
    public let inventory: DLInventoryItem
    public let instance: DLItemInstance?
    public let manifest: DLItemManifest
    
    public init(itemInventory: DLInventoryItem, itemInstance: DLItemInstance? = nil, itemManifest: DLItemManifest) {
        
        self.inventory = itemInventory
        self.instance = itemInstance
        self.manifest = itemManifest

    }
    
    public var description: String {
        return "Item name: \(manifest.display.name)"
    }
}

public struct DLPerkUI {
    
    public let icon: String
    public let name: String
    public let about: String
    
    public init(name: String, about: String, icon: String) {
        self.name = name
        self.about = about
        self.icon = icon
    }
    
    public var perkIcon: URL? {
        return URL(string: "\(Endpoint().bungieImages)\(icon)")
    }
}

public struct DLStatUI {
    
    public let name: String
    public let value: Int
    public let maxValue: Int
    public let isNumeric: Bool
    
    public init(name: String, value: Int, maxValue: Int, isNumeric: Bool) {
        self.name = name
        self.value = value
        self.maxValue = maxValue
        self.isNumeric = isNumeric
    }
}


