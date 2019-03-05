//
//  GeneralDisplayManifest.swift
//  Destiny2Api
//
//  Created by Aldo Rogelio Bonilla  Guerrero on 18/07/18.
//  Copyright © 2018 Aldo Rogelio Bonilla  Guerrero. All rights reserved.
//

import Foundation

public struct DLDisplayManifest: EntityProtocol, CustomStringConvertible {
    
    public let name: String
    public let about: String
    public let icon: String?
    
    public init(dictionary: EntityDictionary) throws {
        guard let name = dictionary["name"] as? String,
              let about = dictionary["description"] as? String else {
                throw EntityNetworkingError.entityCantBeCreated(reason: "Key value missing")
        }
        self.name = name
        self.about = about
        self.icon = dictionary["icon"] as? String
    }
    
    public var description: String {
        return "Name: \(name), about: \(about)"
    }
    
    public var iconPath: URL? {
        if icon != nil {
            return URL(string: "\(Endpoint().bungieImages)\(icon!)")
        }
        return nil
    }
    
    public var dictionary: EntityDictionary {
        return [
            "name": name,
            "description": about,
            "icon": icon
        ]
    }
}
