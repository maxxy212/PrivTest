//
//  ItemsResponseModel.swift
//  PrivTest
//
//  Created by Maxwell Chukwuemeka on 01/04/2019.
//  Copyright © 2019 Maxwell. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift
import ObjectMapper

class ItemsResponseArrayModel: Object, Mappable {
    
    let data = List<ItemResponseModel>()
    
    convenience required init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        var tempData = [ItemResponseModel]()
        tempData <- map["data"]
        
        data.append(objectsIn: tempData)
    }
    
    
}
