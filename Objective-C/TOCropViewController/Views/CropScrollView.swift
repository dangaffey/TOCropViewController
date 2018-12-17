//
//  CropScrollView.swift
//  CropViewController
//
//  Created by Dan Gaffey on 12/17/18.
//  Copyright © 2018 Tim Oliver. All rights reserved.
//

import Foundation


class CropScrollView: UIScrollView {
    
    var touchesBegan: (() -> ())?
    var touchesEnded: (() -> ())?
    var touchesCancelled: (() -> ())?
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let closure = touchesBegan {
            closure()
        }
        super.touchesBegan(touches, with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let closure = touchesEnded {
            closure()
        }
        super.touchesEnded(touches, with: event)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let closure = touchesEnded {
            closure()
        }
        super.touchesEnded(touches, with: event)
    }
}
