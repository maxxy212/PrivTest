//
//  NetworkController.swift
//  PrivTest
//
//  Created by Maxwell Chukwuemeka on 21/03/2019.
//  Copyright © 2019 Maxwell. All rights reserved.
//

import Foundation
import RealmSwift
import Alamofire

struct NetworkController {
    
    static func getAccessToken() -> String? {
        var currentUserModel = AuthUserModel()
        do {
            let realm = try Realm()
            currentUserModel = realm.objects(AuthUserModel.self).first ?? AuthUserModel()
        }catch {
            print(error)
        }
        
        return currentUserModel.access_token
        
    }
    
    static func getHeader() -> HTTPHeaders {
        let headers : HTTPHeaders = [
            "Authorization" : "Bearer " + (getAccessToken() ?? ""),
            "Accept": "application/json"
        ]
        
        return headers
    }
    
    static func getHeaderWithoutToken() -> HTTPHeaders {
        let headers : HTTPHeaders = [
            "Accept": "application/json"
        ]
        
        return headers
    }
    
    static func getJSONString(data: Any) -> NSString {
        let dataSet = try! JSONSerialization.data(withJSONObject: data, options: JSONSerialization.WritingOptions.prettyPrinted)
        let jsonString = NSString(data: dataSet, encoding: String.Encoding.utf8.rawValue)!
        
        return jsonString
    }
}
