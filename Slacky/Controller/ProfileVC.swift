//
//  ProfileVC.swift
//  Slacky
//
//  Created by vagelis spirou on 12/10/20.
//  Copyright © 2020 vagelis spirou. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var userEmailLbl: UILabel!
    @IBOutlet weak var bgView: UIView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        bgView.backgroundColor = .clear
        setupView()
    }
    
    func setupView() {
        
        userNameLbl.text = UserDataService.instance.name
        userEmailLbl.text = UserDataService.instance.email
        profileImageView.image = UIImage(named: UserDataService.instance.avatarName)
        profileImageView.backgroundColor = UserDataService.instance.returnUIColor(components: UserDataService.instance.avatarColor)
        
        let closeTouch = UITapGestureRecognizer(target: self, action: #selector(ProfileVC.closeTap(_:)))
        
        bgView.addGestureRecognizer(closeTouch)
        
    }
    
    @objc func closeTap(_ recognizer: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func logoutPressed(_ sender: UIButton) {
        
        UserDataService.instance.logoutUser()
        NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
        
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func closeButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}
