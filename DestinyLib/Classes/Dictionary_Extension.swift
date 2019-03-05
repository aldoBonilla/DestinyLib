//
//  Dictionary_Extension.swift
//  Destiny2Api
//
//  Created by Aldo Rogelio Bonilla  Guerrero on 10/07/18.
//  Copyright © 2018 Aldo Rogelio Bonilla  Guerrero. All rights reserved.
//

import Foundation

///Diccionario comun para los init de modelos
public typealias BasicDictionary = Dictionary<String, Any>

///Diccionario comun para los init de modelos
public typealias EntityDictionary = Dictionary<String, Any?>

public extension Dictionary {
    
    func getEntitiesDictionariesFromKeys() -> [EntityDictionary] {
        
        let keys = Array(self.keys)
        var dictionaries = [EntityDictionary]()
        keys.forEach { key in
            if let thisDictionary = self[key] as? EntityDictionary {
                dictionaries.append(thisDictionary)
            }
        }
        return dictionaries
    }
}

