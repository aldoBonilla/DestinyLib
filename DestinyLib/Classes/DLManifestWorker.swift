//
//  ManifestWorker.swift
//  Destiny2Api
//
//  Created by Aldo Rogelio Bonilla  Guerrero on 18/07/18.
//  Copyright © 2018 Aldo Rogelio Bonilla  Guerrero. All rights reserved.
//

import Foundation

public struct DLManifestWorker {
    
    public static func getManifestDisplayProperties(type: DLEntityTypeManifest, hash: Int,_ completion:@escaping ((_ displayProperties: DLDisplayManifest?,_ error: NSError?) -> Void)) {
        DLManifestEndpoints.getManifestFor(type, hash: String(hash)) { response, error  in
            if let entityDict = response, let displayDict = entityDict["displayProperties"] as? EntityDictionary {
                do {
                    let manifest = try DLDisplayManifest(dictionary: displayDict)
                    completion(manifest, nil)
                } catch {
                    completion(nil, NSError(domain: "Worker", code: 100, userInfo: ["description": "User data is corrupted"]))
                }
            } else {
                completion(nil, error)
            }
        }
    }
    
    public static func getManifestFor<T: EntityProtocol>(type: DLEntityTypeManifest, hash: Int,_ completion:@escaping ((_ manifest: T?,_ error: NSError?) -> Void)) {
        DLManifestEndpoints.getManifestFor(type, hash: String(hash)) { response, error  in
            if let entityDict = response {
                do {
                    let manifest = try T(dictionary: entityDict)
                    completion(manifest, nil)
                } catch {
                    completion(nil, NSError(domain: "Worker", code: 100, userInfo: ["description": "User data is corrupted"]))
                }
            } else {
                completion(nil, error)
            }
        }
    }
}
