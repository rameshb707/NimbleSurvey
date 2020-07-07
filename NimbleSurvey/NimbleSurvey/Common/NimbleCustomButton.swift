//
//  NimbleCustomView.swift
//  NimbleSurvey
//
//  Created by Ramesh B on 05/07/20.
//  Copyright © 2020 Ramesh B. All rights reserved.
//

import UIKit

@IBDesignable
class NimbleCustomButton: UIButton {
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }

    @IBInspectable var normalBorderColor: UIColor? {
        didSet {
            layer.borderColor = normalBorderColor?.cgColor
        }
    }
    
    @IBInspectable var roundedCorner: CGFloat = 0 {
        didSet {
            layer.cornerRadius = roundedCorner
        }
    }

    @IBInspectable var shadowColor: UIColor? {
        didSet {
            layer.shadowColor = shadowColor?.cgColor
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat = 0 {
        didSet {
            layer.shadowRadius = shadowRadius
        }
    }
    
    @IBInspectable var shadowOpacity: Float = 0 {
        didSet {
            layer.shadowOpacity = shadowOpacity
        }
    }
    
    @IBInspectable var shadowOffset: CGSize = CGSize(width: 0.0, height: 0.0) {
        didSet {
            layer.shadowOffset = shadowOffset
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        clipsToBounds = false
    }
    
}
