//
//  Token.swift
//  kn·Connect
//
//  Created by Aldo Rogelio Bonilla  Guerrero on 10/11/17.
//  Copyright © 2017 Knotion. All rights reserved.
//

import Foundation

public struct DLToken: EntityProtocol, Decodable, CustomStringConvertible, Hashable {
    
    public let expires_in: Double
    public let refresh_token: String
    public let access_token: String
    public let refresh_expires_in: Double
    public let membership_id: String
    
    public init(dictionary: EntityDictionary) throws {
        
        guard let expiration = dictionary["expires_in"] as? Date,
            let refreshToken = dictionary["refresh_token"] as? String,
            let accessToken = dictionary["access_token"] as? String,
            let refreshExpiration = dictionary["refresh_expires_in"] as? Date,
            let membership = dictionary["membership_id"] as? String else {
                throw EntityNetworkingError.entityCantBeCreated(reason: "Key value missing")
        }
        
        expires_in = expiration.timeIntervalSinceNow
        refresh_token = refreshToken
        access_token = accessToken
        refresh_expires_in = refreshExpiration.timeIntervalSinceNow
        membership_id = membership
    }
    
    public var expires_date: Date {
        return Date().addingTimeInterval(expires_in)
    }
    
    public var refresh_expires_date: Date {
        return Date().addingTimeInterval(refresh_expires_in)
    }
    
    public var hashValue: Int {
        return access_token.hashValue
    }

    public var description: String {
        return "Token with access: \(access_token) expires in: \(expires_date)"
    }

    public static func ==(lhs: DLToken, rhs: DLToken) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    public var dictionary: EntityDictionary {
        return [
            "expires_in" : expires_date,
            "refresh_token" : refresh_token,
            "access_token" : access_token,
            "refresh_expires_in": refresh_expires_date,
            "membership_id": membership_id
        ]
    }
}
