//
//  ArrayExtensions.swift
//  CropViewController
//
//  Created by Dan Gaffey on 12/16/18.
//  Copyright © 2018 Tim Oliver. All rights reserved.
//

import Foundation


extension Array {
    public init(count: Int, elementCreator: @autoclosure () -> Element) {
        self = (0 ..< count).map { _ in elementCreator() }
    }
}
