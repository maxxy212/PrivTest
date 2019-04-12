//
//  CustomerModel.swift
//  PrivTest
//
//  Created by Maxwell Chukwuemeka on 20/03/2019.
//  Copyright © 2019 Maxwell. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper
import SwiftyJSON

class CustomerModel: Object, Mappable {
    @objc dynamic var id = ""
    @objc dynamic var nickname = ""
    @objc dynamic var email = ""
    @objc dynamic var country = ""
    @objc dynamic var state = ""
    @objc dynamic var phone = ""
   
    convenience required init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        nickname <- map["nickname"]
        email <- map["email"]
        country <- map["country"]
        state <- map["state"]
        phone <- map["phone"]
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    
}
