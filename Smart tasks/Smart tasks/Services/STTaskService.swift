//
//  STTaskService.swift
//  Smart tasks
//
//  Created by Usman Saeed on 06/06/2024.
//

import Foundation

class STTaskService {
    
    public static let shared = STTaskService()
    
    func getTaskList(_ success: @escaping ([STTask]) -> (),
                     _ failure: @escaping (String) -> ()){
        NetworkManager.shared.request(
            url: BASE_URL,
            httpMethod: .get,
            returnType: ApiResponse<TaskKeyed>.self, { result in
                if let response = result as? ApiResponse<TaskKeyed>,
                   let tasks = response.data {
                    success(tasks)
                } else {
                    failure("parsing issue")
                }
        }, { error in
            print(error)
            failure(error)
        })
    }

}
