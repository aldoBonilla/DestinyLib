//
//  ManifestEndpoint.swift
//  Destiny2Api
//
//  Created by Aldo Rogelio Bonilla  Guerrero on 05/07/18.
//  Copyright © 2018 Aldo Rogelio Bonilla  Guerrero. All rights reserved.
//

import Foundation

public enum DLManifestMethods: EndpointConfiguration {
    
    case getManifestFor(entityType: DLEntityTypeManifest, hashId: String)
    
    public var serverURL: String {
        return Endpoint().serverURL
    }
    
    public var path: String {
        switch self {
        case .getManifestFor(let entityType, let hashId): return "/Destiny2/Manifest/\(entityType.rawValue)\(hashId)"
        }
    }
    
    public var fullPath: String {
        return "\(serverURL)\(path)"
    }
    
    public var method: webMethod {
        return .GET
    }
    
    public var parameters: BasicDictionary? {
        return nil
    }
    
    public var encoding: encoding? {
        return .url
    }
    
    public var headers: [String : String]? {
        return [headerApiDestiny: destinyApiKey]
    }
    
}

public struct DLManifestEndpoints {
    
    public static func getManifestFor(_ entityType: DLEntityTypeManifest, hash: String, completion: @escaping ((_ userInfo: EntityDictionary?,_ error: NSError?) -> Void )) {
        
        let getInfo = DLManifestMethods.getManifestFor(entityType: entityType, hashId: hash)
        
        WSAPI.shared.callService(url: getInfo.fullPath, method: getInfo.method, parameters: getInfo.parameters, param_Encoding: getInfo.encoding?.parameterEncoding, headers: getInfo.headers) { response, error in
            if error != nil {
                completion(nil, error)
            } else {
                guard let responseInfo = try? JSONSerialization.jsonObject(with: response!, options: []) as! EntityDictionary, let responseData = responseInfo["Response"] as? EntityDictionary else {
                    completion(nil, NSError(domain: "LibraryApi", code: -3, userInfo: nil))
                    return
                }
                completion(responseData, nil)
            }
        }
    }
}
