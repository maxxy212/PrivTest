//
//  BecomeEscortViewController.swift
//  PrivTest
//
//  Created by Maxwell Chukwuemeka on 07/03/2019.
//  Copyright © 2019 Maxwell. All rights reserved.
//

import UIKit
import FlagPhoneNumber
import SwiftyJSON

class BecomeEscortViewController: UIViewController, FPNTextFieldDelegate {
    @IBOutlet weak var nickNameText: RoundedTextField!
    @IBOutlet weak var phoneText: PriverdoRoundedFPNTextField!
    @IBOutlet weak var stateTextField: RoundedTextField!
    @IBOutlet weak var lookingForTextField: RoundedTextField!
    @IBOutlet weak var emailTextField: RoundedTextField!
    @IBOutlet weak var passwordTextField: RoundedTextField!
    @IBOutlet weak var confirmPasswordField: RoundedTextField!
    
    var lookingForPickerView: UIPickerView?
    var statePickerView: UIPickerView?
    
    var currentState = [String]()
    var countryCode = ""
    
    private var valid: Bool!
    
    @IBAction func didClickDone(_ sender: UIButton) {
        submitForm()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        phoneText.delegate = self
        phoneText.setCountries(including: [.NG, .AE])
        phoneText.setFlag(for: .NG)
        
        lookingForPickerView = UIPickerView()
        lookingForPickerView?.delegate = self
        lookingForTextField?.delegate = self
        lookingForTextField.inputView = lookingForPickerView
        // ToolBar
        let lookingForToolBar = UIToolbar()
        lookingForToolBar.barStyle = .default
        lookingForToolBar.isTranslucent = true
        lookingForToolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        lookingForToolBar.sizeToFit()
        
        // Adding Button ToolBar
        let lookingForDoneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(didClickDoneWithLookingFor))
        lookingForDoneButton.tintColor = PriveConstants.colorPrimary
        let lookingForSpaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        lookingForToolBar.setItems([lookingForSpaceButton, lookingForDoneButton], animated: false)
        lookingForToolBar.isUserInteractionEnabled = true
        lookingForTextField.inputAccessoryView = lookingForToolBar

        
        statePickerView = UIPickerView()
        statePickerView?.delegate = self
        stateTextField?.delegate = self
        stateTextField.inputView = statePickerView
        // ToolBar
        let stateToolBar = UIToolbar()
        stateToolBar.barStyle = .default
        stateToolBar.isTranslucent = true
        stateToolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        stateToolBar.sizeToFit()
        
        // Adding Button ToolBar
        let stateDoneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(didClickDoneWithStates))
        stateDoneButton.tintColor = PriveConstants.colorPrimary
        let stateSpaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        stateToolBar.setItems([stateSpaceButton, stateDoneButton], animated: false)
        stateToolBar.isUserInteractionEnabled = true
        stateTextField.inputAccessoryView = stateToolBar
    }
    
    override func viewDidLayoutSubviews() {
        phoneText.parentViewController = self
    }
    
    
    @IBAction func backOnRegistration(_ sender: UIBarButtonItem) {
        dismissToRight()
    }
    
    func preSelectState() {
        if stateTextField.text!.isEmpty {
            self.statePickerView?.selectRow(0, inComponent: 0, animated: true)
            self.pickerView((self.statePickerView)!, didSelectRow: 0, inComponent: 0)
        }
    }
    
    func preSelectLooking() {
        if lookingForTextField.text!.isEmpty {
            self.lookingForPickerView?.selectRow(0, inComponent: 0, animated: true)
            self.pickerView((self.lookingForPickerView)!, didSelectRow: 0, inComponent: 0)
        }
    }
    
    func fpnDidSelectCountry(name: String, dialCode: String, code: String) {
        countryCode = code
        currentState.removeAll()
        stateTextField.text = ""
        let badchar = CharacterSet(charactersIn: "\"[]()")
        let country = name.components(separatedBy: badchar).joined().lowercased().replacingOccurrences(of: " ", with: "")
    
        if let jsonPath: String = Bundle.main.path(forResource: country, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: jsonPath), options: .alwaysMapped)
                let jsonObj = try JSON(data: data)
                if jsonObj != JSON.null {
                    for (_,subJson):(String, JSON) in jsonObj {
                        // Do something you want
                        currentState.append(subJson["name"].string ?? "")
                    }
                }
            }catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func fpnDidValidatePhoneNumber(textField: FPNTextField, isValid: Bool) {
        valid = isValid
    }
    
    @objc func didClickDoneWithLookingFor() {
        lookingForTextField.resignFirstResponder()
        preSelectLooking()
    }
    
    @objc func didClickDoneWithStates() {
        stateTextField.resignFirstResponder()
        preSelectState()
    }
    
    func goToLogin(){
        nickNameText.text = ""
        phoneText.text = ""
        stateTextField.text = ""
        emailTextField.text = ""
        lookingForTextField.text = ""
        stateTextField.text = ""
        passwordTextField.text = ""
        confirmPasswordField.text = ""
        
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "HomeSiginNavigationController")
        presentFromRight(controller, animated: false, completion: nil)
