//
//  UserEndpoints.swift
//  Destiny2Api
//
//  Created by Aldo Rogelio Bonilla  Guerrero on 17/01/18.
//  Copyright © 2018 Aldo Rogelio Bonilla  Guerrero. All rights reserved.
//

import Foundation

public enum DLUserMethods: EndpointConfiguration {
    
    case searchPlayer(platformType: Int, username: String)
    case infoRequest(platformType: Int, id: String, infoType: DLUserInfoType, itemRequested: String)
    case currentUserInfo
    
    public var serverURL: String {
        return Endpoint().serverURL
    }
    
    public var path: String {
        switch self {
        case .searchPlayer(let platform, let username): return "/SearchDestinyPlayer/\(platform)/\(username)"
        case .infoRequest(let platform, let userid, let infoType, let itemRequested): return "/Destiny2/\(platform)/Profile/\(userid)/\(infoType.additionalPath)\(itemRequested)/"
        case .currentUserInfo: return "/User/GetMembershipsForCurrentUser/"
        }
    }
    
    public var fullPath: String {
        return "\(serverURL)\(path)"
    }
    
    public var method: webMethod {
        return .GET
    }
    
    public var parameters: BasicDictionary? {
        switch self {
        case .searchPlayer, .currentUserInfo: return nil
        case .infoRequest( _, _, let requestType, _): return ["components": "\(requestType.componentValue)"]
        }
    }
    
    public var encoding: encoding? {
        return .url
    }
    
    public var headers: [String : String]? {
        switch self {
        case .searchPlayer: return [headerApiDestiny: destinyApiKey]
        case .currentUserInfo: return [headerApiDestiny: destinyApiKey, "Authorization": "Bearer \(DLCurrentSession.shared.token!.access_token)"]
        case .infoRequest(_, _, let requestType, _):
            if requestType.privacyLvl == 2 {
                return ["Authorization": "Bearer \(DLCurrentSession.shared.token!.access_token)", headerApiDestiny: destinyApiKey]
            }
            else {return [headerApiDestiny: destinyApiKey] }
        }
    }
}

public struct DLUserEndpoints {
    
    public static func getCurrentPlayer(completion: @escaping ((_ userInfo: EntityDictionary?,_ error: NSError?) -> Void )) {
        
        let currentPlayer = DLUserMethods.currentUserInfo
        
        WSAPI.shared.callService(url: currentPlayer.fullPath, method: currentPlayer.method, parameters: currentPlayer.parameters, param_Encoding: currentPlayer.encoding?.parameterEncoding, headers: currentPlayer.headers) { response, error in
            
            if error != nil {
                completion(nil, error)
            } else {
                guard let responseInfo = try? JSONSerialization.jsonObject(with: response!, options: []) as! EntityDictionary, let responseObjects = responseInfo["Response"] as? EntityDictionary, let memberships = responseObjects["destinyMemberships"] as? [EntityDictionary], let thisMembership = memberships.first else {
                    completion(nil, NSError(domain: "LibraryApi", code: -3, userInfo: nil))
                    return
                }
                completion(thisMembership, nil)
            }
            
        }
    }
    
    public static func searchPlayer(forPlatform platform: Int, username: String, completion: @escaping ((_ userInfo: EntityDictionary?,_ error: NSError?) -> Void )) {
        
        let search = DLUserMethods.searchPlayer(platformType: platform, username: username)
            
        WSAPI.shared.callService(url: search.fullPath, method: search.method, parameters: search.parameters, param_Encoding: search.encoding?.parameterEncoding, headers: search.headers) { response, error in
            if error != nil {
                completion(nil, error)
            } else {
                guard let responseInfo = try? JSONSerialization.jsonObject(with: response!, options: []) as! EntityDictionary, let response = responseInfo["Response"] as? [EntityDictionary], let userInfo = response.first else {
                    completion(nil, NSError(domain: "LibraryApi", code: -3, userInfo: nil))
                    return
                }
                completion(userInfo, nil)
            }
        }
    }
    
    public static func requestInfo(infoType infoRequested: DLUserInfoType, itemRequested: String = "", forPlatform platform: Int, userId: String, completion: @escaping ((_ userInfo: EntityDictionary?, _ error: NSError?) -> Void )) {
        let infoRequest = DLUserMethods.infoRequest(platformType: platform, id: userId, infoType: infoRequested, itemRequested: itemRequested)
        WSAPI.shared.callService(url: infoRequest.fullPath, method: infoRequest.method, parameters: infoRequest.parameters, param_Encoding: infoRequest.encoding?.parameterEncoding, headers: infoRequest.headers) { response, error in
            if error != nil {
                completion(nil, error)
            } else {
                guard let responseInfo = try? JSONSerialization.jsonObject(with: response!, options: []) as! EntityDictionary,
                      let responseData = responseInfo["Response"] as? EntityDictionary,
                      let requestedDict = responseData[infoRequested.keyword] as? EntityDictionary,
                      let requestedData = requestedDict["data"] as? EntityDictionary else {
                    completion(nil, NSError(domain: "LibraryApi", code: -3, userInfo: nil))
                    return
                }
                completion(requestedData, nil)
            }
        }
    }
    
}
