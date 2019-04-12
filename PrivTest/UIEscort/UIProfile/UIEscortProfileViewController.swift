//
//  UIEscortProfileViewController.swift
//  PrivTest
//
//  Created by Maxwell Chukwuemeka on 09/04/2019.
//  Copyright © 2019 Maxwell. All rights reserved.
//

import UIKit
import RealmSwift
import Kingfisher
import Fusuma
import XLPagerTabStrip

class UIEscortProfileViewController: ButtonBarPagerTabStripViewController, FusumaDelegate, UserProfileDelegate {
    
    var currentUser: UserModel?
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var accountStatus: RoundedColoredButton!
    @IBOutlet weak var availabilityStatus: UILabel!
    @IBOutlet weak var availabilitySwitch: UISwitch!
    
    //var oldImage = UIImage(named: "profile-upload")
    
    override func viewDidLoad() {
        // change selected bar color
        settings.style.buttonBarBackgroundColor = .black
        settings.style.buttonBarItemBackgroundColor = .black
        settings.style.selectedBarBackgroundColor = PriveConstants.colorPrimary
        settings.style.buttonBarItemFont = .boldSystemFont(ofSize: 14)
        settings.style.selectedBarHeight = 2.0
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = .black
        settings.style.buttonBarItemsShouldFillAvailiableWidth = true
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        
        changeCurrentIndexProgressive = { /*[weak self]*/ (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = .white
            newCell?.label.textColor = PriveConstants.colorPrimary
        }
        
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkUserData()
        //get rod of containerView offset
        edgesForExtendedLayout = []
        //move tab
        buttonBarView.frame.origin.y = buttonBarView.frame.origin.y + 10
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadImage()
    }
    
    override func viewDidLayoutSubviews() {
        profileImage?.layer.cornerRadius = (profileImage.frame.size.width) / 2
        profileImage?.layer.borderWidth = 3.0
        profileImage?.layer.masksToBounds = false
        profileImage?.layer.borderColor = UIColor.white.cgColor
        profileImage?.clipsToBounds = true
        
        super.viewDidLayoutSubviews()
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let child1 = UIStoryboard(name: "EscortMain", bundle: nil).instantiateViewController(withIdentifier: "EscortProfileDataTableViewController") as! UIEscortProfileDataTableViewController
        child1.tabTitle = "Basic Info"
        child1.dataKind = PriveConstants.PROFILE_KIND_NAME_BASIC

        let child2 = UIStoryboard(name: "EscortMain", bundle: nil).instantiateViewController(withIdentifier: "EscortProfileDataTableViewController") as! UIEscortProfileDataTableViewController
        child2.tabTitle = "Body Data"
        child2.dataKind = PriveConstants.PROFILE_KIND_NAME_BODY

        let child3 = UIStoryboard(name: "EscortMain", bundle: nil).instantiateViewController(withIdentifier: "EscortProfileDataTableViewController") as! UIEscortProfileDataTableViewController
        child3.tabTitle = "Services"
        child3.dataKind = PriveConstants.PROFILE_KIND_NAME_SERVICES


        return [child1, child2, child3]
    }
    
    func checkUserData() {
        do {
            let realm = try Realm()
            guard let user = realm.objects(UserModel.self).first else {
                dismissToRight()
                return
            }
            currentUser = user
        }catch {
            print(error)
        }
        
        if let dataSourceChildren = datasource?.viewControllers(for: self) {
            print("---$$ There are \(dataSourceChildren.count) dataSourceChildren in ProfileViewController")
            for child in dataSourceChildren {
                if let child = child as? UserProfileChildViewControllerDelegate {
                    print("---$$ Sent a reload to the child \(child)")
                    child.reloadData()
                }
            }
        }
        else {
            print("---$$ There are NIL dataSourceChildren in ProfileViewController")
        }
        
        accountStatus.setTitle(currentUser?.membership, for: .normal)
        availabilitySwitch.setOn(currentUser?.availability ?? false, animated: true)
        
        availabilitySwitch.addTarget(self, action: #selector(self.switchChanged(_:)), for: UIControl.Event.valueChanged)
        
        changeAvailabilityStatus()
    }
    
    func loadImage() {
        let placeholder = UIImage(named: "profile-upload")
        
        profileImage.kf.indicatorType = .activity
        if let url = currentUser?.medias?.data.first?.real_path {
            print(url)
            profileImage.kf.setImage(with: URL(string: url), placeholder: placeholder, options: [
                .processor(RoundCornerImageProcessor
                .init(cornerRadius: 100)),
                .cacheOriginalImage,
                .transition(.fade(1)),
                .scaleFactor(UIScreen.main.scale)
                ])
        }
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
                changeAvailabilityStatus()
                updateEscort()
            }
            
        }catch {
            print(error)
        }
    }
    
    func changeAvailabilityStatus() {
        if availabilitySwitch.isOn {
            availabilityStatus.text = "Available"
        } else {
            availabilityStatus.text = "Unavailable"
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
                    self.availabilitySwitch.setOn(self.currentUser?.availability ?? false, animated: true)
                }catch {
                    print(error)
                }
            }
        }
    }
    
    func fusumaMultipleImageSelected(_ images: [UIImage], source: FusumaMode) {
    
    }
    
    func fusumaImageSelected(_ image: UIImage, source: FusumaMode) {
       
    }
    
    func fusumaVideoCompleted(withFileURL fileURL: URL) {
        
    }
    
    func fusumaCameraRollUnauthorized() {
        
    }
    

}

protocol UserProfileDelegate {
    func checkUserData()
}

protocol UserProfileChildViewControllerDelegate {
    func reloadData()
}
