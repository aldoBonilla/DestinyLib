//
//  CharacterEnums.swift
//  Destiny2Api
//
//  Created by Aldo Rogelio Bonilla  Guerrero on 04/07/18.
//  Copyright © 2018 Aldo Rogelio Bonilla  Guerrero. All rights reserved.
//

import Foundation

public enum DLCharacterRace: Int {
    
    case human
    case awoken
    case exo
    case unknown
    
    public var description: String {
        switch self {
        case .human: return "Human"
        case .awoken: return "Awoken"
        case .exo: return "Exo"
        default: return "Unknown"
        }
    }
    
}

public enum DLCharacterClass: Int {
    
    case titan
    case hunter
    case warlock
    case unknown
    
    public var name: String {
        switch self {
        case .titan: return "Titan"
        case .hunter: return "Hunter"
        case .warlock: return "warlock"
        default: return "Unknown"
        }
    }
}

public enum DLBuckets: Int {
    
    case kinectic = 1498876634
    case energy = 2465295065
    case power = 953998645
    case ghost = 4023194814
    case helmet = 3448274439
    case gauntlets = 3551918588
    case chest = 14239492
    case leg = 20886954
    case classArmor = 1585787867
    case subclass = 3284755031
    case emblems = 4274335291
    case ships = 284967655
    case emotes = 1107761855
    case clanBanner = 4292445962
    case mods = 3313201758
    case shaders = 2973005342
    
    public var name: String {
        switch self {
        case .kinectic: return "Kinectic Weapons"
        case .energy: return "Energy Weapons"
        case .power: return "Power Weapons"
        case .ghost: return "Ghosts"
        case .helmet: return "Helmet"
        case .gauntlets: return "Gauntlets"
        case .chest: return "Chest Armor"
        case .leg: return "Leg Armor"
        case .classArmor: return "Class Armor"
        case .subclass: return "Subclass"
        case .emblems: return "Emblems"
        case .ships: return "Ships"
        case .emotes: return "Emotes"
        case .clanBanner: return "Clan Banner"
        case .mods: return "Modifications"
        case .shaders: return "Shaders"
        }
    }
}

public enum DLItemUICategory: Int {
    
    case weapon
    case armor
    case inventory
    
    public var sections: [DLBuckets] {
        switch self {
        case .weapon: return [.kinectic, .energy, .power, .ghost]
        case .armor: return [.helmet, .gauntlets, .chest, .leg, .classArmor]
        case .inventory: return [.mods, .shaders, .ships]
        }
    }
    
}

public enum DLItemLocation: Int {
    case unknown
    case inventory
    case vault
    case vendor
    case postmaster
}

public enum DLDamageType: Int {
    case none
    case kinetic
    case arc
    case thermal
    case void
    case raid
}

public enum DLItemRarity: Int {
    
    case common
    case rare
    case legendary
    case exotic
}

public enum DLBucketCategory: Int {
    
    case invisible
    case item
    case currency
    case equippable
    case ignored
}
