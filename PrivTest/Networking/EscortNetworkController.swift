//
//  EscortNetworkController.swift
//  PrivTest
//
//  Created by Maxwell Chukwuemeka on 20/03/2019.
//  Copyright © 2019 Maxwell. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import AlamofireObjectMapper
import RealmSwift

struct EscortNetworkController {
    
    static func getMeAsEscort(completionHandler: @escaping (NetworkResponseModel) -> Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let realm = try Realm()
                
                let user = realm.objects(UserModel.self).first
                var id = ""
                if let v = user?.id {
                    id = "\(v)"
                }
                let endpoint = "escorts/\(id)?include=medias,profile"
                
//                guard let accessToken = NetworkController.getAccessToken() else {
//                    completionHandler(NetworkResponseModel(statusCode: 0))
//                    return
//                }
                let headers = NetworkController.getHeader()

                Alamofire.request(PriveConstants.URL_BASE + endpoint, method: .get, encoding: JSONEncoding.default, headers: headers)
                .validate()
                    .responseObject {
                        (response: DataResponse<CurrentUserResponseModel>) in
                        
                        var networkResponse = NetworkResponseModel(statusCode: (response.response?.statusCode ?? 0))
                        switch response.result {
                            case .success:
                                if let userResponse = response.result.value {
                                    
                                    if let userdata = userResponse.data {
                                        do {
                                            let realm = try Realm()
                                            
                                            try realm.write {
                                                realm.create(UserModel.self, value: userdata, update: true)
                                            }
                                            
                                            networkResponse.success = true
                                            networkResponse.data = userdata
                                        }catch {
                                            print(error)
                                        }
                                
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
            
            } catch {
                print(error)
            }
        }
    }
    
    static func createEscort(dataParameter: [String: Any], completionHandler: @escaping (NetworkResponseModel) -> Void) {
        DispatchQueue.global(qos: .background).async {
            
            let paramenter: Parameters = [
                "data": dataParameter
            ]
            let header = NetworkController.getHeaderWithoutToken()
            let url = "escorts"
            
            Alamofire.request(PriveConstants.URL_BASE + url, method: .post, parameters: paramenter, encoding: JSONEncoding.default, headers: header)
            .validate()
                .responseObject {
                    (response: DataResponse<UserModel>) in
                    
                    var networkResponse = NetworkResponseModel(statusCode: response.response?.statusCode ?? 0)
                    switch response.result {
                    case .success(let data):
                        print(data)
                        if let userResponse = response.result.value {
                            networkResponse.data = userResponse
                            networkResponse.success = true
                            networkResponse.generalMessage = "Model Created Successfully"
                            
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
    
    static func updateEscort(completionHandler: @escaping (NetworkResponseModel) -> Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let realm = try Realm()
                
                guard let user = realm.objects(UserModel.self).first else {
                    print("user empty")
                    return
                }
                
                let medias = realm.objects(MediaModel.self)
                let basics  = realm.objects(ProfileModel.self).filter("kind_name ==[c] '\(PriveConstants.BASIC)'")
                let bodies = realm.objects(ProfileModel.self).filter("kind_name ==[c] '\(PriveConstants.BODY)'")
                let services = realm.objects(ProfileModel.self).filter("kind_name ==[c] '\(PriveConstants.SERVICE)'")
                
                var allMedia = [[String: Any]]()
                for media in medias {
                    var val = [String: Any]()
                    val["type"] = media.type
                    val["index"] = media.index
                    val["real_path"] = media.real_path
                    val["thumbnail_path"] = media.thumbnail_path
                    val["blur_path"] = media.blur_path
                    
                    allMedia.append(val)
                }
                
               
                var allBasic = [String: Any]()
                for basic in basics {
                    allBasic[basic.name] = basic.value
                }
               
                
                var allBody = [String: Any]()
                for body in bodies {
                    allBody[body.name] = body.value
                }
            
                
                var allService = [String: Any]()
                for service in services {
                    allService[service.name] = service.value
                }
            
                
                let url = "escorts/\(user.id)?include=medias,profile"
                let headers =  NetworkController.getHeader()
                
                let value: [String: Any] = [
                    "availability": user.availability,
                    "media": allMedia,
                    "basic": allBasic,
                    "body": allBody,
                    "services": allService
                ]
                
                
                let parameter: Parameters = [
                    "data": value
                ]
                
                
                Alamofire.request(PriveConstants.URL_BASE + url, method: .put, parameters: parameter, encoding: JSONEncoding.default, headers: headers)
                .validate()
                    .responseObject {
                        (response: DataResponse<UserModel>) in
                        
                        var networkResponse = NetworkResponseModel(statusCode: (response.response?.statusCode ?? 0))
                        
                        switch response.result {
                        case .success:
                            if let userResponse = response.result.value {
                                
                                networkResponse.data = userResponse
                                networkResponse.success = true
                                networkResponse.generalMessage = "Profile Updated Successfully"
                                
                                do {
                                    let realm = try Realm()
                                    
                                    try realm.write {
                                        realm.add(userResponse, update: true)
                                    }
                                    
                                }catch {
                                    print(error)
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
                
                
            }catch {
               print(error)
            }
        }
    }
    
}

