//
//  CreateAccountVC.swift
//  Slacky
//
//  Created by vagelis spirou on 6/10/20.
//  Copyright © 2020 vagelis spirou. All rights reserved.
//

import UIKit

class CreateAccountVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    @IBAction func closePressed(_ sender: UIButton) {
        
        performSegue(withIdentifier: UNWIND, sender: nil)
    }
    

}
