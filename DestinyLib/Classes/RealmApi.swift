//
//  RealmApi.swift
//  Knotion
//
//  Created by Jorge Armando Rebollo Jiménez on 28/07/17.
//  Copyright © 2017 ia. All rights reserved.
//

import Foundation
import RealmSwift

public protocol RealmCascadeDeleteProtocol {
    var listsToDelete: [AnyObject?] { get }
}

public func cascadingDelete(object: AnyObject?) {
    
    if let deletable = object as? RealmCascadeDeleteProtocol {
        for child in deletable.listsToDelete {
            cascadingDelete(object: child)
        }
    }
    
    if let realmObject = object as? Object {
        let realmApi = RealmApi()
        realmApi.delete(realmObject)
    }
}

extension List: RealmCascadeDeleteProtocol {
    
    public var listsToDelete: [AnyObject?] {
        return self.compactMap { $0 as AnyObject }
    }
}

public class RealmApi {
    
    //Change
    let realm = try! Realm()
    
    ///Escribe una entidad en el realm configurado por default
    public func write(_ entity: Object) {
        do {
            try realm.write {
                realm.add(entity, update: true)
            }
        } catch {
            print(error)
        }
    }
    
    ///Escribe una colección de entidades en el realm configurado por default
    public func write(_ entity: [Object]) {
        try! realm.write {
            realm.add(entity, update: true)
        }
    }
    
    ///Borra una entidad del realm default
    public func delete(_ entity: Object) {
        try! realm.write({
            realm.delete(entity)
        })
    }
    
    ///Borra una colección de entidades del realm configurado por default
    public func delete(_ entities: [Object]) {
        try! realm.write({
            realm.delete(entities)
        })
    }
    
    ///Borra todas las entidades del realm configurado por default
    public func deleteAll() {
        try! realm.write({
            realm.deleteAll()
        })
    }
    
    
    /**
     Método para seleccionar todos los objetos de un tipo de la base de datos
     
     - Parameters:
     
         - className: Nombre de la clase sobre el cual se va hacer un "select * from"
         - predicate: Query que se va a realizar dentro de la base de datos, si es nulo no se ejecuta ningún filtro
         
         
         Returns: Regresa un arreglo del tipo pasado por el parámetro Tipo
     */
    public func select(className type:AnyClass, predicate query:NSPredicate?) -> [Object]{
    
        let tipoClase = type as? Object.Type
        let resultadosSelect = query != nil ? realm.objects(tipoClase!).filter(query!) : realm.objects(tipoClase!)
        let results = Array(resultadosSelect)
        
        return results
    }

}

