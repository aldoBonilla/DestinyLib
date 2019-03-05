//
//  Token_Persistance.swift
//  kn·Connect
//
//  Created by Aldo Rogelio Bonilla  Guerrero on 13/11/17.
//  Copyright © 2017 Knotion. All rights reserved.
//

import Foundation
import RealmSwift

public class DLToken_Persistance: Object {
    
    @objc dynamic var expires_in: Date? = nil
    @objc dynamic var refresh_token: String = ""
    @objc dynamic var access_token: String = ""
    @objc dynamic var refresh_expires_in: Date? = nil
    @objc dynamic var membership_id: String = ""
    
    public override static func primaryKey() -> String? {
        return "access_token"
    }
    
    public convenience init?(dictionary: EntityDictionary) {
        self.init()
        guard let expiration = dictionary["expires_in"] as? Date,
              let refreshToken = dictionary["refresh_token"] as? String,
              let accessToken = dictionary["access_token"] as? String,
              let refreshExpiration = dictionary["refresh_expires_in"] as? Date,
              let membership = dictionary["membership_id"] as? String else {
                return nil
        }
        
        expires_in = expiration
        refresh_token = refreshToken
        access_token = accessToken
        refresh_expires_in = refreshExpiration
        membership_id = membership
    }
    
    public var dictionary: EntityDictionary {
        return [
            "expires_in" : expires_in,
            "refresh_token" : refresh_token,
            "access_token" : access_token,
            "refresh_expires_in": refresh_expires_in,
            "membership_id": membership_id
        ]
    }
}
