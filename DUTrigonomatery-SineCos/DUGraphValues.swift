//
//  DUGraphValues.swift
//  DUTrigonomatery-SineCos
//
//  Created by Dhaval Trivedi on 28/05/20.
//  Copyright © 2020 Dhaval Trivedi. All rights reserved.
//

import UIKit

class DUGraphValues: NSObject {
    var degree: Int = 0
    var radians: Double = 0
    var xVal: Double = 0
    var yVal: Double = 0
    var rectX: Double = 0.0
    var rectY: Double = 0.0
    var color = UIColor()
    var isSelected = false
    var index = 0
    
    init(degree: Int, radians: Double, xVal: Double, yVal: Double, index: Int, color: UIColor, rectX: Double, rectY: Double) {
        self.degree = degree
        self.radians = radians
        self.xVal = xVal
        self.yVal = yVal
        self.index = index
        self.color = color
        self.rectX = rectX
        self.rectY = rectY
    }
    
}
