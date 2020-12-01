//
//  UIView+Ext.swift
//  Chat
//
//  Created by p.levishchev on 21.09.2020.
//  Copyright © 2020 p.levishchev. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func addSubviews(_ views: UIView...) {
        for view in views {
            addSubview(view)
        }
    }
}

extension UIView {
    func shake() {
        layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        let rotationAnimation = CAKeyframeAnimation(keyPath: "transform.rotation")
        rotationAnimation.values = [0, -CGFloat(Double.pi / 10), 0, CGFloat(Double.pi / 10), 0]
        rotationAnimation.keyTimes = [0, 0.25, 0.5, 0.75, 1]
        let initialPosition = self.layer.position
        let positionAnimation = CAKeyframeAnimation(keyPath: "position")
        positionAnimation.values = [initialPosition,
                                    CGPoint(x: initialPosition.x + 5, y: initialPosition.y),
                                    CGPoint(x: initialPosition.x, y: initialPosition.y + 5),
                                    CGPoint(x: initialPosition.x - 5, y: initialPosition.y),
                                    CGPoint(x: initialPosition.x, y: initialPosition.y + 5),
                                    initialPosition]
        positionAnimation.keyTimes = [0, 0.2, 0.4, 0.6, 0.8, 1.0]
        
        let group = CAAnimationGroup()
        group.duration = 0.3
        group.repeatCount = .infinity
        group.animations = [rotationAnimation, positionAnimation]
        layer.add(group, forKey: "shake")
    }
    
    func shakeOff() {
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotationAnimation.fromValue = layer.presentation()?.value(forKeyPath: "transform.rotation")
        rotationAnimation.toValue = 0
        
        let positionAnimation = CABasicAnimation(keyPath: "position")
        positionAnimation.fromValue = layer.presentation()?.value(forKey: "position")
        positionAnimation.toValue = CGFloat.zero
        let group = CAAnimationGroup()
        group.duration = 0.3
        group.animations = [rotationAnimation, positionAnimation]
        
        layer.add(group, forKey: "shake")
    }
}
