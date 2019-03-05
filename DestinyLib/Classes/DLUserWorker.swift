//
//  UserWorker.swift
//  Destiny2Api
//
//  Created by Aldo Rogelio Bonilla  Guerrero on 17/01/18.
//  Copyright © 2018 Aldo Rogelio Bonilla  Guerrero. All rights reserved.
//

import Foundation

public struct DLUserWorker {
    
    public static func basicCurrentUserInfo(_ completion: @escaping((_ error: NSError?) -> Void)) {
        DLUserEndpoints.getCurrentPlayer() { userInfo, error in
            if userInfo != nil {
                do {
                    let user = try DLUser(dictionary: userInfo!)
                    DLCurrentSession.shared.update(user: user)
                    completion(nil)
                } catch {
                    completion(NSError(domain: "Worker", code: 100, userInfo: ["description": "User data is corrupted"]))
                }
            } else {
                completion(error)
            }
        }
    }
    
    public static func basicUserInfo(forPlatform platform: Int, username: String, completion: @escaping((_ user: DLUser?,_ error: NSError?) -> Void )) {
        DLUserEndpoints.searchPlayer(forPlatform: platform, username: username) { userInfo, error in
            if userInfo != nil {
                do {
                    let user = try DLUser(dictionary: userInfo!)
                    completion(user, nil)
                } catch {
                    completion(nil, NSError(domain: "Worker", code: 100, userInfo: ["description": "User data is corrupted"]))
                }
            } else {
                completion(nil, error)
            }
        }
    }
    
    public static func getUserCharacters(_ completion: @escaping((_ characters: [DLCharacter]?, _ error: NSError?) -> Void )) {
        DLUserEndpoints.requestInfo(infoType: .character, forPlatform: DLCurrentSession.shared.userPlatform, userId: DLCurrentSession.shared.userMembership) { response, error in
            if let characterDictionaries = response {
                let characters: [DLCharacter] = DLCharacter.initEntities(dictionaries: characterDictionaries.getEntitiesDictionariesFromKeys())
                completion(characters, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
    public static func getInvetoryItemsFrom(location: DLItemLocationRequest, forCharacter character: String, _ completion: @escaping((_ inventoryItems: [DLInventoryItem]?, _ error: NSError?) -> Void)) {
        DLUserEndpoints.requestInfo(infoType: location.infoType, itemRequested: character, forPlatform: DLCurrentSession.shared.userPlatform, userId: DLCurrentSession.shared.userMembership) { response, error in
            if let responseDict = response,
               let itemDicts = responseDict["items"] as? [EntityDictionary] {
                    let items: [DLInventoryItem] = DLInventoryItem.initEntities(dictionaries: itemDicts)
                    completion(items, nil)
            } else {
                completion(nil, error)
            }
        }
    }

}
