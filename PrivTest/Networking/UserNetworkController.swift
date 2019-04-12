//
//  UserNetworkController.swift
//  PrivTest
//
//  Created by Maxwell Chukwuemeka on 19/03/2019.
//  Copyright © 2019 Maxwell. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import AlamofireObjectMapper
import Realm
import RealmSwift

class UserNetworkController {
    
    static func auth(phone: String, password: String, completionHandler: @escaping (NetworkResponseModel) -> Void) {
        DispatchQueue.global(qos: .background).async {
            let endpoint = "user/auth"
            
            let headers: HTTPHeaders = [
                "Accept": "application/json"
            ]
            
            let parameters: Parameters = [
                "password": password,
                "phone": phone
            ]
            
            Alamofire.request(PriveConstants.URL_BASE + endpoint, method: .post, parameters: parameters, encoding: JSONEncoding.default,
            headers: headers)
            .validate()
            .responseObject{
                (response: DataResponse<AuthUserResponseModel>) in
                
                var networkResponse = NetworkResponseModel(statusCode: (response.response?.statusCode ?? 0))
                switch response.result {
                case .success:
                    if let authUserResponseModel = response.result.value {
                        
                        if let userDataObject = authUserResponseModel.data {
                        print(userDataObject)
                            do {
                               let realm = try Realm()
                                
                                let previousUSer = realm.objects(AuthUserModel.self)
                                
                                try realm.write {
                                    realm.delete(previousUSer)
                                }
                                
                                try realm.write {
                                    realm.add(userDataObject)
                                    
//                                    let defaults = UserDefaults.standard  its like sharedpreference
//                                    defaults.set(userDataObject.id, forKey: PriverdoConstants.userDefaultsKeyCurrentUserId)
                                }
                                
                                //print("USERDATAOBJECT ==> \(userDataObject)")
                                
                                networkResponse.data = userDataObject
                                networkResponse.success = true
                                
                            }catch{
                                print("Error\(error)")
                            }
                            
                        }else {
                            print("It failed me")
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
                    
                    break;
                }
                completionHandler(networkResponse)
            }
            
        }
    }
}
