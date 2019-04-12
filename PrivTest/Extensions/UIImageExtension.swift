//
//  UIImageExtension.swift
//  PrivTest
//
//  Created by Maxwell Chukwuemeka on 01/03/2019.
//  Copyright © 2019 Maxwell. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    func image(scaledTo newSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsGetImageFromCurrentImageContext()
        
        return newImage ?? UIImage()
    }
}

@IBDesignable class RoundableUIImageView: UIImageView {
    private var _round = false
    @IBInspectable var round: Bool {
        set {
            _round = newValue
            makeRound()
        }
        get {
            return self._round
        }
    }
    override internal var frame: CGRect {
        set {
            super.frame = newValue
            makeRound()
        }
        get {
            return super.frame
        }
        
    }
    
    private func makeRound() {
        if self.round == true {
            self.clipsToBounds = true
            self.layer.cornerRadius = (self.frame.width + self.frame.height) / 4
        } else {
            self.layer.cornerRadius = 0
        }
    }
    
    override func layoutSubviews() {
        makeRound()
    }
}
