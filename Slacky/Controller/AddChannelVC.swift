//
//  AddChannelVC.swift
//  Slacky
//
//  Created by vagelis spirou on 15/10/20.
//  Copyright © 2020 vagelis spirou. All rights reserved.
//

import UIKit

class AddChannelVC: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var bgView: UIView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    func setupView() {
        
        let closeTouch = UITapGestureRecognizer(target: self, action: #selector(AddChannelVC.closeTap(_:)))
        bgView.addGestureRecognizer(closeTouch)
        
        nameTextField.attributedPlaceholder = NSAttributedString(string: "name", attributes: [NSAttributedString.Key.foregroundColor : slackyPurplePlaceholder])
        descriptionTextField.attributedPlaceholder = NSAttributedString(string: "description", attributes: [NSAttributedString.Key.foregroundColor : slackyPurplePlaceholder])
        
    }
    
    @objc func closeTap(_ recognizer: UITapGestureRecognizer) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func createBtnPressed(_ sender: Any) {
    }
    
    @IBAction func closeBtnPressed(_ sender: UIButton) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
}
