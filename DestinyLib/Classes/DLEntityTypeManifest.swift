//
//  ManifestEnums.swift
//  Destiny2Api
//
//  Created by Aldo Rogelio Bonilla  Guerrero on 18/07/18.
//  Copyright © 2018 Aldo Rogelio Bonilla  Guerrero. All rights reserved.
//

import Foundation

public enum DLEntityTypeManifest: String {
    
    case item = "DestinyInventoryItemDefinition/"
    case equipmentSlot = "DestinyEquipmentSlotDefinition/"
    case bucket = "DestinyInventoryBucketDefinition/"
    case perk = "DestinySandboxPerkDefinition/"
    case stat = "DestinyStatDefinition/"
    case statGroup = "DestinyStatGroupDefinition/"
}
