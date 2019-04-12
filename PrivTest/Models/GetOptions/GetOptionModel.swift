//
//  GetOptionModel.swift
//  PrivTest
//
//  Created by Maxwell Chukwuemeka on 01/04/2019.
//  Copyright © 2019 Maxwell. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift
import ObjectMapper

class GetOptionModel: Object, Mappable {
    @objc dynamic var id = 0
    @objc dynamic var name = ""
    @objc dynamic var title = ""
    @objc dynamic var optDescription = ""
    @objc dynamic var required = false
    @objc dynamic var multi_select = false
    @objc dynamic var kind = 0
    @objc dynamic var kind_name = ""
    @objc dynamic var type = ""
    @objc dynamic var active = false
    
    @objc dynamic var createdAtString = ""
    @objc dynamic var created_at: Date?
    
    @objc dynamic var updatedAtString = ""
    @objc dynamic var updated_at: Date?
    
    @objc dynamic var items: ItemsResponseArrayModel?
   
    convenience required init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        title <- map["title"]
        optDescription <- map["description"]
        required <- map["required"]
        multi_select <- map["multi_select"]
        kind <- map["kind"]
        kind_name <- map["kind_name"]
        type <- map["type"]
        active <- map["active"]
        
        createdAtString <- map["created_at"]
        updatedAtString <- map["updated_at"]
        
        items <- map["items"]
        
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        inputFormatter.timeZone = TimeZone.init(identifier: "UTC")
        
        created_at = inputFormatter.date(from: createdAtString)
        updated_at = inputFormatter.date(from: updatedAtString)
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    
}
