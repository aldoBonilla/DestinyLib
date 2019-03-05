//
//  User.swift
//  Destiny2Api
//
//  Created by Aldo Rogelio Bonilla  Guerrero on 17/01/18.
//  Copyright © 2018 Aldo Rogelio Bonilla  Guerrero. All rights reserved.
//

import Foundation

public struct DLUser: EntityProtocol, Decodable, CustomStringConvertible, Hashable {
    
    public let id: String
    public let displayName: String
    public let platform: Int
    
    public init(dictionary: EntityDictionary) throws {
        guard let id = dictionary["membershipId"] as? String,
              let displayName = dictionary["displayName"] as? String,
              let platform =  dictionary["membershipType"] as? Int else {
                throw EntityNetworkingError.entityCantBeCreated(reason: "Key value missing")
        }
        
        self.id = id
        self.displayName = displayName
        self.platform = platform
    }
    
    public var description: String {
        return "User with name: \(displayName)"
    }
    
    public var hashValue: Int {
        return id.hashValue
    }
    
    public static func == (lhs: DLUser, rhs: DLUser) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    public var dictionary: EntityDictionary {
        return [
            "membershipId": id,
            "displayName": displayName,
            "membershipType": platform
        ]
    }
}
