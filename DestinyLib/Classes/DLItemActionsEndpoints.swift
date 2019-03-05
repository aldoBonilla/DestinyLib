//
//  ItemActionsEndpoints.swift
//  Destiny2Api
//
//  Created by Aldo Rogelio Bonilla  Guerrero on 20/07/18.
//  Copyright © 2018 Aldo Rogelio Bonilla  Guerrero. All rights reserved.
//

import Foundation

public enum DLItemActionsMethods: EndpointConfiguration {
    
    case transferItem(hash: Int, stackSize: Int, toVault: Bool, instanceId: Int, character: Int, platform: Int)
    case equipItem(instance: Int, character: Int, platform: Int)
    case changeLockStatus(state: Bool, instance: Int, character: Int, platform: Int)
    
    public var serverURL: String {
        return Endpoint().serverURL
    }
    
    public var path: String {
        switch self {
        case .transferItem: return "/Destiny2/Actions/Items/TransferItem/"
        case .equipItem: return "/Destiny2/Actions/Items/EquipItem/"
        case .changeLockStatus: return "/Destiny2/Actions/Items/SetLockState/"
        }
    }
    
    public var fullPath: String {
        return "\(serverURL)\(path)"
    }
    
    public var method: webMethod {
        return .POST
    }
    
    public var parameters: BasicDictionary? {
        switch self {
        case .transferItem(let hash, let stackSize, let toVault, let instance, let characterId, let platform): return [
                "itemReferenceHash": hash,
                "stackSize": stackSize,
                "transferToVault": toVault,
                "itemId": instance,
                "characterId": characterId,
                "membershipType": platform
            ]
        case .equipItem(let instance, let characterId, let platform): return [
                "itemId": instance,
                "characterId": characterId,
                "membershipType": platform
            ]
        case .changeLockStatus(let state, let instance, let characterId, let platform): return [
                "state": state,
                "itemId": instance,
                "characterId": characterId,
                "membershipType": platform
            ]
        }
    }
    
    public var encoding: encoding? {
        return .json
    }
    
    public var headers: [String : String]? {
        return [headerApiDestiny: destinyApiKey,  "Authorization": "Bearer \(DLCurrentSession.shared.token!.access_token)"]
    }
}

struct DLItemActionsEndpoints {
    
    public static func transferItem(_ hash: Int, instance: Int, stackSize: Int = 1, toVault: Bool, character: Int, platform: Int, _ completion: @escaping ((_ error: NSError?) -> Void )) {
        let transfer = DLItemActionsMethods.transferItem(hash: hash, stackSize: stackSize, toVault: toVault, instanceId: instance, character: character, platform: platform)
        
        WSAPI.shared.callService(url: transfer.fullPath, method: transfer.method, parameters: transfer.parameters, param_Encoding: transfer.encoding?.parameterEncoding, headers: transfer.headers) { response, error in
            if error != nil {
                completion(error)
            } else {
                guard let responseInfo = try? JSONSerialization.jsonObject(with: response!, options: []) as! EntityDictionary,
                      let errorCode = responseInfo["ErrorCode"] as? Int,
                      errorCode == 1 else {
                        completion(NSError(domain: "LibraryApi", code: -3, userInfo: nil))
                        return
                }
                completion(nil)
            }
        }
    }
}
