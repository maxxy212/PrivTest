//
//  UserModel.swift
//  PrivTest
//
//  Created by Maxwell Chukwuemeka on 20/03/2019.
//  Copyright © 2019 Maxwell. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper
import SwiftyJSON

class UserModel: Object, Mappable {
    
    @objc dynamic var id = 0
    @objc dynamic var name = ""
    @objc dynamic var email = ""
    @objc dynamic var phone = ""
    @objc dynamic var looking = ""
    @objc dynamic var country = ""
    @objc dynamic var state = ""
    @objc dynamic var is_active = false
    @objc dynamic var availability = false
    @objc dynamic var membership = ""
    @objc dynamic var role = ""
    
    @objc dynamic var created_at: Date?
    @objc dynamic var createdAtString = ""
    
    @objc dynamic var updated_at: Date?
    @objc dynamic var updatedAtString = ""
    
    @objc dynamic var medias: CurrentMediaModel?
    @objc dynamic var profile: CurrentUserProfileModel?
   
    convenience required init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        email <- map["email"]
        phone <- map["phone"]
        looking <- map["looking"]
        country <- map["country"]
        state <- map["state"]
        is_active <- map["is_active"]
        availability <- map["availability"]
        membership <- map["membership"]
        role <- map["role"]
        
        createdAtString <- map["created_at"]
        let inputformatter = DateFormatter()
        inputformatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        inputformatter.timeZone = TimeZone.init(identifier: "UTC")
        created_at = inputformatter.date(from: createdAtString)
        
        updatedAtString <- map["updated_at"]
        updated_at = inputformatter.date(from: updatedAtString)
        
        medias <- map["medias"]
        profile <- map["profile"]
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    
}
