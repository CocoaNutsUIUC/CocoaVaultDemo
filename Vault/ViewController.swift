//
//  ViewController.swift
//  Vault
//
//  Created by Steven Shang on 2/27/17.
//  Copyright © 2017 Steven Shang. All rights reserved.
//

import UIKit
import LocalAuthentication

class ViewController: UIViewController, UITextFieldDelegate {

    // MARK: Outlets
    
    @IBOutlet weak var vaultLabel: UILabel!
    @IBOutlet weak var TouchButton: UIButton!
    @IBOutlet weak var LogInButton: UIButton!
    @IBOutlet weak var CreateButton: UIButton!
    @IBOutlet weak var usernameTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    // MARK: Lifecycle
    
    let keychain = KeychainHelper.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        LogInButton.isEnabled = false
        CreateButton.isEnabled = false
        passwordTextfield.isSecureTextEntry = true
        
        
        usernameTextfield.delegate = self
        passwordTextfield.delegate = self
        
        
        NotificationCenter.default.addObserver(forName: .UITextFieldTextDidChange, object: passwordTextfield, queue: .main) { (notification) in
            self.setButton()
        }
        NotificationCenter.default.addObserver(forName: .UITextFieldTextDidChange, object: usernameTextfield, queue: .main) { (notification) in
            self.setButton()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: IBActions
    
    @IBAction func touchButtonTouched(_ sender: Any) {
        hideKeyboard()
        authenticateUser()
    }
    
    @IBAction func logInButtonTouched(_ sender: Any) {
        hideKeyboard()
        login(username: usernameTextfield.text!, password: passwordTextfield.text!)
    }
    
    @IBAction func createButtonTouched(_ sender: Any) {
        hideKeyboard()
        createAccount(username: usernameTextfield.text!, password: passwordTextfield.text!)
    }
    
    // MARK: TouchID
    
    func authenticateUser() {
        
        let context : LAContext = LAContext()
        var error : NSError?
        let localizedReasonString : String = "Use your fingerprint to access your vault."
        
        guard context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            showAlert(message: "Your device does not support TouchID, try log in with password.")
            return
        }
        
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: localizedReasonString) { (sucess, error) in
            
            if (sucess) {
                DispatchQueue.main.async {
                    self.loadData()
                }
            } else {
                if error != nil {
                    switch error!._code {
                    case LAError.Code.userCancel.rawValue:
                        break
                    case LAError.Code.userFallback.rawValue:
                        break
                    default:
                        self.showAlert(message: "Something went wrong...")
                    }
                }
            }
        }
    }
    
    // MARK: Password
    
    
    
    
    func login(username: String, password: String) {
        
        guard let retrieved = keychain.loadPassword(username: username) else {
            showAlert(message: "No username found!")
            return
        }
        if (retrieved as String == password) {
            loadData()
        } else {
            showAlert(message: "Wrong password!")
        }
    }
    
    
    func createAccount(username: String, password: String) {
        
        keychain.savePassword(username: username, password: password)
    }
    
    
    
    
    
    
    // MARK: UI Handling
    
    func showAlert(message: String) {
        
        DispatchQueue.main.async {
            let alertVC = UIAlertController(title: "Uh Oh!", message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alertVC.addAction(okAction)
            self.present(alertVC, animated: true, completion: nil)
        }
    }
    
    func loadData() {
        
        UIView.animate(withDuration: 0.7, animations: {
            self.TouchButton.alpha = 0
            self.CreateButton.alpha = 0
            self.LogInButton.alpha = 0
            self.usernameTextfield.alpha = 0
            self.passwordTextfield.alpha = 0
            self.vaultLabel.alpha = 0
        }) { (complete) in
            self.vaultLabel.text = "You are now inside the CocoaVault! Money! So much money! Cocoanuts! So much Cocoanuts!"
            self.vaultLabel.alpha = 1
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        hideKeyboard()
        return true
    }
    
    func hideKeyboard() {
        usernameTextfield.resignFirstResponder()
        passwordTextfield.resignFirstResponder()
    }
    
    func setButton() {
        if (usernameTextfield.text != "" && passwordTextfield.text != "") {
            LogInButton.isEnabled = true
            CreateButton.isEnabled = true
        } else {
            LogInButton.isEnabled = false
            CreateButton.isEnabled = false
        }
    }

}

