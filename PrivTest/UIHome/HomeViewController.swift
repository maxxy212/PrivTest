//
//  HomeViewController.swift
//  PrivTest
//
//  Created by Maxwell Chukwuemeka on 01/03/2019.
//  Copyright © 2019 Maxwell. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func didClickBecomeEscortButton(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "EscortMain", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "BecomeEscortNavigationController")
        presentFromRight(controller, animated: false, completion: nil)
        let viewControllers = self.navigationController?.viewControllers.removeLast()
        navigationController?.setViewControllers([viewControllers!], animated: true)
    }
    
    @IBAction func didClickRequestEscortButton(_ sender: UIButton) {
//        let storyboard = UIStoryboard(name: "CustomerMain", bundle: nil)
//        let controller = storyboard.instantiateViewController(withIdentifier: "RequestEscortViewController")
//        presentFromLeft(controller, animated: false, completion: nil)
    }
    
    @IBAction func didClickLoginButton(_ sender: UIButton) {
        if let controller = storyboard?.instantiateViewController(withIdentifier: "HomeSiginNavigationController") {
            presentFromRight(controller, animated: false, completion: nil)
            self.navigationController?.viewControllers.removeLast()
        }
    }
}
