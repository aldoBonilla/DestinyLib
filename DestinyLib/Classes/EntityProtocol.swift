//
//  EntityProtocol.swift
//  kn·Connect
//
//  Created by Aldo Rogelio Bonilla  Guerrero on 13/11/17.
//  Copyright © 2017 Knotion. All rights reserved.
//

import Foundation

public enum EntityNetworkingError: Error {
    case entityCantBeCreated(reason: String)
}

public protocol EntityProtocol {
    
    init(dictionary: EntityDictionary) throws
    var dictionary: EntityDictionary { get }
    static func initEntities(dictionaries: [EntityDictionary]) -> [Self]
}

public extension EntityProtocol {
    public static func initEntities<T: EntityProtocol>(dictionaries: [EntityDictionary]) -> [T] {
        var entities = [T]()
        
        dictionaries.forEach { thisEntity in
            do {
                let entity = try T(dictionary: thisEntity)
                entities.append(entity)
            } catch {
                print("We couldnt proccess this module: \(thisEntity)")
                return
            }
        }
        return entities
    }
}

