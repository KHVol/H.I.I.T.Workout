//
//  UIViewExtension.swift
//  HIITWorkout
//
//  Created by John Griffin on 5/1/19.
//  Copyright © 2019 Kenton Horton. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func setGradientBackground(colorOne: UIColor, colorTwo: UIColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [colorOne.cgColor, colorTwo.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x:0.25,y:0)
        gradientLayer.endPoint = CGPoint(x:0.75,y:1)
        
        layer.insertSublayer(gradientLayer, at: 0)
    }
}
