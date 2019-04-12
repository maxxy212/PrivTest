//
//  ProfileModel.swift
//  PrivTest
//
//  Created by Maxwell Chukwuemeka on 20/03/2019.
//  Copyright © 2019 Maxwell. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper
import SwiftyJSON

class ProfileModel: Object, Mappable {
    @objc dynamic var kind = 0
    @objc dynamic var kind_name = ""
    @objc dynamic var name = ""
    @objc dynamic var value = ""
    
    convenience required init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        kind <- map["kind"]
        kind_name <- map["kind_name"]
        name <- map["name"]
        value <- map["value"]
    }
    
    override static func primaryKey() -> String? {
        return "name"
    }
    
    
}
