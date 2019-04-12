//
//  CurrentUserResponseModel.swift
//  PrivTest
//
//  Created by Maxwell Chukwuemeka on 01/04/2019.
//  Copyright © 2019 Maxwell. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyJSON
import ObjectMapper

class CurrentUserResponseModel: Object, Mappable {
    
    @objc dynamic var data: UserModel?
    
    convenience required init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        data <- map["data"]
    }
    
    
}
