//
//  AvatarView.swift
//  VK_GB_ClientServer
//
//  Created by Polina Tikhomirova on 24.12.2021.
//

import UIKit

public class AvatarImage: UIImageView {
    @IBInspectable private var borderColor: UIColor = .lightGray
    @IBInspectable private var borderWidth: CGFloat = 2
    
    public override func awakeFromNib() {
        self.layer.cornerRadius = self.frame.height / 2
        self.layer.masksToBounds = true
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
    }
    
    public static func animateAvatar(_  object: UIImageView) {
        func setupAnimation(param: CASpringAnimation) {
            param.mass = 1
            param.stiffness = 250
            param.initialVelocity = 1
            param.duration = 1.0
            param.fromValue = object.layer.bounds.size.width - 10
            param.toValue = object.layer.bounds.size.width
        }
       let animationWidth = CASpringAnimation(keyPath: "bounds.size.width")
       setupAnimation(param: animationWidth)

       let animationHeight = CASpringAnimation(keyPath: "bounds.size.height")
       setupAnimation(param: animationHeight)
       
       let animationGroup = CAAnimationGroup()
       animationGroup.animations = [animationWidth, animationHeight]
       object.layer.add(
        animationGroup,
        forKey: nil)
    }
}

public class AvatarBackShadow: UIView {
    @IBInspectable private var shadowColor: UIColor = .lightGray
    @IBInspectable private var shadowOffset: CGSize = CGSize(
                                                width: 2,
                                                height: 2)
    @IBInspectable private var shadowOpacity: Float = 1
    @IBInspectable private var shadowRadius: CGFloat = 5
    
    public override func awakeFromNib() {
        self.backgroundColor = .clear
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOffset = shadowOffset
        self.layer.shadowOpacity = shadowOpacity
        self.layer.shadowRadius = shadowRadius
    }
}

