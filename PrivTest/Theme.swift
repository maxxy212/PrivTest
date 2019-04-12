//
//  Theme.swift
//  PrivTest
//
//  Created by Maxwell Chukwuemeka on 09/03/2019.
//  Copyright © 2019 Maxwell. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

enum Theme: Int {
    //1
    case `default`, dark, graphical
    
    //2
    private enum Keys {
        static let selectedTheme = "SelectedTheme"
    }
    
    //3
    static var current: Theme {
        let storedTheme = UserDefaults.standard.integer(forKey: Keys.selectedTheme)
        return Theme(rawValue: storedTheme) ?? .default
    }
    
    var mainColor: UIColor {
        switch self {
        case .default:
            return PriveConstants.colorPrimary
        case .dark:
            return UIColor(red: 255.0/255.0, green: 115.0/255.0, blue: 50.0/255.0, alpha: 1.0)
        case .graphical:
            return UIColor(red: 10.0, green: 10.0/255.0, blue: 10.0/255.0, alpha: 1.0)
        }
    }
    
    var barStyle: UIBarStyle {
        switch self {
        case .default, .graphical:
            return .blackOpaque
        case .dark:
            return .black
        }
    }
    
    func apply() {
        //1
        UserDefaults.standard.set(rawValue, forKey: Keys.selectedTheme)
        UserDefaults.standard.synchronize()
        
        //2
        UIApplication.shared.delegate?.window??.tintColor = mainColor
        UINavigationBar.appearance().barStyle = barStyle
        
        //3
        UISwitch.appearance().onTintColor = mainColor.withAlphaComponent(0.3)
        UISwitch.appearance().thumbTintColor = mainColor
        
        //4
        let controlBackground = UIImage(named: "controlBackground")?
        .withRenderingMode(.alwaysTemplate)
        .resizableImage(withCapInsets: UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3))
        
        let controlSelectedBackground = UIImage(named: "controlSelectedBackground")?
            .withRenderingMode(.alwaysTemplate)
            .resizableImage(withCapInsets: UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3))
        
        UISegmentedControl.appearance().setBackgroundImage(controlBackground, for: .normal, barMetrics: .default)
        
        UISegmentedControl.appearance().setBackgroundImage(controlSelectedBackground, for: .selected, barMetrics: .default)
        
        //5
        UIStepper.appearance().setBackgroundImage(controlBackground, for: .normal)
        UIStepper.appearance().setBackgroundImage(controlBackground, for: .disabled)
        UIStepper.appearance().setBackgroundImage(controlBackground, for: .highlighted)
        UIStepper.appearance().setDecrementImage(UIImage(named: "fewerPaws"), for: .normal)
        UIStepper.appearance().setIncrementImage(UIImage(named: "morePaws"), for: .normal)
        
        //6
        UISlider.appearance().setThumbImage(UIImage(named: "sliderThumb"), for: .normal)
        UISlider.appearance().setMaximumTrackImage(UIImage(named: "maximumTrack")?
            .resizableImage(withCapInsets:UIEdgeInsets(top: 0, left: 0.0, bottom: 0, right: 6.0)), for: .normal)
        
        UISlider.appearance().setMinimumTrackImage(UIImage(named: "minimumTrack")?
            .withRenderingMode(.alwaysTemplate)
            .resizableImage(withCapInsets:UIEdgeInsets(top: 0, left: 6.0, bottom: 0, right: 0)), for: .normal)
        
        IQKeyboardManager.shared.enable = true

    }
}
