//
//  UIViewExtension.swift
//  PrivTest
//
//  Created by Maxwell Chukwuemeka on 01/03/2019.
//  Copyright © 2019 Maxwell. All rights reserved.
//

import Foundation
import UIKit

public extension UIView {
    func pin(to view: UIView) {
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: view.leadingAnchor),
            trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topAnchor.constraint(equalTo: view.topAnchor),
            bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
    }
    
    func fadeViewToHidden() {
        self.alpha = 0.0
        self.isHidden = false
        
        UIView.animate(withDuration: 0.6, delay: 0, options: .curveEaseInOut, animations: {
            self.alpha = 1.0
        }) { (isCompleted) in
            self.isHidden = true
        }
    }
}

@IBDesignable
extension UIView {
    
    @IBInspectable
    var borderColor: UIColor? {
        set {
            layer.borderColor = newValue!.cgColor
        }
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            else {
                return nil
            }
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
}

@IBDesignable
class RoundedView: UIView {
    
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
