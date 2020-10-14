//
//  LoginVC.swift
//  Slacky
//
//  Created by vagelis spirou on 5/10/20.
//  Copyright © 2020 vagelis spirou. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    let activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)

    override func viewDidLoad() {
        super.viewDidLoad()

        setupActivityIndicator()
        changePlaceholderTextColor()
        
    }
    
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
        guard let email = usernameTextField.text, usernameTextField.text != "" else { return }
        guard let password = passwordTextField.text, passwordTextField.text != "" else { return }
        
        AuthService.instance.loginUser(email: email, password: password) { (success) in
            
            if success {
                
                AuthService.instance.findUserByEmail { (success) in
                   
                    if success {
                        
                        NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
                        self.activityIndicator.isHidden = true
                        self.activityIndicator.stopAnimating()
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    @IBAction func closePressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createAccountBtnPressed(_ sender: UIButton) {
        
        performSegue(withIdentifier: TO_CREATE_ACCOUNT, sender: nil)
    }
    
    
    func changePlaceholderTextColor() {
        
        usernameTextField.attributedPlaceholder = NSAttributedString(string: "username", attributes: [NSAttributedString.Key.foregroundColor : slackyPurplePlaceholder])
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "password", attributes: [NSAttributedString.Key.foregroundColor : slackyPurplePlaceholder])
        
    }
    
    func setupActivityIndicator() {
        activityIndicator.isHidden = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.color = #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)
        self.view.addSubview(activityIndicator)
        
        let horizontalConstraint = activityIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        let verticalConstraint = activityIndicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -100)
        NSLayoutConstraint.activate([horizontalConstraint, verticalConstraint])
    }
    
}
