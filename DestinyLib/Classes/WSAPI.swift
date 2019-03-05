//
//  WSAPI.swift
//  kn·Connect
//
//  Created by Aldo Rogelio Bonilla  Guerrero on 10/11/17.
//  Copyright © 2017 Knotion. All rights reserved.
//

import Foundation
import Alamofire

let headerApiDestiny = "X-API-Key"
let destinyApiKey = "aa8ac79909674f1da752313d781f582e"
let client_Id = 23342
let clientSecret = "MfeEvEhIrleMWNhSTmlLeQoy0B8Xrs7pPsqh1D3wlYw"

public enum webMethod: String {
    case OPTIONS, GET, HEAD, POST, PUT, PATCH, DELETE, TRACE, CONNECT
}

public enum encoding {
    
    case url
    case json
    case urlBody
    case multipart
    
    public var parameterEncoding: ParameterEncoding {
        switch self {
        case .url: return URLEncoding.default
        case .json: return JSONEncoding.default
        case .urlBody: return URLEncoding.httpBody
        case .multipart: return MultipartEncoding()
        }
    }
}

public struct MultipartEncoding: ParameterEncoding {
    
    public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        
        var urlRequest = try urlRequest.asURLRequest()
        
        guard let parameters = parameters else { return urlRequest }
        
        let multipart = MultipartFormData()
    
        if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
            urlRequest.setValue("multipart/form-data; boundary=\(multipart.boundary)", forHTTPHeaderField: "Content-Type")
        }
        
        parameters.forEach({ key, value in
            if let thisParam = value as? String {
                multipart.append(thisParam.data(using: .utf8)!, withName: key)
            }
        })
        
        urlRequest.httpBody = try! multipart.encode()
        
        return urlRequest
    }
}

public class WSAPI {
    
    public static let topicNetWorkEnable = NSNotification.Name("NetWorkEnable")
    public static let topicNetWorkDisallow = NSNotification.Name("NetWorkNotEnable")
    
    static let shared = WSAPI()
    
    //Variable para indicar si es por primera vez que se carga la clase para monitorear la red
    static var isFirstCheck = true
    
    var manager: NetworkReachabilityManager?
    
    public func callService(url: String, method: webMethod, parameters: BasicDictionary?, param_Encoding: ParameterEncoding?, headers: [String: String]? = nil, onCompletion: @escaping((_ response: Data?, _ error: NSError?) -> Void )) {
        
        Alamofire.request(url, method: Alamofire.HTTPMethod(rawValue: method.rawValue)!, parameters: parameters, encoding: param_Encoding ?? URLEncoding.default, headers: headers)
            .validate()
            .responseJSON(queue: DispatchQueue.global(), options: .allowFragments, completionHandler: { alamoResponse in
                guard alamoResponse.result.isSuccess else {
                    
                    print("response failed for service: \(url)")
                    onCompletion(nil, NSError(domain: "WSApi", code: alamoResponse.response?.statusCode ?? -1, userInfo: nil))
                    return
                }
                guard let json = alamoResponse.data else {
                    onCompletion(nil, NSError(domain: "WSApi", code: -2, userInfo: nil))
                    return
                }
                onCompletion(json, nil)
            })
    }
    
    public func downloadFile(urlFile: String, toLocation location: URL, completion: @escaping((_ fileSaved: URL?, _ error: NSError?) -> Void )) {
        
        let destination: DownloadRequest.DownloadFileDestination = {_, _ in
            return (location, [.removePreviousFile, .createIntermediateDirectories])
        }
        
        Alamofire.download(urlFile, to: destination).response { response in
            if response.error != nil {
                print("response failed for service: \(urlFile)")
                completion(nil, NSError(domain: "WSApi", code: response.response?.statusCode ?? -1, userInfo: ["descroption": "couldn't download file"]))
                return
            }
            
            guard let destinationUrl = response.destinationURL else {
                print("response failed for service: \(urlFile)")
                completion(nil, NSError(domain: "WSApi", code: response.response?.statusCode ?? -1, userInfo: ["descroption": "couldn't save file"]))
                return
            }
            
            completion(destinationUrl, nil)
        }
    }
    
}

