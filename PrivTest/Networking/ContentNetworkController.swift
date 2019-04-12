//
//  ContentNetworkController.swift
//  PrivTest
//
//  Created by Maxwell Chukwuemeka on 01/04/2019.
//  Copyright © 2019 Maxwell. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import AlamofireObjectMapper
import RealmSwift

struct ContentNetworkController {
    
    static func getOptions(completionHandler: @escaping (NetworkResponseModel) -> Void) {
        DispatchQueue.global(qos: .background).async {
            let endpoints = "options?include=items&limit=50"
            
            let headers = NetworkController.getHeaderWithoutToken()
            
            Alamofire.request(PriveConstants.URL_BASE + endpoints, method: .get, encoding: JSONEncoding.default, headers: headers)
            .validate()
                .responseObject {
                    (response: DataResponse<GetOptionArrayModel>) in
                    
                    var networkResponse = NetworkResponseModel(statusCode: response.response?.statusCode ?? 0)
                    switch response.result {
                    case .success:
                        if let optionResponse = response.result.value {
                        
                            networkResponse.success = true
                            networkResponse.data = optionResponse
                            networkResponse.generalMessage = "Options Retrieved Successfully"
                            do {
                                let realm = try Realm()

                                try realm.write {
                                    realm.add(optionResponse.data, update: true)
                                }
                            }catch {

                            }
                        }
                    case .failure(let err):
                        if response.response == nil {
                            networkResponse = NetworkResponseModel()
                            networkResponse.generalMessage = err.localizedDescription
                            networkResponse.success = false
                        
                        } else {
                            guard let data = response.data else {
                                return
                            }
                            
                            guard let error = response.error else {
                                return
                            }
                            
                            guard let responJSON = try? JSON(data: data) else {
                                return
                            }
                            
                            networkResponse = NetworkResponseModel(statusCode: (response.response?.statusCode ?? 0), error: error, data: responJSON)
                            
                            if let msg = responJSON["message"].string{
                                networkResponse.errorTitle = msg
                            }
                            networkResponse.success = false
                            networkResponse.generalMessage = networkResponse.getErrorMessage()
                        }
                        break
                    }
                    completionHandler(networkResponse)
            }
        }
    }
}
