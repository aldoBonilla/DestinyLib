//
//  ItemManifest.swift
//  Destiny2Api
//
//  Created by Aldo Rogelio Bonilla  Guerrero on 09/07/18.
//  Copyright © 2018 Aldo Rogelio Bonilla  Guerrero. All rights reserved.
//

import UIKit

public struct DLItemManifest: EntityProtocol, CustomStringConvertible {

    public let display: DLDisplayManifest
    public let typeName: String
    public let icon: String?
    public let color: (red: Int, green: Int, blue: Int, alpha: Int)?
    public let screenshot: String?
    public let statsGroupHash: Int?
    
    public init(dictionary: EntityDictionary) throws {
        guard let displayProp = dictionary["displayProperties"] as? EntityDictionary,
              let displayManifest = try? DLDisplayManifest(dictionary: displayProp),
              let typeName = dictionary["itemTypeDisplayName"] as? String else {
                throw EntityNetworkingError.entityCantBeCreated(reason: "Key value missing")
        }
        
        self.display = displayManifest
        self.typeName = typeName
        self.icon = displayProp["icon"] as? String
        if let colorDict = dictionary["emblemColor"] as? EntityDictionary {
            if let red = colorDict["red"] as? Int,
                let green = colorDict["green"] as? Int,
                let blue = colorDict["blue"] as? Int,
                let alpha = colorDict["alpha"] as? Int {
                self.color = (red: red, green: green, blue: blue, alpha: alpha)
            } else { self.color = nil }
        } else { self.color = nil }
        self.screenshot = dictionary["screenshot"] as? String
        if let statsDict = dictionary["stats"] as? EntityDictionary, let groupHash = statsDict["statGroupHash"] as? Int { self.statsGroupHash = groupHash } else { self.statsGroupHash = nil }
    }
    
    public var urlScreenshot: URL? {
        if screenshot != nil {
            return URL(string: "\(Endpoint().bungieImages)\(screenshot!)")
        }
        return nil
    }

    public var description: String {
        return "Item name: \(display.name)"
    }

    public var dictionary: EntityDictionary {
        return [:]
    }
}
