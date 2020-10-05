//
//  GradientView.swift
//  Slacky
//
//  Created by vagelis spirou on 5/10/20.
//  Copyright © 2020 vagelis spirou. All rights reserved.
//

import UIKit

@IBDesignable
class GradientView: UIView {

    @IBInspectable var topColor: UIColor = #colorLiteral(red: 0.2901960784, green: 0.3019607843, blue: 0.8470588235, alpha: 1) {
        
        didSet {
            self.setNeedsLayout()
        }
    }
    
    @IBInspectable var bottomColor: UIColor = #colorLiteral(red: 0.1725490196, green: 0.831372549, blue: 0.8470588235, alpha: 1) {
        
        didSet {
            self.setNeedsLayout()
        }
    }
    
    override func layoutSubviews() {
        
        let gradientLayer = CAGradientLayer() // αρχικοποιουμε τη μεταβλητή μας gradientLayer. Αυτή είναι η μεταβλητή στην οποία θα ενεργοποιήσετε όλες τις επιλογές διαβάθμισης και θα την προσθέσετε τελικά στην προβολή σας.
        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor] // παίρνει μια σειρά χρωμάτων που θα συνθέσουν την χρωματικη διαβάθμιση.
        gradientLayer.startPoint = CGPoint(x: 0, y: 0) // To σημείο που ξεκινάει η χρωματική διαβάθμιση.
        gradientLayer.endPoint = CGPoint(x: 1, y: 1) // Το σημείο που σταματάει η χρωματική διαβάθμιση.
        gradientLayer.frame = self.bounds // Ορίζουμε το μέγεθος που θα υλοποιηθεί η χρωματική διαβάθμιση ισο με το μέγεθος της view στην οποία ανήκει.
        self.layer.insertSublayer(gradientLayer, at: 0) // Προσθέτουμε το layer που έχουμε δημιουργήσει.
        
    }
    

}
