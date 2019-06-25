//
//  UIView.swift
//  PingPongResult
//
//  Created by Admin on 24.06.2019.
//  Copyright © 2019 itWorksInUA. All rights reserved.
//

import UIKit

@IBDesignable
extension UIView {
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set { layer.cornerRadius = newValue }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get { return layer.borderWidth }
        set { layer.borderWidth = newValue }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get { return layer.borderColor == nil ? nil : UIColor(cgColor: layer.borderColor!) }
        set { layer.borderColor = newValue?.cgColor }
    }
    
    func endEditingTap() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(onTap))
    }
    
    @objc fileprivate func onTap() {
        endEditing(true)
    }
}
