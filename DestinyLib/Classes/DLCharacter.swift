//
//  Character.swift
//  Destiny2Api
//
//  Created by Aldo Rogelio Bonilla  Guerrero on 04/07/18.
//  Copyright © 2018 Aldo Rogelio Bonilla  Guerrero. All rights reserved.
//

import UIKit

public struct DLCharacter: EntityProtocol, CustomStringConvertible, Hashable {
    
    public let id: String
    public let light: Int
    public let raceType: DLCharacterRace
    public let classType: DLCharacterClass
    public let emblemPath: String
    public let emblemBackgroundPath: String
    public let emblemColor: (red: Int, green: Int, blue: Int, alpha: Int)?
    public let level: Int
    public let percentToNextLevel: Double
    
    public init(dictionary: EntityDictionary) throws {
        guard let id = dictionary["characterId"] as? String,
              let light = dictionary["light"] as? Int,
              let raceRaw = dictionary["raceType"] as? Int,
              let classRaw = dictionary["classType"] as? Int,
              let emblem = dictionary["emblemPath"] as? String,
              let emblemBackground = dictionary["emblemBackgroundPath"] as? String,
              let level = dictionary["baseCharacterLevel"] as? Int,
              let progression = dictionary["percentToNextLevel"] as? Double else {
                throw EntityNetworkingError.entityCantBeCreated(reason: "Key value missing")
        }
        
        self.id = id
        self.light = light
        self.raceType = DLCharacterRace(rawValue: raceRaw) ?? .unknown
        self.classType = DLCharacterClass(rawValue: classRaw) ?? .unknown
        self.emblemPath = emblem
        self.emblemBackgroundPath = emblemBackground
        if let colorDict = dictionary["emblemColor"] as? EntityDictionary {
            if let red = colorDict["red"] as? Int,
                let green = colorDict["green"] as? Int,
                let blue = colorDict["blue"] as? Int,
                let alpha = colorDict["alpha"] as? Int {
                self.emblemColor = (red: red, green: green, blue: blue, alpha: alpha)
            } else { self.emblemColor = nil }
        } else { self.emblemColor = nil }
        self.level = level
        self.percentToNextLevel = progression
    }
    
    public var description: String {
        return "Character class: \(classType), with light: \(light)"
    }
    
    public var hashValue: Int {
        return id.hashValue
    }
    
    public static func == (lhs: DLCharacter, rhs: DLCharacter) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    public var urlBannerBackground: URL? {
        return URL(string: "\(Endpoint().bungieImages)\(emblemBackgroundPath)")
    }
    
    public var dictionary: EntityDictionary {
        return [
            "characterId": id,
            "light": light,
            "raceType": raceType.rawValue,
            "classType": classType.rawValue,
            "emblemPath": emblemPath,
            "emblemBackgroundPath": emblemBackgroundPath,
            "baseCharacterLevel": level,
            "percentToNextLevel": percentToNextLevel
        ]
    }
}
