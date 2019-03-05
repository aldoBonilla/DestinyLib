//
//  ItemStatInterpolation.swift
//  Destiny2Api
//
//  Created by Aldo Rogelio Bonilla  Guerrero on 17/07/18.
//  Copyright © 2018 Aldo Rogelio Bonilla  Guerrero. All rights reserved.
//

import Foundation

public struct DLItemStatInterpolation: EntityProtocol, CustomStringConvertible, Hashable {
    
    public let hash: Int
    public let maxValue: Int
    public let displayAsNumeric: Bool
    public let statsInterpolation: [(value: Int, weight: Int)]
    
    public init(dictionary: EntityDictionary) throws {
        guard let hash = dictionary["statHash"] as? Int,
              let maxValue = dictionary["maximumValue"] as? Int,
              let displayAsNumeric = dictionary["displayAsNumeric"] as? Bool,
              let interpolationDicts = dictionary["displayInterpolation"] as? [EntityDictionary] else {
                throw EntityNetworkingError.entityCantBeCreated(reason: "Key value missing")
        }
        
        self.hash = hash
        self.maxValue = maxValue
        self.displayAsNumeric = displayAsNumeric
        var statsInterpolation = [(value: Int, weight: Int)] ()
        interpolationDicts.forEach { interDict in
            if let value = interDict["value"] as? Int, let weight = interDict["weight"] as? Int {
                statsInterpolation.append((value: value, weight: weight))
            }
        }
        
        self.statsInterpolation = statsInterpolation
    }
    
    public var description: String {
        return "Stat hash: \(hash), numeric: \(displayAsNumeric)"
    }
    
    public var hashValue: Int {
        return hash
    }
    
    public static func == (lhs: DLItemStatInterpolation, rhs: DLItemStatInterpolation) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    public var dictionary: EntityDictionary {
        return [:]
    }
}
