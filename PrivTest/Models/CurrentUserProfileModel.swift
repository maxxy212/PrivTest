//
//  CurrentUserProfileModel.swift
//  PrivTest
//
//  Created by Maxwell Chukwuemeka on 20/03/2019.
//  Copyright © 2019 Maxwell. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift
import ObjectMapper

class CurrentUserProfileModel: Object, Mappable {
    
    let data = List<ProfileModel>()
    
    convenience required init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        var tempData = [ProfileModel]()
        tempData <- map["data"]
        data.append(objectsIn: tempData)
    }
}
