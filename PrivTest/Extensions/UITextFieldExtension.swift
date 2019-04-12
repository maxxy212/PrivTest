//
//  UITextFieldExtension.swift
//  PrivTest
//
//  Created by Maxwell Chukwuemeka on 01/03/2019.
//  Copyright © 2019 Maxwell. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class RoundedTextField: UITextField {
    override func layoutSubviews() {
        super.layoutSubviews()
        
        updateCornerRadius()
    }
    
    @IBInspectable
    var rounded:  Bool = true {
        didSet {
            updateCornerRadius()
        }
    }
    
    @IBInspectable
    var cornerRadius: CGFloat = 15.0 {
        didSet {
            updateCornerRadius()
        }
    }
    
    func updateCornerRadius() {
        layer.cornerRadius = rounded ? cornerRadius: 0
        layer.masksToBounds = rounded ? true : false
    }
}

@IBDesignable
class PriverdoRoundedTextField: RoundedTextField {
    override func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }
    
    func setup() {
        self.clipsToBounds = true
        self.layer.backgroundColor = PriveConstants.colorTransparent.cgColor
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = PriveConstants.colorGreyBB.cgColor
    }
}
