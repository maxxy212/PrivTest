//
//  MediaModel.swift
//  PrivTest
//
//  Created by Maxwell Chukwuemeka on 20/03/2019.
//  Copyright © 2019 Maxwell. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper
import SwiftyJSON

class MediaModel: Object, Mappable {
    
    @objc dynamic var index = 0
    @objc dynamic var type = 0
    @objc dynamic var type_name = ""
    @objc dynamic var real_path = ""
    @objc dynamic var thumbnail_path = ""
    @objc dynamic var blur_path = ""
    
    @objc dynamic var createdAt: Date?
    @objc dynamic var createdAtString = ""
    let media = LinkingObjects(fromType: CurrentMediaModel.self, property: "data")
    
    convenience required init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        index <- map["index"]
        type <- map["type"]
        type_name <- map["type_name"]
        real_path <- map["real_path"]
        thumbnail_path <- map["thumbnail_path"]
        blur_path <- map["blur_path"]
        
        createdAtString <- map["created_at"]
        let inputformatter = DateFormatter()
        inputformatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        inputformatter.timeZone = TimeZone.init(identifier: "UTC")
        createdAt = inputformatter.date(from: createdAtString)
    }
    
}
