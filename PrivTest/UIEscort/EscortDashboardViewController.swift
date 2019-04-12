//
//  EscortDashboardViewController.swift
//  PrivTest
//
//  Created by Maxwell Chukwuemeka on 25/03/2019.
//  Copyright © 2019 Maxwell. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift
import Kingfisher

class EscortDashboardViewController: UIViewController {
    
    var currentUser: UserModel?
    
    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var accountStatusButton: UIButton!
    @IBOutlet weak var avaliabilitySwitch: UISwitch!
    @IBOutlet weak var availabilityText: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            let realm = try Realm()
            guard let user = realm.objects(UserModel.self).first else {
                dismissToRight()
                return
            }
            currentUser = user
        }catch {}
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkUserData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //For background services
        ContentNetworkController.getOptions() {
            response in
        }
        
    }
    
    @IBAction func didClickLogout(_ sender: RoundedColoredButton) {
        
        do {
            let realm = try Realm()
            try realm.write {
                realm.deleteAll()
            }
            let storyboard = UIStoryboard(name: "Home", bundle: nil)
            if let controller = storyboard.instantiateInitialViewController() {
                presentFromLeft(controller, animated: false, completion: nil)
            }
        }catch {}
    }
    
    
    func checkUserData() {
        let placeholder = UIImage(named: "profile-upload")
        
        profilePictureImageView.kf.indicatorType = .activity
        if let url = currentUser?.medias?.data.first?.real_path {
            profilePictureImageView.kf.setImage(with: URL(string: url), placeholder: placeholder, options: [
                .processor(RoundCornerImageProcessor.init(cornerRadius: 100)),
                .cacheOriginalImage,
                .transition(.fade(1)),
                .scaleFactor(UIScreen.main.scale)
                ])
        }
        
        usernameLabel.text = currentUser?.name.firstUpperCased
        accountStatusButton.setTitle(currentUser?.membership, for: .normal)
        avaliabilitySwitch.setOn(currentUser?.availability ?? false, animated: true)
        
        avaliabilitySwitch.addTarget(self, action: #selector(self.switchChanged(_:)), for: UIControl.Event.valueChanged)
    }
    
    @objc func switchChanged(_ mySwitch: UISwitch) {
        do {
            let realm = try Realm()
            
            if ((currentUser?.membership.caseInsensitiveCompare("locked")) != nil)  {
                presentOkAlert("Cannot perform task!", "Your account must be unlocked before you can enable or disable your availability")
                
                mySwitch.setOn(false, animated: true)
                
            }else {
                try realm.write {
                    currentUser?.availability = mySwitch.isOn
                }
                
                if mySwitch.isOn {
                    availabilityText.text = "Available"
                } else {
                    availabilityText.text = "Unavailable"
                }
                
                updateEscort()
            }

        }catch {
            print(error)
        }
    }
    
    func updateEscort() {
        showActivityIndicator(true)
        EscortNetworkController.updateEscort() {
            response in
            if response.success {
                self.showActivityIndicator(false)
                self.presentOkAlert(response.successTitle, response.generalMessage ?? "")
            }else {
                self.showActivityIndicator(false)
                self.presentOkAlert(response.errorTitle, response.getErrorMessage())
                do {
                    let realm = try Realm()
                    
                    try realm.write {
                        self.currentUser?.availability = !self.currentUser!.availability
                    }
                    self.avaliabilitySwitch.setOn(self.currentUser?.availability ?? false, animated: true)
                }catch {
                    print(error)
                }
            }
        }
    }

}

