//
//  LoginEndpoints.swift
//  Destiny2Api
//
//  Created by Aldo Rogelio Bonilla  Guerrero on 03/07/18.
//  Copyright © 2018 Aldo Rogelio Bonilla  Guerrero. All rights reserved.
//

import Foundation

public enum DLLoginServices: EndpointConfiguration {
    
    case token(code: String)
    case refreshToken(refreshToken: String)
    
    public var serverURL: String {
        return Endpoint().serverURL
    }
    
    public var path: String {
        return "/app/oauth/token/"
    }
    
    public var fullPath: String {
        return "\(serverURL)\(path)"
    }
    
    public var method: webMethod {
        return .POST
    }
    
    public var parameters: BasicDictionary? {
        switch self {
        case .token(let code): return ["grant_type": "authorization_code", "code": code, "client_id": client_Id, "client_secret": clientSecret]
        case .refreshToken(let refreshToken): return ["grant_type": "refresh_token", "refresh_token": refreshToken, "client_id": client_Id, "client_secret": clientSecret]
        }
    }
    
    public var encoding: encoding? {
        return .urlBody
    }
    
    public var headers: [String : String]? {
        return ["Content-Type": "application/x-www-form-urlencoded"]
    }
    
}

public struct DLLoginEndpoints {
    
    public static func getToken(code: String, completion: @escaping ((_ token: DLToken?,_ error: NSError?) -> Void)) {
        
        let getToken = DLLoginServices.token(code: code)
    
        WSAPI.shared.callService(url: getToken.fullPath, method: getToken.method, parameters: getToken.parameters, param_Encoding: getToken.encoding?.parameterEncoding, headers: getToken.headers) { response, error in
            if let errorWeb = error {
                completion(nil, errorWeb)
            } else {
                do {
                    let tokenDecoded = try JSONDecoder().decode(DLToken.self, from: response!)
                    completion(tokenDecoded, nil)
                } catch {
                    completion(nil, NSError(domain: "LibraryApi", code: -3, userInfo: nil))
                }
            }
        }
    }
    
    public static func refreshToken(_ refreshToken: String, completion: @escaping ((_ token: DLToken?,_ error: NSError?) -> Void)) {
        
        let refreshToken = DLLoginServices.refreshToken(refreshToken: refreshToken)
        WSAPI.shared.callService(url: refreshToken.fullPath, method: refreshToken.method, parameters: refreshToken.parameters, param_Encoding: refreshToken.encoding?.parameterEncoding, headers: refreshToken.headers) { response, error in
            if let errorWeb = error {
                completion(nil, errorWeb)
            } else {
                do {
                    let tokenDecoded = try JSONDecoder().decode(DLToken.self, from: response!)
                    completion(tokenDecoded, nil)
                } catch {
                    completion(nil, NSError(domain: "LibraryApi", code: -3, userInfo: nil))
                }
            }
        }
    }
    
}
