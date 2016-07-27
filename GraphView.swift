//
//  GraphView.swift
//  MHCalculator
//
//  Created by Minh Hoang on 7/27/16.
//  Copyright © 2016 Minh Hoang. All rights reserved.
//

import UIKit

@IBDesignable
class GraphView: UIView {
    
    let axesDrawer = AxesDrawer()
    
    @IBInspectable
    var scale: CGFloat = 50.0
    
    @IBInspectable
    var pointsPerUnit: CGFloat = 25.0 { didSet { setNeedsDisplay() } }
    
    func changeScale(multiplier: CGFloat) {
        pointsPerUnit *= multiplier
    }
    
    private var axisCenter: CGPoint {
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }
    
    override func drawRect(rect: CGRect) {
        axesDrawer.drawAxesInRect(rect, origin: axisCenter, pointsPerUnit: pointsPerUnit)
    }

}
