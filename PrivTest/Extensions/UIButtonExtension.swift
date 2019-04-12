//
//  UIButtonExtension.swift
//  PrivTest
//
//  Created by Maxwell Chukwuemeka on 01/03/2019.
//  Copyright © 2019 Maxwell. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class ColoredButton: UIButton {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        updateCornerRadius()
    }
    
    @IBInspectable
    var rounded: Bool = false {
        didSet {
            updateCornerRadius()
        }
    }
    
    @IBInspectable
    var cornerRadius: CGFloat = 0.1 {
        didSet {
            updateCornerRadius()
        }
    }
    
    func updateCornerRadius() {
        layer.cornerRadius = rounded ? cornerRadius : 0
        layer.masksToBounds = rounded ? true : false
    }
}

@IBDesignable
class RoundedButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        
        updateCornerRadius()
    }
    
    @IBInspectable
    var rounded: Bool = true {
        didSet {
            updateCornerRadius()
        }
    }
    
    @IBInspectable
    var cornerRadius: CGFloat = 10.0 {
        didSet {
            updateCornerRadius()
        }
    }
    
    func updateCornerRadius() {
        layer.cornerRadius = rounded ? cornerRadius : 0
        layer.masksToBounds = rounded ? true : false
    }
}

@IBDesignable
class RoundedPaddedButton: RoundedButton {
    
    var topInset: CGFloat = 5.0
    var bottomInset: CGFloat = 5.0
    var leftInset: CGFloat = 15.0
    var rightInset: CGFloat = 15.0
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setup()
    }
    
    func setup()  {
        self.clipsToBounds = true
        self.contentEdgeInsets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
    }
}

@IBDesignable
class RoundedColoredButton: RoundedButton {
    
    var topInset: CGFloat = 5.0
    var bottomInset: CGFloat = 8.0
    var leftInset: CGFloat = 15.0
    var rightInset: CGFloat = 15.0
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setup()
    }
    
    func setup() {
        self.clipsToBounds = true
        self.layer.backgroundColor = PriveConstants.colorGradientStart.cgColor
        self.layer.borderWidth = borderWidth
        self.contentEdgeInsets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
    }
}

@IBDesignable
class RoundedOutlinedButton: RoundedButton {
    
    var topInset: CGFloat = 8.0
    var bottomInset: CGFloat = 8.0
    var leftInset: CGFloat = 15.0
    var rightInset: CGFloat = 15.0
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setup()
    }
    
    func setup() {
        super.layoutSubviews()
        self.clipsToBounds = true
        self.layer.backgroundColor = PriveConstants.colorTransparent.cgColor
        self.layer.borderColor = PriveConstants.colorGradientStart.cgColor
        self.layer.borderWidth = borderWidth < 2.0 ? 2.0 : borderWidth
        self.contentEdgeInsets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
    }
}
