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
    
    private let axesDrawer = AxesDrawer()
    
    @IBInspectable
    var scale: CGFloat = 50.0
    
    @IBInspectable
    private var pointsPerUnit: CGFloat = 25.0 { didSet { setNeedsDisplay() } }
    
    @IBInspectable
    private var axisCenter: CGPoint!  { didSet { setNeedsDisplay() } } // implicit unwrapped point. We will hand it a value as soon as possible
    
    private var centerPoint: CGPoint {
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }
    
    // for zooming in and out
    func changeScale(multiplier: CGFloat) {
        pointsPerUnit *= multiplier
    }
    
    // more center of the axis
    func changeCenter(point: CGPoint) {
        axisCenter = point
    }
    
    func moveCenterX(x: CGFloat) {
        axisCenter.x += x
    }
    
    func moveCenterY(y: CGFloat) {
        axisCenter.y += y
    }
    
    // pan the view around. Changing the axis of the graph accordingly
    
    override func drawRect(rect: CGRect) {
        if axisCenter == nil {
            axisCenter = centerPoint
        }
        axesDrawer.drawAxesInRect(rect, origin: axisCenter, pointsPerUnit: pointsPerUnit)
    }

}
