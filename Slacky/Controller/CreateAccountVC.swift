//
//  CreateAccountVC.swift
//  Slacky
//
//  Created by vagelis spirou on 6/10/20.
//  Copyright © 2020 vagelis spirou. All rights reserved.
//

import UIKit

class CreateAccountVC: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var userImageView: UIImageView!
    
    // Variables
    
    var avatarName = "profileDefault"
    var avatarColor = "[0.5, 0.5, 0.5, 1]"
    var bgColor: UIColor?
    let activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tap)
        
        setupActivityIndicator()
        
        changePlaceholderTextColor()
    }
    
    @objc func handleTap() {
        
        view.endEditing(true)
        
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
    
    func changePlaceholderTextColor() {
        emailTextField.attributedPlaceholder = NSAttributedString(string: "email", attributes: [NSAttributedString.Key.foregroundColor : slackyPurplePlaceholder])
        userNameTextField.attributedPlaceholder = NSAttributedString(string: "username", attributes: [NSAttributedString.Key.foregroundColor : slackyPurplePlaceholder])
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "password", attributes: [NSAttributedString.Key.foregroundColor : slackyPurplePlaceholder])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if UserDataService.instance.avatarName != "" {
            userImageView.image = UIImage(named: UserDataService.instance.avatarName)
            avatarName = UserDataService.instance.avatarName
            if avatarName.contains("light") {
                userImageView.backgroundColor = UIColor.lightGray
            }
        }
        
    }
    
    @IBAction func closePressed(_ sender: UIButton) {
        
       performSegue(withIdentifier: UNWIND, sender: nil)
        
    }
    
    @IBAction func createAccountPressed(_ sender: UIButton) {
        
        
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
        guard let name = userNameTextField.text, userNameTextField.text != "" else { return }
        guard let email = emailTextField.text, emailTextField.text != "" else { return }
        guard let password = passwordTextField.text, passwordTextField.text != "" else { return }
        
        AuthService.instance.registerUser(email: email, password: password) { (success) in
            
            if success {
                AuthService.instance.loginUser(email: email, password: password) { (success) in
                    if success {
                        AuthService.instance.createUser(name: name, email: email, avatarName: self.avatarName, avatarColor: self.avatarColor) { (success) in
                            
                            if success {
                                print(UserDataService.instance.name, UserDataService.instance.avatarName, UserDataService.instance.avatarColor)
                                self.performSegue(withIdentifier: UNWIND, sender: nil)
                                self.activityIndicator.stopAnimating()
                                self.activityIndicator.hidesWhenStopped = true
                                NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
                            }
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func pickAvatarPressed(_ sender: UIButton) {
        performSegue(withIdentifier: TO_AVATAR_PICKER, sender: nil)
    }
    
    @IBAction func generateBackgroundColorPressed(_ sender: UIButton) {
        
        let r = CGFloat(arc4random_uniform(255)) / 255
        let g = CGFloat(arc4random_uniform(255)) / 255
        let b = CGFloat(arc4random_uniform(255)) / 255
        
        bgColor = UIColor(red: r, green: g, blue: b, alpha: 1)
        avatarColor = "[\(r), \(g), \(b), 1]"
        UIView.animate(withDuration: 0.2) {
            self.userImageView.backgroundColor = self.bgColor
        }
    }
}
