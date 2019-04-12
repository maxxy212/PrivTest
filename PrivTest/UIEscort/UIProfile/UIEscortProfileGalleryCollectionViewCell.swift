//
//  UIEscortProfileGalleryCollectionViewCell.swift
//  PrivTest
//
//  Created by Maxwell Chukwuemeka on 11/04/2019.
//  Copyright © 2019 Maxwell. All rights reserved.
//

import UIKit
import UICircularProgressRing

class UIEscortProfileGalleryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var cicularProgressBar: UICircularProgressRing!
    
    var type = 1
    
    var baseViewController: UIViewController?
    var oldImage: UIImage?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cicularProgressBar.minValue = 0
        cicularProgressBar.maxValue = 0
    }
    
//    override func layoutSubviews() {
//        imageView.layer.cornerRadius = 15
//        imageView.layer.borderWidth = 3.0
//        imageView.layer.masksToBounds = false
//        imageView.layer.borderColor = UIColor.white.cgColor
//        imageView.clipsToBounds = true
//
//        super.layoutSubviews()
//    }
}
