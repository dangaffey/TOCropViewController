//
//  CropOverlayView.swift
//  CropViewController
//
//  Created by Dan Gaffey on 12/16/18.
//  Copyright © 2018 Tim Oliver. All rights reserved.
//

import Foundation


class CropOverlayView: UIView {
    
    static let cornerWidth: CGFloat = 20.0
    
    override var frame: CGRect {
        didSet {
            layoutLines()
        }
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        layoutLines()
    }
    
    /** Hides the interior grid lines, sans animation. */
    var gridHidden = false
    
    /** Add/Remove the interior horizontal grid lines. */
    var displayHorizontalGridLines = true
    
    /** Add/Remove the interior vertical grid lines. */
    var displayVerticalGridLines = true
    
    var horizontalGridLines = [UIView]()
    var verticalGridLines = [UIView]()
    
    lazy var outerLineViews: [UIView] = {
        return Array(count: 4, elementCreator: self.createNewLineView())
    }()
    
    lazy var topLeftLineViews: [UIView] = {
        return Array(count: 2, elementCreator: self.createNewLineView())
    }()
    
    lazy var bottomLeftLineViews: [UIView] = {
        return Array(count: 2, elementCreator: self.createNewLineView())
    }()
    
    lazy var bottomRightLineViews: [UIView] = {
        return Array(count: 2, elementCreator: self.createNewLineView())
    }()
    
    lazy var topRightLineViews: [UIView] = {
        return Array(count: 2, elementCreator: self.createNewLineView())
    }()
    

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
 
    func commonInit() {
        clipsToBounds = false
        displayHorizontalGridLines = true
        displayVerticalGridLines = true
    }
    
    
    /**
        Generates a new line and adds it to this view
    */
    func createNewLineView() -> UIView {
        let line = UIView(frame: CGRect.zero)
        line.backgroundColor = UIColor.white
        addSubview(line)
        return line
    }
    
    
    func layoutLines() {
        let boundingSize = bounds.size
        
        //border lines
        for i in 0..<4 {
            let lineView = outerLineViews[i]
            var frame = CGRect.zero
            switch i {
            case 0:
                frame = CGRect(x: 0.0, y: -1.0, width: boundingSize.width + 2.0, height: 1.0)
            case 1:
                frame = CGRect(x: boundingSize.width, y: 0.0, width: 1.0, height: boundingSize.height)
            case 2:
                frame = CGRect(x: -1.0, y: boundingSize.height, width: boundingSize.width + 2.0, height: 1.0)
            case 3:
                frame = CGRect(x: -1.0, y: 0, width: 1.0, height: boundingSize.height + 1.0)
            default:
                break
            }
            lineView.frame = frame
        }
        
        
        let cornerLines = [[UIView]](arrayLiteral: topLeftLineViews, topRightLineViews, bottomRightLineViews, bottomLeftLineViews)
        for i in 0..<4 {
            let cornerLine = cornerLines[i]
            var verticalFrame = CGRect.zero
            var horizontalFrame = CGRect.zero
            
            switch i {
            case 0:
                verticalFrame = CGRect(x: -3.0, y: -3.0, width: 3.0, height: CropOverlayView.cornerWidth + 3.0)
                horizontalFrame = CGRect(x: 0.0, y: -3.0, width: CropOverlayView.cornerWidth, height: 3.0)
            case 1:
                verticalFrame = CGRect(x: boundingSize.width, y: -3.0, width: 3.0, height: CropOverlayView.cornerWidth + 3.0)
                horizontalFrame = CGRect(x: boundingSize.width - CropOverlayView.cornerWidth, y: -3.0, width: CropOverlayView.cornerWidth, height: 3.0)
            case 2:
                verticalFrame = CGRect(x: boundingSize.width, y: boundingSize.height - CropOverlayView.cornerWidth, width: 3.0, height: CropOverlayView.cornerWidth + 3.0)
                horizontalFrame = CGRect(x: boundingSize.width - CropOverlayView.cornerWidth, y: boundingSize.height, width: CropOverlayView.cornerWidth, height: 3.0)
            case 3:
                verticalFrame = CGRect(x: -0.3, y: boundingSize.height - CropOverlayView.cornerWidth, width: 3.0, height: CropOverlayView.cornerWidth)
                horizontalFrame = CGRect(x: -0.3, y: boundingSize.height, width: CropOverlayView.cornerWidth + 3.0, height: 3.0)
            default:
                break
            }
            
            cornerLine[0].frame = verticalFrame
            cornerLine[1].frame = horizontalFrame
        }
        
        let thickness = 1.0 / UIScreen.main.scale
        var numberOfLines = horizontalGridLines.count
        var padding = (bounds.height - (thickness * CGFloat(numberOfLines))) / CGFloat(numberOfLines + 1)
        
        for i in 0..<numberOfLines {
            let lineView = horizontalGridLines[i]
            var newFrame = CGRect.zero
            newFrame.size.height = thickness
            newFrame.size.width = bounds.width
            newFrame.origin.y = (padding * CGFloat(i + 1)) + (thickness * CGFloat(i))
            lineView.frame = newFrame
        }
        
        numberOfLines = verticalGridLines.count
        padding = bounds.width - (thickness * CGFloat(numberOfLines)) / CGFloat(numberOfLines + 1)
        for i in 0..<numberOfLines {
            let lineView = verticalGridLines[i]
            var newFrame = CGRect.zero
            newFrame.size.width = thickness
            newFrame.size.height = bounds.height
            newFrame.origin.x = (padding * CGFloat(i + 1)) + (thickness * CGFloat(i))
            lineView.frame = frame
        }
    }
    
    
    
    func setGridHidden(hidden: Bool, animated: Bool) {
        gridHidden = hidden
        guard animated else {
            for lineView in horizontalGridLines {
                lineView.alpha = hidden ? 0.0 : 1.0
            }
            for lineView in verticalGridLines {
                lineView.alpha = hidden ? 0.0 : 1.0
            }
            return
        }
        
        UIView.animate(withDuration: hidden ? 0.35 : 0.2, animations: { [weak self] in
            guard let hGrid = self?.horizontalGridLines,
                let vGrid = self?.verticalGridLines else {
                    return
            }
            for lineView in hGrid {
                lineView.alpha = hidden ? 0.0 : 1.0
            }
            for lineView in vGrid {
                lineView.alpha = hidden ? 0.0 : 1.0
            }
        })
    }
  
    
    func setDisplayHorizontalGridLines(displayHorizontalGridLines: Bool) {
        self.displayHorizontalGridLines = displayHorizontalGridLines
        self.horizontalGridLines.enumerated().forEach { (offset, element) in
            element.removeFromSuperview()
        }
        
        self.horizontalGridLines = self.displayHorizontalGridLines
            ? [createNewLineView(), createNewLineView()]
            : []
        
        setNeedsDisplay()
    }
    
    
    func setDisplayVerticalGridLines(displayVerticalGridLines: Bool) {
        self.displayVerticalGridLines = displayVerticalGridLines
        self.verticalGridLines.enumerated().forEach { (offset, element) in
            element.removeFromSuperview()
        }
        
        self.verticalGridLines = self.displayVerticalGridLines
            ? [createNewLineView(), createNewLineView()]
        : []
        
        setNeedsDisplay()
    }

    
}
