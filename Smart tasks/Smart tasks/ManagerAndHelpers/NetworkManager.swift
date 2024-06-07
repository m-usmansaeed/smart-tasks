//
//  NetworkManager.swift
//  Smart tasks
//
//  Created by Usman Saeed on 06/06/2024.
//

import Foundation
import Alamofire

typealias Parameters = [String: Any]
typealias APISuccessCallback = (_ result:Any?) -> Void
typealias APIFailureCallback = (_ error:String) -> Void

public protocol JSONEmptyRepresentable {
    associatedtype CodingKeyType: CodingKey
}

public enum NetworkManagerError: String {
    case requestTimedOut = "URLSessionTask failed with error: The request timed out."
}

class NetworkManager: NSObject {
    
    static let shared = NetworkManager()
    var reachability: Reachability!
        
    private override init() {
        super.init()
        // Initialise reachability
        do {
            reachability = try Reachability()
        } catch {
            print(error)
        }
    }
    
    static func isReachable() -> Bool {
        if (NetworkManager.shared.reachability).connection != .unavailable {
            return true
        }else{
            return false
        }
    }
    
    private lazy var sessionManager: Session? = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 360
        configuration.timeoutIntervalForResource = 360
        let manager = Alamofire.Session(configuration: configuration)
        return manager
    }()
    
    func request<T : Codable>(
        url: String,
        httpMethod: HTTPMethod,
        parameters: Parameters? = nil,
        returnType: T.Type,
        userInfoExtras : [CodingUserInfoKey : Any]? = nil,
        ignoreParsing: Bool = false,
        _ apiSuccess: @escaping APISuccessCallback,
        _ apiFailure: @escaping APIFailureCallback){
            
            let finalUrl = url
            let header: HTTPHeaders = [
                "Content-Type": "application/json",
                "Accept": "application/json"
            ]
            
            if NetworkManager.isReachable() {
                
                print(finalUrl)
                print(parameters.unwrapped(defaultV: [:]))
                let encoding: ParameterEncoding = (httpMethod == .get) ? URLEncoding.default : JSONEncoding.default
                
                self.sessionManager?.request(
                    finalUrl, method: httpMethod, 
                    parameters: parameters,
                    encoding: encoding,
                    headers: header)
                .responseData { (responseObject) in
                    ResponseParser().parseResponseObject(
                        responseObject: responseObject,
                        ignoreParsing: ignoreParsing,
                        returnType: returnType,
                        apiSuccess, apiFailure)
                }
            }
            else{
                apiFailure("Please check you internet connection.")
            }
        }
    
}
