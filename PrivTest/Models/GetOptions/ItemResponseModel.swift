//
//  ItemResponseModel.swift
//  PrivTest
//
//  Created by Maxwell Chukwuemeka on 01/04/2019.
//  Copyright © 2019 Maxwell. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift
import ObjectMapper

class ItemResponseModel: Object, Mappable {
    
    @objc dynamic var id = 0
    @objc dynamic var value = ""
    @objc dynamic var active = false
    
    convenience required init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        value <- map["value"]
        active <- map["active"]
    }
    
}
