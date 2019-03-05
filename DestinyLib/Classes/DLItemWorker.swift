//
//  ItemWorker.swift
//  Destiny2Api
//
//  Created by Aldo Rogelio Bonilla  Guerrero on 09/07/18.
//  Copyright © 2018 Aldo Rogelio Bonilla  Guerrero. All rights reserved.
//

import Foundation

public class DLItemWorker {
    
    public static func orderBucketsFor(category: DLItemUICategory, withItems items: [DLItemUI]) -> [(name: String, sectionItems: [DLItemUI])] {
        
        var uiSections = [(name: String, sectionItems: [DLItemUI])]()
        
        category.sections.forEach { section in
            let sectionItems = items.filter({$0.inventory.bucketHash == section.rawValue})
            let thisUISection = (name: section.name, sectionItems:sectionItems)
            uiSections.append(thisUISection)
        }
        
        return uiSections
    }
    
    public static func getItemsFor(characterId: String, completion: @escaping((_ items: [DLItemUI]) -> Void)) {
        
        var equipementItems = [DLItemUI]()
        var inventoryItems = [DLItemUI]()
        
        let group = DispatchGroup()
        group.enter()
        DLUserWorker.getInvetoryItemsFrom(location: .equipment, forCharacter: characterId) { items, error in
            if items != nil {
                getFullItems(items!) { uiItems in
                    equipementItems = uiItems
                    group.leave()
                }
            } else {
                group.leave()
            }
        }

        group.enter()
        DLUserWorker.getInvetoryItemsFrom(location: .inventory, forCharacter: characterId) { items, error in
            if items != nil {
                getFullItems(items!) { uiItems in
                    inventoryItems = uiItems
                    group.leave()
                }
            } else {
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            let totalItems = equipementItems + inventoryItems
            completion(totalItems)
        }
    }
    
    public static func getFullItems(_ items: [DLInventoryItem], completion: @escaping((_ fullItems: [DLItemUI]) ->Void)) {
    
        var fullItems = [DLItemUI]()
        let group = DispatchGroup()
        
        for inventoryItem in items {
            group.enter()
            DLItemWorker.getItemUI(inventoryItem) { fullItem, error in
                if fullItem != nil {
                    fullItems.append(fullItem!)
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            completion(fullItems)
        }
    }
    
    
    public static func getItemUI(_ itemInventory: DLInventoryItem, completion: @escaping((_ item: DLItemUI?, _ error: NSError?) -> Void )) {
        
        var manifest: DLItemManifest?
        var instance: DLItemInstance?
        var error: NSError?
        
        let group = DispatchGroup()
        group.enter()
        
        DLManifestWorker.getManifestFor(type: .item, hash: itemInventory.hash) { (entity: DLItemManifest?, workerError) in
            manifest = entity
            error = workerError
            group.leave()
        }
        
        if let instanceId = itemInventory.instance {
            group.enter()
            DLItemWorker.getItemInstance(instanceId) { itemInstance, webError in
                instance = itemInstance
                error = webError
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            if manifest != nil {
                let fullItem = DLItemUI(itemInventory: itemInventory, itemInstance: instance, itemManifest: manifest!)
                completion(fullItem, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
    public static func getItemInstance(_ instanceId: String, _ completion: @escaping((_ inventoryItems: DLItemInstance?, _ error: NSError?) -> Void)) {
        
        DLUserEndpoints.requestInfo(infoType: .itemInstance, itemRequested: instanceId, forPlatform: DLCurrentSession.shared.userPlatform, userId: DLCurrentSession.shared.userMembership) { response, error in
            
            if let instanceDict = response {
                do {
                    let item = try DLItemInstance(dictionary: instanceDict)
                    completion(item, nil)
                } catch {
                    completion(nil, NSError(domain: "Worker", code: 100, userInfo: ["description": "User data is corrupted"]))
                }
            } else {
                completion(nil, error)
            }
            
        }
    }
    
    public static func getPerksUIFor(_ instanceId: String, _ completion: @escaping((_ perks: [DLPerkUI]) -> Void )) {
        DLItemWorker.getPerksFor(instanceId) { wsPerks, error in
            if wsPerks != nil {
                let visiblePerks = wsPerks!.filter { $0.visible == true }
                let group = DispatchGroup()
                var uiPerks = [DLPerkUI]()
                visiblePerks.forEach { perk in
                    group.enter()
                    getPerkUI(perk) { perkUI, error in
                        if perkUI != nil {
                            uiPerks.append(perkUI!)
                        }
                        group.leave()
                    }
                }
                
                group.notify(queue: .main) {
                    completion(uiPerks)
                }
            } else {
                completion([])
            }
        }
    }
    
    public static func getPerkUI(_ itemPerk: DLItemPerk, _ completion: @escaping((_ perk: DLPerkUI?, _ error: NSError?) -> Void )) {
        
        DLManifestWorker.getManifestFor(type: .perk, hash: itemPerk.hash) { (manifest: DLPerkManifest?, error) in
            if manifest != nil {
                let perkUI = DLPerkUI(name: manifest!.display.name, about: manifest!.display.about, icon: itemPerk.icon)
                completion(perkUI, nil)
            }
            else {
                completion(nil, error)
            }
        }
    }
    
    public static func getPerksFor(_ instanceId: String, _ completion: @escaping((_ perks: [DLItemPerk]?, _ error: NSError?) -> Void )) {
        
        DLUserEndpoints.requestInfo(infoType: .itemInstancePerks, itemRequested: instanceId, forPlatform:  DLCurrentSession.shared.userPlatform, userId:  DLCurrentSession.shared.userMembership) { response, error in
            if let perksData = response, let perksDicts = perksData["perks"] as? [EntityDictionary] {
                let perks: [DLItemPerk] = DLItemPerk.initEntities(dictionaries: perksDicts)
                completion(perks, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
}
