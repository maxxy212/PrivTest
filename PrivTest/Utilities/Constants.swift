//
//  Constants.swift
//  PrivTest
//
//  Created by Maxwell Chukwuemeka on 01/03/2019.
//  Copyright © 2019 Maxwell. All rights reserved.
//

import Foundation
import UIKit

struct PriveConstants {
    
    static let URL_BASE = "https://priverdo.io/api/v1/"
    static let BASIC = "BASIC"
    static let BODY = "BODY"
    static let SERVICE = "SERVICES"
    
    static let colorPrimary = UIColor(hex: "E8186B")
    static let colorPrimaryLight = UIColor(hex: "ffa43f")
    static let colorPrimaryDark = UIColor(hex: "9d4800")
    static let colorAccent = UIColor(hex: "22a2c7")
    
    static let colorGradientStart = UIColor(hex:"E8186B")
    static let colorGradientEnd = UIColor(hex:"E8186B")
    
    static let colorTransparent = UIColor(hex: "FFFFFF", alpha: 0.0)
    static let colorGreyBB = UIColor(hex: "BBBBBB")
    static let colorWhite = UIColor(hex: "0x034517")
    
    static let lookingForPickerData = ["ADULT FEMALE", "ADULT MALE"]
    
    static let ESCORT_ACCOUNT_STATUS_LOCKED = "LOCKED"
    static let ESCORT_ACCOUNT_STATUS_BASIC = "BASIC"
    static let ESCORT_ACCOUNT_STATUS_GOLD = "GOLD"
    static let ESCORT_ACCOUNT_STATUS_PLATINUM = "PLATINUM"
    
    static let HEADER_QUERY_FILE = "priverdo-query-file"
    static let HEADER_QUERY_CUSTOMER = "priverdo-query-customer"
    
    static let PROFILE_KIND_NAME_BASIC = "BASIC";
    static let PROFILE_KIND_NAME_BODY = "BODY";
    static let PROFILE_KIND_NAME_SERVICES = "SERVICES";
}