//        self.navigationController?.viewControllers.removeLast()
    }
    
    func submitForm() {
        showActivityIndicator(true)
        
        guard let name = nickNameText?.text, name.count > 3 else {
            presentOkAlert("InputError", "Please enter a valid name and it must be more than 4 characters")
            showActivityIndicator(false)
            return
        }
        
        if !valid {
            presentOkAlert("InputError", "Your phone number does not appear to be valid")
            showActivityIndicator(false)
            return
        }
        
        guard let emailText = emailTextField.text, emailText.isEmail else {
            presentOkAlert("InputError", "Please enter a valid email address")
            showActivityIndicator(false)
            return
        }
        
        guard let lookingFor = lookingForTextField.text, !lookingFor.isEmpty else {
            presentOkAlert("InputError", "Please select \"What are you looking for?\"")
            showActivityIndicator(false)
            return
        }
        
        guard let state = stateTextField.text, !state.isEmpty else {
            presentOkAlert("InputError", "Please select your state of residence")
            showActivityIndicator(false)
            return
        }
        
        guard let password = passwordTextField.text, password.count > 5 else {
            presentOkAlert("InputError", "Please enter your password and it must be more than 5 characters")
            showActivityIndicator(false)
            return
        }
        
        guard let confPassword = confirmPasswordField.text else {
            presentOkAlert("InputError", "Please fill your confirm password field")
            showActivityIndicator(false)
            return
        }
        
        if password != confPassword {
            presentOkAlert("InputError", "Your password and confirm password do not match")
            showActivityIndicator(false)
            return
        }
        
        let parameters = ["name": name,
                          "phone": phoneText?.getFormattedPhoneNumber(format: .E164),
                          "email": emailText,
                          "looking": lookingFor,
                          "country": countryCode,
                          "state": state,
                          "password": password,
                          "password_confirmation": confPassword]
        
        EscortNetworkController.createEscort(dataParameter: parameters as [String : Any]) {
            response in
            print(response)
            if response.success {
                self.showActivityIndicator(false)
                let uiAlert = UIAlertController(title: response.successTitle, message: response.generalMessage, preferredStyle: .alert)
                uiAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                    _ in self.goToLogin()
                }))
                self.present(uiAlert, animated: true)
            }else {
                self.showActivityIndicator(false)
                self.presentOkAlert(response.errorTitle, response.generalMessage ?? "")
            }
        }
        
    }

}

extension BecomeEscortViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == statePickerView {
            return currentState.count
        }
        else if  pickerView == lookingForPickerView {
            return PriveConstants.lookingForPickerData.count
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == statePickerView {
            return currentState[row]
        }
        else if pickerView == lookingForPickerView {
            return PriveConstants.lookingForPickerData[row]
        }
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView == statePickerView {
            stateTextField.text = currentState[row]
        }
        else if pickerView == lookingForPickerView {
            lookingForTextField.text = PriveConstants.lookingForPickerData[row]
        }
    }
}

extension BecomeEscortViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == lookingForTextField || textField == stateTextField {
            return false
        }
        return true
    }
}
