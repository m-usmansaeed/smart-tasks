//
//  ResponseParser.swift
//  Smart tasks
//
//  Created by Usman Saeed on 06/06/2024.
//

import Foundation
import Alamofire

class ResponseParser {
    
    func parseResponseObject<T : Codable>(
        responseObject: AFDataResponse<Data>,
        ignoreParsing: Bool,
        returnType: T.Type,
        _ apiSuccess: @escaping APISuccessCallback,
        _ apiFailure: @escaping APIFailureCallback) {
            
        switch responseObject.result {
        case .success(let value):
            let decoder = JSONDecoder()

            do {
//                if !ignoreParsing {
//                    if let jsonArray = try JSONSerialization.jsonObject(with: value, options : .allowFragments) as? Parameters {
//                        print(jsonArray)
//                    } else {
//                        print("bad json")
//                    }
//                }
                
                if self.validate(
                    statusCode: 200..<300,
                    unauthenticatedStatusCodes: 400..<500,
                    response: responseObject.response!) {
                    if ignoreParsing {
                        apiSuccess(nil)
                    }else{
                        let response = try decoder.decode(returnType.self, from: value)
                        apiSuccess(response)
                    }
                } else {
                    
                }
            } catch let error {
                print(String(describing: error))
                print(error.localizedDescription)
            }
        case .failure(let error):
            DispatchQueue.main.async {
                print(error.localizedDescription)
                print(String(describing: error))
                if error.localizedDescription == NetworkManagerError.requestTimedOut.rawValue {
                    apiFailure(NetworkManagerError.requestTimedOut.rawValue)
                }else{
                    apiFailure("")
                }
            }
            
        }
    }
    
    func validate<S: Sequence>(
        statusCode acceptableStatusCodes: S,
        unauthenticatedStatusCodes: S,
        response: HTTPURLResponse) -> Bool
        where S.Iterator.Element == Int {
            
        if acceptableStatusCodes.contains(response.statusCode) {
            return true
        } else {
            if unauthenticatedStatusCodes.contains(response.statusCode) {
                print("response.statusCode: \(response.statusCode)")
            }
            return false
        }
    }
}
