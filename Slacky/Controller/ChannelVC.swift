//
//  ChannelVC.swift
//  Slacky
//
//  Created by vagelis spirou on 5/10/20.
//  Copyright © 2020 vagelis spirou. All rights reserved.
//

import UIKit

class ChannelVC: UIViewController {
    
    @IBOutlet weak var profileImageView: CircleImage!
    @IBOutlet weak var logInBtn: UIButton!
    
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue){
        
        profileImageView.image = UIImage(named: UserDataService.instance.avatarName)
        profileImageView.backgroundColor = UserDataService.instance.returnUIColor(components: UserDataService.instance.avatarColor)
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        profileImageView.image = UIImage(named: "profileDefault")
        self.revealViewController()?.rearViewRevealWidth = self.view.frame.size.width - 60
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChannelVC.userDataDidChange(_:)), name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setupUserInfo()
    }
    
    @objc func userDataDidChange(_ notification: Notification) {
        
        setupUserInfo()
        
    }

    @IBAction func logInBtnPressed(_ sender: UIButton) {
        
        if AuthService.instance.isLoggedIn {
            // Show profile page
            let profile = ProfileVC()
            profile.modalPresentationStyle = .custom
            present(profile, animated: true, completion: nil)
            
        } else {
            
            performSegue(withIdentifier: TO_LOGIN, sender: nil)
            
        }
    }
    
    func setupUserInfo() {
        
        if AuthService.instance.isLoggedIn {
            
            logInBtn.setTitle(UserDataService.instance.name, for: .normal)
            profileImageView.image = UIImage(named: UserDataService.instance.avatarName)
            profileImageView.backgroundColor = UserDataService.instance.returnUIColor(components: UserDataService.instance.avatarColor)
            
        } else {
            logInBtn.setTitle("Login", for: .normal)
            profileImageView.image = UIImage(named: "menuProfileIcon")
            profileImageView.backgroundColor = UIColor.clear
            
        }
        
    }
    
}
