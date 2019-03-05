//
//  LoginWorker.swift
//  kn·Connect
//
//  Created by Jorge Armando Rebollo Jiménez on 26/12/17.
//  Copyright (c) 2017 Knotion. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import Foundation

let lastUserLogged = "lastUserLogged"
let loggedInOffline = "loggedInOffline"

public class DLLoginWorker {
    // MARK: Worker Singleton
    private init() { }
    public static let shared = DLLoginWorker()
    
    // MARK: Session Scene Works
    
    public func validateCurrentToken(onCompletion: @escaping((_ error: NSError?) -> Void)) {
        let realmApi = RealmApi()
        
        guard let thisToken = realmApi.realm.objects(DLToken_Persistance.self).first, let token = try? DLToken(dictionary: thisToken.dictionary) else {
            onCompletion(NSError(domain: "LoginWorker", code: -1, userInfo: ["error": "Token value is compromissed"]))
            return
        }
        
        DLCurrentSession.shared.update(token: token)
        
        if Date() >= thisToken.expires_in! {
            
            DLLoginEndpoints.refreshToken(thisToken.refresh_token) { response, error in
                if let newToken = response {
                    DLCurrentSession.shared.update(token: newToken)
                    
                    if let tokenPersistance = DLToken_Persistance(dictionary: newToken.dictionary) {
                        let realmAPI = RealmApi()
                        realmAPI.write(tokenPersistance)
                    }
                    
                    onCompletion(nil)
                    
                } else {
                    onCompletion(error)
                }
            }
        } else {
            onCompletion(nil)
        }
    }
    
    public func doLogin(with code:String, onCompletion: @escaping((_ error: NSError?) -> Void)) {
        
        DLLoginEndpoints.getToken(code: code) { response, error in
            
            if let newToken = response {
                DLCurrentSession.shared.update(token: newToken)
                
                if let tokenPersistance = DLToken_Persistance(dictionary: newToken.dictionary) {
                    let realmAPI = RealmApi()
                    realmAPI.write(tokenPersistance)
                }
                
                onCompletion(nil)
                
            } else {
                onCompletion(error)
            }
        }
    }
    
}