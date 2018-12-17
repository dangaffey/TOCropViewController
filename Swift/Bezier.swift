//
//  UIBezierPathExtensions.swift
//  GiftYa
//
//  Created by Dan Gaffey on 12/12/18.
//  Copyright © 2018 GiftYa, LLC. All rights reserved.
//

import Foundation

enum CustomPath {
    case pick
    case circle
}

extension UIBezierPath {
    
    convenience init?(type: CustomPath, rect: CGRect) {
        
        let min: CGFloat = 1.22  //RATIO MUST BE 1.23 to conform to SVG PATH
        let max: CGFloat = 1.24
        
        let aspectRatio = rect.width / rect.height
        if aspectRatio > max || aspectRatio < min {
            debugPrint("The rect is not the correct dimensions")
            return nil
        }
        
        self.init()
        switch type {
            
            // NOTE: SVG CURVES ARE IN A DIFFERENT ORDER THAN UIBEZIER CURVES
            // SVG Curve = [Control1, Control2, Point]
            // UIBezier  = [Point, Control1, Control2]
            
        case .pick:
            move(to: CGPoint(x: 499.065, y: 201.37)) //M 499.065, 201.37
            addLine(to: CGPoint(x: 499.065, y: 201.39)) //L 499.065, 201.39
            addCurve(to: CGPoint(x: 455.385, y: 360.68), controlPoint1: CGPoint(x: 499.055, y: 277.73), controlPoint2: CGPoint(x: 482.485, y: 328.75)) //C499.055, 277.73 482.485, 328.75 455.385, 360.68
            addCurve(to: CGPoint(x: 0.855, y: 201.39), controlPoint1: CGPoint(x: 333.885, y: 503.84), controlPoint2: CGPoint(x: 0.855, y: 263.44)) //C 333.885,503.84 0.855,263.44 0.855,201.39
            addLine(to: CGPoint(x: 0.855, y: 201.36)) //L0.855,201.36
            addCurve(to: CGPoint(x: 499.065, y: 201.36), controlPoint1: CGPoint(x: 0.855, y: 137.21), controlPoint2: CGPoint(x: 499.035, y: -217.22)) //C0.855,137.21 499.035,-217.22 499.065,201.36
            addLine(to: CGPoint(x: 499.065, y: 201.37)) //L499.065,201.37
            close() //Z
            
            let ratioX = rect.width / self.bounds.width
            let ratioY = rect.height / self.bounds.height
            
            debugPrint("SCALING TO X: \(ratioX) AND Y: \(ratioY)")
            apply(CGAffineTransform(scaleX: ratioX, y: ratioY))
            apply(CGAffineTransform(translationX: 0.0, y: 0.0))
            
        case .circle:
            return
        }
    }
    
    
    
    
    
    
    
    
    
}
