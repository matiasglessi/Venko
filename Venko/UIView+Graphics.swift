//
//  UIView+Graphics.swift
//  Venko
//
//  Created by Matias Glessi on 12/04/2020.
//  Copyright © 2020 Venko. All rights reserved.
//

import UIKit

extension UIView {
    
    func show() {
        self.isHidden = false
    }
    
    func hide() {
        self.isHidden = true
    }
    
    func toogleHide() {
        self.isHidden ? show() : hide()
    }

    func round(to value: CGFloat? = nil){
        if let value = value {
            self.layer.cornerRadius = value
        }
        else {
            self.layer.cornerRadius = self.frame.size.width/2
        }
         self.clipsToBounds = true
    }
    
    func setBorder(width: CGFloat, color: CGColor? = nil) {
        self.layer.borderWidth = width
        self.layer.borderColor = color
    }

}
