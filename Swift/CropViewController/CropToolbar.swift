//
//  CropToolbar.swift
//  CropViewController
//
//  Created by Dan Gaffey on 12/17/18.
//  Copyright © 2018 Tim Oliver. All rights reserved.
//

import Foundation


class CropToolbar: UIView {
    
    var statusBarHeightInset: CGFloat?
    
    var backgroundView: UIView?
    var backgroundViewOutsets: UIEdgeInsets?
    
    var doneTextButton: UIButton?
    var doneIconButton: UIButton?
    var cancelTextButton: UIButton?
    var cancelIconButton: UIButton?
    
    var resetButton: UIButton?
    var clampButton: UIButton?
    var rotateButton: UIButton?
    
    var rotateClockwiseButton: UIButton?
    var rotateCounterClockwiseButton: UIButton?
    
    var clampButtonHidden = false
    var rotateCounterClockwiseButtonHidden = false
    var rotateClockwiseButtonHidden = false
    var resetButtonHidden = false
    
    var cancelBtnTapped: (() -> ())?
    var doneButtonTapped: (() -> ())?
    var rotateCounterClockwiseButtonTapped: (() -> ())?
    var rotateClockwiseButtonTapped: (() -> ())?
    var clampButtonTapped: (() -> ())?
    var resetButtonTapped: (() -> ())?
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
        commonInit()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding")
    }
    
    @objc
    func buttonTapped(btn: UIButton) {
        if btn == cancelTextButton || btn == cancelIconButton,
            let closure = cancelBtnTapped {
            closure()
            return
        }
            
        if btn == doneTextButton || btn == doneIconButton,
            let closure = doneButtonTapped {
            closure()
            return
        }
            
        if btn == resetButton,
            let closure = resetButtonTapped {
            closure()
            return
        }
            
        if btn == rotateCounterClockwiseButton,
            let closure = rotateCounterClockwiseButtonTapped {
            closure()
            return
        }
        
        if btn == rotateClockwiseButton,
            let closure = rotateClockwiseButtonTapped {
            closure()
            return
        }
            
        if btn == clampButton,
            let closure = clampButtonTapped {
            closure()
            return
        }
    }
    
    func commonInit() {
        backgroundView = UIView(frame: bounds)
        backgroundView!.backgroundColor = UIColor(white: 0.12, alpha: 1.0)
        addSubview(backgroundView!)
       
        doneTextButton = UIButton(type: .system)
        doneTextButton!.setTitle("Done", for: .normal)
        doneTextButton!.setTitleColor(UIColor(red: 1.0, green: 0.8, blue: 0.0, alpha: 1.0), for: .normal)
        doneTextButton!.titleLabel?.font = UIFont(name: "Roboto-Regular", size: 17.0)
        doneTextButton!.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        doneTextButton!.sizeToFit()
        addSubview(doneTextButton!)
        
        doneIconButton = UIButton(type: .system)
        doneIconButton?.setImage(doneImage(), for: .normal)
        doneIconButton?.setTitleColor(UIColor(red: 1.0, green: 0.8, blue: 0.0, alpha: 2.0), for: .normal)
        doneIconButton?.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        addSubview(doneIconButton!)
        
        cancelTextButton = UIButton(type: .system)
        cancelTextButton!.setTitle("Cancel", for: .normal)
        cancelTextButton!.setTitleColor(UIColor(red: 1.0, green: 0.8, blue: 0.0, alpha: 1.0), for: .normal)
        cancelTextButton!.titleLabel?.font = UIFont(name: "Roboto-Regular", size: 17.0)
        cancelTextButton!.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        cancelTextButton!.sizeToFit()
        addSubview(cancelTextButton!)
        
        cancelIconButton = UIButton(type: .system)
        cancelIconButton?.setImage(cancelImage(), for: .normal)
        cancelIconButton?.setTitleColor(UIColor(red: 1.0, green: 0.8, blue: 0.0, alpha: 2.0), for: .normal)
        cancelIconButton?.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        addSubview(cancelIconButton!)
        
        clampButton = UIButton(type: .system)
        clampButton?.contentMode = .center
        clampButton?.tintColor = UIColor.white
        clampButton?.setImage(clampImage(), for: .normal)
        clampButton?.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        addSubview(clampButton!)
  
        rotateCounterClockwiseButton = UIButton(type: .system)
        rotateCounterClockwiseButton?.contentMode = .center
        rotateCounterClockwiseButton?.tintColor = UIColor.white
        rotateCounterClockwiseButton?.setImage(rotateCounterClockwiseImage(), for: .normal)
        rotateCounterClockwiseButton?.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        addSubview(rotateCounterClockwiseButton!)
    
        rotateClockwiseButton = UIButton(type: .system)
        rotateClockwiseButton?.contentMode = .center
        rotateClockwiseButton?.tintColor = UIColor.white
        rotateClockwiseButton?.setImage(rotateClockwiseImage(), for: .normal)
        rotateClockwiseButton?.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        addSubview(rotateClockwiseButton!)
        
        resetButton = UIButton(type: .system)
        resetButton?.contentMode = .center
        resetButton?.tintColor = UIColor.white
        resetButton?.isEnabled = false
        resetButton?.setImage(resetImage(), for: .normal)
        resetButton?.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        addSubview(resetButton!)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let verticalLayout = bounds.width < bounds.height
        
        self.cancelIconButton?.isHidden = !verticalLayout
        self.cancelTextButton?.isHidden = verticalLayout
        self.doneIconButton?.isHidden = !verticalLayout
        self.doneTextButton?.isHidden = verticalLayout
        
        guard let outsets = backgroundViewOutsets else {
            return
        }
        
        var boundingFrame = bounds
        boundingFrame.origin.x -= outsets.left
        boundingFrame.origin.y -= outsets.top
        
        boundingFrame.size.width += outsets.left
        boundingFrame.size.width += outsets.right
        
        boundingFrame.size.height += outsets.top
        boundingFrame.size.height += outsets.bottom
        backgroundView?.frame = boundingFrame
        
        
        guard verticalLayout != false else {
            setHorizontalLayout()
            return
        }
        
        setVerticalLayout()
    }
    
    
    
    func setVerticalLayout() {
        guard let cancelIconBtn = cancelIconButton,
            let doneIconBtn = doneIconButton,
            let inset = statusBarHeightInset else {
                return
        }
        
        var frame = CGRect.zero
        frame.size.height = 44.0
        frame.size.width = 44.0
        frame.origin.y = bounds.height - 44.0
        cancelIconBtn.frame = frame
    
        frame.origin.y = inset
        frame.size.width = 44.0
        frame.size.height = 44.0
        doneIconBtn.frame = frame
        
        let containerRect = CGRect(
            x: 0.0,
            y: doneIconBtn.frame.maxY,
            width: 44.0,
            height: cancelIconBtn.frame.minY - doneIconBtn.frame.maxY
        )
        
        let btnSize = CGSize(width: 44.0, height: 44.0)
        
        var verticalBtns = [UIButton]()
        if let btn = rotateCounterClockwiseButton,
            !rotateCounterClockwiseButtonHidden {
            verticalBtns.append(btn)
        }
        
        if let btn = resetButton,
            !resetButtonHidden {
            verticalBtns.append(btn)
        }
        
        if let btn = clampButton,
            !clampButtonHidden {
            verticalBtns.append(btn)
        }
        
        if let btn = rotateClockwiseButton,
            !rotateClockwiseButtonHidden {
            verticalBtns.append(btn)
        }
        
        layoutToolbarButtons(buttons: verticalBtns, size: btnSize, rect: containerRect, horizontally: false)
    }
    
    
    
    
    func setHorizontalLayout() {
        let boundingSize = bounds.size
        
        guard let cancelTxtBtn = cancelTextButton,
            let doneTxtBtn = doneTextButton else {
            return
        }
        
        let insetPadding: CGFloat = 10.0
        var newFrame = CGRect.zero
        newFrame.size.height = 44.0
        newFrame.size.width = min(frame.size.width / 3.0, cancelTxtBtn.frame.size.width)
        newFrame.origin.x = insetPadding
        cancelTxtBtn.frame = newFrame
        
        newFrame.size.width = min(frame.size.width / 3.0, doneTxtBtn.frame.size.width)
        newFrame.origin.x = boundingSize.width - (newFrame.size.width + insetPadding)
        doneTxtBtn.frame = newFrame
        
        let x = cancelTxtBtn.frame.maxX
        let width = doneTxtBtn.frame.minX - cancelTxtBtn.frame.maxX
        let containerRect = CGRect(x: x, y: newFrame.origin.y, width: width, height: 44.0).integral
        let buttonSize = CGSize(width: 44.0, height: 44.0)
        
        var horizontalBtns = [UIButton]()
        if let btn = rotateCounterClockwiseButton,
            !rotateCounterClockwiseButtonHidden {
            horizontalBtns.append(btn)
        }
        
        if let btn = resetButton,
            !resetButtonHidden {
            horizontalBtns.append(btn)
        }
        
        if let btn = clampButton,
            !clampButtonHidden {
            horizontalBtns.append(btn)
        }
        
        if let btn = rotateClockwiseButton,
            rotateClockwiseButtonHidden {
            horizontalBtns.append(btn)
        }
        
        layoutToolbarButtons(buttons: horizontalBtns, size: buttonSize, rect: containerRect, horizontally: true)
    }
    
    
    // The convenience method for calculating button's frame inside of the container rect
    func layoutToolbarButtons(buttons: [UIButton], size: CGSize, rect: CGRect, horizontally: Bool) {
        guard buttons.count > 0 else {
            return
        }
        
        let count = buttons.count
        let fixedSize = horizontally ? size.width : size.height
        let maxLength = horizontally ? rect.width : rect.height
        let padding = (maxLength - fixedSize * CGFloat(count)) / CGFloat(count + 1)
        
        for i in 0..<count {
            let btn = buttons[i]
            let sameOffset = horizontally ? abs(rect.height - btn.bounds.height) : abs(rect.width - btn.bounds.width)
            let diffOffset = padding + CGFloat(i) * CGFloat(fixedSize + padding)
            var origin = horizontally ? CGPoint(x: diffOffset, y: sameOffset) : CGPoint(x: sameOffset, y: diffOffset)
            if (horizontally) {
                origin.x += rect.minX
            } else {
                origin.y += rect.minY
            }
            btn.frame = CGRect(origin: origin, size: size)
        }
    }
    
    
    func doneImage() -> UIImage? {
        var doneImage: UIImage?
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 17, height: 14), false, 0.0)
        let rectanglePath = UIBezierPath()
        rectanglePath.move(to: CGPoint(x: 1.0, y: 7.0))
        rectanglePath.addLine(to: CGPoint(x: 6.0, y: 12.0))
        rectanglePath.addLine(to: CGPoint(x: 16.0, y: 1.0))
        UIColor.white.setStroke()
        rectanglePath.lineWidth = 2
        rectanglePath.stroke()
        doneImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return doneImage
    }
    
    
    func cancelImage() -> UIImage? {
        var cancelImage: UIImage?
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 16, height: 16), false, 0.0)
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 15.0, y: 15.0))
        bezierPath.addLine(to: CGPoint(x: 1.0, y: 1.0))
        UIColor.white.setStroke()
        bezierPath.lineWidth = 2
        bezierPath.stroke()
        
        let bezierPath2 = UIBezierPath()
        bezierPath2.move(to: CGPoint(x: 1.0, y: 15.0))
        bezierPath2.addLine(to: CGPoint(x: 15.0, y: 1.0))
        UIColor.white.setStroke()
        bezierPath2.lineWidth = 2
        bezierPath2.stroke()
        
        cancelImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return cancelImage
    }
    
    
    func clampImage() -> UIImage? {
        var clampImage: UIImage?
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 22, height: 16), false, 0.0)
        let outerBox = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.553)
        let innerBox = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.773)
        
        let rectanglePath = UIBezierPath(rect: CGRect(x: 0.0, y: 3.0, width: 13.0, height: 13.0))
        UIColor.white.setFill()
        rectanglePath.fill()
        
        let topPath = UIBezierPath(rect: CGRect(x: 0.0, y: 0.0, width: 22.0, height: 2.0))
        outerBox.setFill()
        topPath.fill()
        
        let sidePath = UIBezierPath(rect: CGRect(x: 19.0, y: 2.0, width: 3.0, height: 14.0))
        outerBox.setFill()
        sidePath.fill()
        
        let rectanglePath2 = UIBezierPath(rect: CGRect(x: 14.0, y: 3.0, width: 4.0, height: 13.0))
        innerBox.setFill()
        rectanglePath2.fill()
        
        clampImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return clampImage;
    }
    
    
    
    func rotateCounterClockwiseImage() -> UIImage? {
        var rotateImage: UIImage?
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 18, height: 21), false, 0.0)
        let rectanglePath = UIBezierPath(rect: CGRect(x: 0.0, y: 9.0, width: 12.0, height: 12.0))
        UIColor.white.setFill()
        rectanglePath.fill()
        
        let rectanglePath2 = UIBezierPath()
        rectanglePath2.move(to: CGPoint(x: 5.0, y: 3.0))
        rectanglePath2.addLine(to: CGPoint(x: 10.0, y: 6.0))
        rectanglePath2.addLine(to: CGPoint(x: 10.0, y: 0.0))
        rectanglePath2.addLine(to: CGPoint(x: 5.0, y: 3.0))
        rectanglePath2.close()
        UIColor.white.setFill()
        rectanglePath2.fill()
        
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 10.0, y: 3.0))
        bezierPath.addCurve(to: CGPoint(x: 17.5, y: 11.0), controlPoint1: CGPoint(x: 15.0, y: 3.0), controlPoint2: CGPoint(x: 17.5, y: 5.91))
        UIColor.white.setStroke()
        bezierPath.lineWidth = 1
        bezierPath.stroke()
        
        rotateImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return rotateImage;
    }
    
    
    func rotateClockwiseImage() -> UIImage? {
        var rotateClockwiseImage: UIImage?
        guard let image = rotateCounterClockwiseImage(),
            let imageSrc = image.cgImage else {
                return nil
        }
        
        UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        context.translateBy(x: image.size.width, y: image.size.height)
        context.rotate(by: .pi)
        context.draw(imageSrc, in: CGRect(x: 0.0, y: 0.0, width: image.size.width, height: image.size.height))
        rotateClockwiseImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return rotateClockwiseImage
    }
    
    
    func resetImage() -> UIImage? {
        var resetImage: UIImage?
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 22.0, height: 18.0), false, 0.0)
        
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 22.0, y: 9.0))
        bezierPath.addCurve(to: CGPoint(x: 13.0, y: 18.0), controlPoint1: CGPoint(x: 22.0, y: 13.97), controlPoint2: CGPoint(x: 17.97, y: 18.0))
        bezierPath.addCurve(to: CGPoint(x: 13.0, y: 16.0), controlPoint1: CGPoint(x: 13.0, y: 17.35), controlPoint2: CGPoint(x: 13.0, y: 16.68))
        bezierPath.addCurve(to: CGPoint(x: 20.0, y: 9.0), controlPoint1: CGPoint(x: 16.87, y: 16.0), controlPoint2: CGPoint(x: 20.0, y: 12.87))
        bezierPath.addCurve(to: CGPoint(x: 13.0, y: 2.0), controlPoint1: CGPoint(x: 20.0, y: 5.13), controlPoint2: CGPoint(x: 16.87, y: 2.0))
        bezierPath.addCurve(to: CGPoint(x: 6.55, y: 6.27), controlPoint1: CGPoint(x: 10.1, y: 2.0), controlPoint2: CGPoint(x: 7.62, y: 3.76))
        bezierPath.addCurve(to: CGPoint(x: 6.0, y: 9.0), controlPoint1: CGPoint(x: 6.2, y: 7.11), controlPoint2: CGPoint(x: 6.0, y: 8.03))
        bezierPath.addLine(to: CGPoint(x: 4.0, y: 9.0))
        bezierPath.addCurve(to: CGPoint(x: 4.65, y: 5.63), controlPoint1: CGPoint(x: 4.0, y: 7.81), controlPoint2: CGPoint(x: 4.23, y: 6.67))
        bezierPath.addCurve(to: CGPoint(x: 7.65, y: 1.76), controlPoint1: CGPoint(x: 5.28, y: 4.08), controlPoint2: CGPoint(x: 6.32, y: 2.74))
        bezierPath.addCurve(to: CGPoint(x: 13.0, y: 0.0), controlPoint1: CGPoint(x: 9.15, y: 0.65), controlPoint2: CGPoint(x: 11.0, y: 0.0))
        bezierPath.addCurve(to: CGPoint(x: 22.0, y: 9.0), controlPoint1: CGPoint(x: 17.97, y: 0.0), controlPoint2: CGPoint(x: 22.0, y: 4.03))
        bezierPath.close()
        UIColor.white.setStroke()
        bezierPath.fill()
        
        let polygonPath = UIBezierPath()
        polygonPath.move(to: CGPoint(x: 5.0, y: 15.0))
        polygonPath.addLine(to: CGPoint(x: 10.0, y: 9.0))
        polygonPath.addLine(to: CGPoint(x: 0.0, y: 9.0))
        polygonPath.addLine(to: CGPoint(x: 5.0, y: 15.0))
        polygonPath.close()
        UIColor.white.setFill()
        polygonPath.fill()
        
        resetImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return resetImage
    }
    
    
 
}
