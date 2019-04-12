//
//  HomeSignInViewController.swift
//  PrivTest
//
//  Created by Maxwell Chukwuemeka on 18/03/2019.
//  Copyright © 2019 Maxwell. All rights reserved.
//

import UIKit
import RealmSwift
import NVActivityIndicatorView
import FlagPhoneNumber

class HomeSignInViewController: UIViewController, FPNTextFieldDelegate{
    
    @IBOutlet weak var phoneNumberTextField: RoundedFPNTextField!
    @IBOutlet weak var passwordTextField: RoundedTextField!
    @IBOutlet weak var goToDashboard: RoundedColoredButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var backButton: UIBarButtonItem!
    
    private var valid: Bool!

    override func viewDidLoad() {
        super.viewDidLoad()
        phoneNumberTextField.delegate = self
        phoneNumberTextField.setFlag(for: .NG)
        
        //NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        //NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidLayoutSubviews() {
        phoneNumberTextField.parentViewController = self
    }
    
    @IBAction func didClickBackButton(_ sender: UIBarButtonItem) {
        dismissToRight()
    }
    
    @IBAction func didClickSignInButton(_ sender: UIButton) {
        showActivityIndicator(true)
        
        if !valid {
            presentOkAlert("Error", "Please enter a valid phone number")
            showActivityIndicator(false)
            return
        }
        
        if let passwordText = passwordTextField?.text, passwordText.isEmpty || passwordText.count < 5 {
            presentOkAlert("Error", "Please enter a valid password, and it must be more than 5 characters")
            showActivityIndicator(false)
            return
        }
        
        
        UserNetworkController.auth(phone: phoneNumberTextField?.getFormattedPhoneNumber(format: .E164) ?? "", password: passwordTextField.text ?? "") {
            responseModel in
            if(responseModel.success) {
                if let currentUser = responseModel.data as? AuthUserModel {
                    if currentUser.escort != nil && currentUser.customer != nil {
                        print("Two of em")
                        self.showActivityIndicator(false)
                       let alertController = UIAlertController(title: "Choose Account", message: "Choose the account you want to login as", preferredStyle: .actionSheet)
                        
                        let actionModel = UIAlertAction(title: "Model", style: .default) {
                            (action:UIAlertAction) in
                            self.goToModel()
                        }
                        
                        let actionCustomer = UIAlertAction(title: "Customer", style: .default) {
                            (action: UIAlertAction) in
                            self.goToCustomer()
                        }
                        
                        alertController.addAction(actionModel)
                        alertController.addAction(actionCustomer)
                        self.present(alertController, animated: true, completion: nil)
                        
                    }else if currentUser.escort != nil {
                        self.getEscortUserData()
                    }else if currentUser.customer != nil {
                        self.goToCustomer()
                    }
                }
            }else {
                self.presentOkAlert(responseModel.errorTitle, responseModel.getErrorMessage())
                self.showActivityIndicator(false)
            }
        }
    }
    
    func getEscortUserData() {
        EscortNetworkController.getMeAsEscort() {
            responseModel in
            if responseModel.success {
                self.showActivityIndicator(false)
                let storyboard = UIStoryboard(name: "EscortMain", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "NavigationDashboardView")
                self.presentFromRight(controller, animated: false, completion: nil)
                //self.navigationController?.popToRootViewController(animated: true)
                //self.navigationController?.viewControllers.removeLast()
            }else {
                self.showActivityIndicator(false)
                self.presentOkAlert(responseModel.errorTitle, responseModel.generalMessage ?? "")
                do {
                    let realm = try Realm()
                    
                    try realm.write {
                        realm.deleteAll()
                    }
                }catch {
                    
                }
            }
        }
    }
    
    func fpnDidSelectCountry(name: String, dialCode: String, code: String) {
        print(name, dialCode, code) // Output "France", "+33", "FR"
    }
    
    func fpnDidValidatePhoneNumber(textField: FPNTextField, isValid: Bool) {
        valid = isValid
    }
    
    func goToModel() {
        do {
            let realm = try Realm()
            try realm.write {
                let customer = realm.objects(CustomerModel.self)
                realm.delete(customer)
                self.showActivityIndicator(true)
                self.getEscortUserData()
            }
        }catch {
            print("\(error)")
        }

    }
    
    func goToCustomer() {
        do {
            let realm = try Realm()
            try realm.write {
                let model = realm.objects(UserModel.self)
                realm.delete(model)
                
                self.showActivityIndicator(false)
                let storyboard = UIStoryboard(name: "CustomerMain", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "RequestEscortViewController")
                self.presentFromRight(controller, animated: false, completion: nil)
                //self.navigationController?.popToRootViewController(animated: true)
                //self.navigationController?.viewControllers.removeLast()
            }
        }catch {
            print(error)
        }
    }
    
//    @objc func keyboardWillShow(notification: NSNotification) {
//        var userInfo = notification.userInfo!
//        var keyboardFrame: CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
//        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
//
//        var contentInset: UIEdgeInsets = self.scrollView.contentInset
//        contentInset.bottom = keyboardFrame.size.height
//        scrollView.contentInset = contentInset
//    }
//
//    @objc func keyboardWillHide(notification: NSNotification){
//        let contentInset: UIEdgeInsets = UIEdgeInsets.zero
//        scrollView.contentInset = contentInset
//    }
    
}

