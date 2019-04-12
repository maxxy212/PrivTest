//
//  AuthUserResponseModel.swift
//  PrivTest
//
//  Created by Maxwell Chukwuemeka on 19/03/2019.
//  Copyright © 2019 Maxwell. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyJSON
import ObjectMapper

class AuthUserResponseModel: Object, Mappable {
    
    @objc dynamic var error = ""
    @objc dynamic var message = ""
    @objc dynamic var code = 0
    @objc dynamic var data: AuthUserModel?
    
    convenience required init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        error <- map["error"]
        message <- map["message"]
        code <- map["code"]
        data <- map["data"]
    }
    
    
}
