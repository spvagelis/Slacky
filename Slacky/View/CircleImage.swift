//
//  CircleImage.swift
//  Slacky
//
//  Created by vagelis spirou on 9/10/20.
//  Copyright © 2020 vagelis spirou. All rights reserved.
//

import UIKit

@IBDesignable
class CircleImage: UIImageView {

    override func awakeFromNib() {
        self.setupView()
    }
    
    func setupView() {
        
        self.layer.cornerRadius = self.bounds.width / 2
        self.clipsToBounds = true
        
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.setupView()
    }

}
