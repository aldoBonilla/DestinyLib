//
//  CurrentSession.swift
//  Destiny2Api
//
//  Created by Aldo Rogelio Bonilla  Guerrero on 03/07/18.
//  Copyright © 2018 Aldo Rogelio Bonilla  Guerrero. All rights reserved.
//

import Foundation

public class DLCurrentSession {
    
    static let shared = DLCurrentSession()
    
    private(set) var token: DLToken? = nil
    private(set) var user: DLUser? = nil
    private(set) var profileVault: [DLInventoryItem]? = nil
    
    public func update(token: DLToken?) {
        self.token = token
    }
    
    public func update(user: DLUser?) {
        self.user = user
    }
    
    public func update(vault: [DLInventoryItem]?) {
        self.profileVault = vault
    }
    
    public func cleanSession() {
        self.user = nil
        self.token = nil
    }
    
    public var userPlatform: Int {
        return user?.platform ?? -1
    }
    
    public var userMembership: String {
        return user?.id ?? ""
    }
}
