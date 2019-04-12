//
//  StringExtension.swift
//  PrivTest
//
//  Created by Maxwell Chukwuemeka on 01/04/2019.
//  Copyright © 2019 Maxwell. All rights reserved.
//

import Foundation

extension StringProtocol {
    var firstUpperCased: String {
        return prefix(1).uppercased() + dropFirst()
    }
    var firstCapitalized: String {
        return prefix(1).capitalized + dropFirst()
    }
}

extension String {
    public var isEmail: Bool {
        let dataDetector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        
        let firstMatch = dataDetector?.firstMatch(in: self, options: NSRegularExpression.MatchingOptions.reportCompletion, range: NSRange(location: 0, length: length))
        
        return (firstMatch?.range.location != NSNotFound && firstMatch?.url?.scheme == "mailto")
    }
    
    public var length: Int {
        return self.utf16.count
    }
}
