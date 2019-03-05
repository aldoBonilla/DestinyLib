//
//  ScaledStats.swift
//  Destiny2Api
//
//  Created by Aldo Rogelio Bonilla  Guerrero on 18/07/18.
//  Copyright © 2018 Aldo Rogelio Bonilla  Guerrero. All rights reserved.
//

import Foundation

public struct DLScaledStats: EntityProtocol, CustomStringConvertible, Hashable {
    
    public let hash: Int
    public let maxValue: Int
    public let displayAsNumeric: Bool
    public let displayInterpolations: [(value: Int, weight: Int)]
    
    public init(dictionary: EntityDictionary) throws {
        guard let hash = dictionary["statHash"] as? Int,
              let maxValue = dictionary["maximumValue"] as? Int,
              let displayAsNumeric = dictionary["displayAsNumeric"] as? Bool,
              let displayInterpolations = dictionary["displayInterpolation"] as? [EntityDictionary] else {
                throw EntityNetworkingError.entityCantBeCreated(reason: "Key value missing")
        }
        self.hash = hash
        self.maxValue = maxValue
        self.displayAsNumeric = displayAsNumeric
        var interpolations = [(value: Int, weight: Int)]()
        displayInterpolations.forEach { interpolationDict in
            if let value = interpolationDict["value"] as? Int,
                let weight = interpolationDict["weight"] as? Int {
                interpolations.append((value: value, weight: weight))
            }
        }
        self.displayInterpolations = interpolations
    }
    
    public var description: String {
        return "Scaled Stat hash: \(hash), maxValue: \(maxValue), display as numeric: \(displayAsNumeric)"
    }
    
    public var hashValue: Int {
        return hash
    }
    
    public static func == (lhs: DLScaledStats, rhs: DLScaledStats) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    public var dictionary: EntityDictionary {
        return [:]
    }
}
