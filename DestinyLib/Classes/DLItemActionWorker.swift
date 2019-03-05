//
//  ItemActionWorker.swift
//  Destiny2Api
//
//  Created by Aldo Rogelio Bonilla  Guerrero on 20/07/18.
//  Copyright © 2018 Aldo Rogelio Bonilla  Guerrero. All rights reserved.
//

import Foundation

public struct DLItemActionWorker {
    
    public static func transferItem(item: DLItemUI, toVault: Bool, characterId: String, _ completion: @escaping (_ error: NSError?) -> Void) {
        
        DLItemActionsEndpoints.transferItem(item.inventory.hash, instance: Int(item.inventory.instance!)!, toVault: toVault, character: Int(characterId)!, platform: DLCurrentSession.shared.userPlatform) { error in
            completion(error)
        }
    }
}
