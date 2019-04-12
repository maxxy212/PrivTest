//
//  AuthUserModel.swift
//  PrivTest
//
//  Created by Maxwell Chukwuemeka on 20/03/2019.
//  Copyright © 2019 Maxwell. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper
import SwiftyJSON

class AuthUserModel: Object, Mappable {
    @objc dynamic var token_type = ""
    @objc dynamic var expires_in = 0
    @objc dynamic var access_token = ""
    @objc dynamic var refresh_token = ""
    @objc dynamic var escort: UserModel?
    @objc dynamic var customer: CustomerModel?
    
    convenience required init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        token_type <- map["token_type"]
        expires_in <- map["expires_in"]
        access_token <- map["access_token"]
        refresh_token <- map["refresh_token"]
        
        escort <- map["escort"]
        customer <- map["customer"]
    }
    
}
