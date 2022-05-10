//
//  GradientView.swift
//  VK_GB_ClientServer
//
//  Created by Polina Tikhomirova on 24.12.2021.
//

import UIKit

class GradientView: UIView {
    @IBInspectable private var startColor: UIColor = .white {
        didSet {
            self.updateColors()
        }
    }
    
    @IBInspectable private var endColor: UIColor = .black {
        didSet {
            self.updateColors()
        }
    }
    
    @IBInspectable private var startLocation: CGFloat = 0 {
        didSet {
            self.updateLocations()
        }
    }
    
    @IBInspectable private var endLocation: CGFloat = 1 {
        didSet {
            self.updateLocations()
        }

    }
       
   @IBInspectable private var startPoint: CGPoint = .zero {
       didSet {
           self.updateStartPoint()
       }
   }
    
   @IBInspectable private var endPoint: CGPoint = CGPoint(
                                                            x: 0,
                                                            y: 1
   ) {
       didSet {
           self.updateEndPoint()
       }
   }
   
    override internal static var layerClass: AnyClass {
       return CAGradientLayer.self
   }
   
   private var gradientLayer: CAGradientLayer {
       return self.layer as! CAGradientLayer
   }

   private func updateLocations() {
       self.gradientLayer.locations = [
        self.startLocation as NSNumber,
        self.endLocation as NSNumber
       ]
   }
   
   private func updateColors() {
       self.gradientLayer.colors = [
        self.startColor.cgColor,
        self.endColor.cgColor
       ]
   }

   private func updateStartPoint() {
       self.gradientLayer.startPoint = startPoint
   }

   private func updateEndPoint() {
       self.gradientLayer.endPoint = endPoint
   }
}


