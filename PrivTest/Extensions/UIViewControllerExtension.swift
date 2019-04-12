//
//  UIViewControllerExtension.swift
//  PrivTest
//
//  Created by Maxwell Chukwuemeka on 07/03/2019.
//  Copyright © 2019 Maxwell. All rights reserved.
//

import Foundation
import UIKit
import NVActivityIndicatorView

extension UIViewController {

    func presentFromRight(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil)  {
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        
        if let window = view.window {
            window.layer.add(transition, forKey: kCATransition)
        }
        present(viewControllerToPresent, animated: false, completion: completion)
    }
    
    func presentFromLeft(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        
        view.window!.layer.add(transition, forKey: kCATransition)
        present(viewControllerToPresent, animated: false, completion: completion)
    }
    
    func dismissToRight(completion: (() -> Void)? = nil){
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        
        view.window!.layer.add(transition, forKey: nil)
        dismiss(animated: false, completion: nil)
    }
    
    func dismissToLeft(completion: (() -> Void)? = nil){
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        
        view.window!.layer.add(transition, forKey: nil)
        dismiss(animated: false, completion: nil)
    }
    
    func presentOkAlert(_ title: String, _ message: String, handler: ((UIAlertAction) -> Void)? = nil) {
        let uiAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        uiAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: handler))
        present(uiAlert, animated: true)
        return
    }
    
    func showActivityIndicator(_ startAnimating: Bool, message: String? = nil) {
        if startAnimating{
            let activityType = ActivityData(message: message, type: NVActivityIndicatorType.lineScale, color: PriveConstants.colorAccent, textColor: PriveConstants.colorPrimary)
            NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityType, nil)
        }else {
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
        }
    }
    
    func topMostViewController() -> UIViewController {
        if let presented = self.presentedViewController {
            return presented.topMostViewController()
        }
        
        if let navigation = self as? UINavigationController {
            return navigation.visibleViewController?.topMostViewController() ?? navigation
        }
        
        if let tab = self as? UITabBarController {
            return tab.selectedViewController?.topMostViewController() ?? tab
        }
        
        return self
    }
}
