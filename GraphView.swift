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
    
    // determine how many points per a unit. For example, if you want 50 points between 0 and 2, you would set pointsperUnit to 25. So, the bigger pointsperUnit, the smaller the graph is.
    @IBInspectable
    private var pointsPerUnit: CGFloat = 25.0 { didSet { setNeedsDisplay() } }
    
    @IBInspectable
    private var axisCenter: CGPoint!  { didSet { setNeedsDisplay() } } // implicit unwrapped point. We will hand it a value as soon as possible
    
    private var centerPoint: CGPoint {
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }
    
    func drawFunction(function: (Double) -> Double) {
        let path = UIBezierPath()
        path.moveToPoint(CGPoint(x: bounds.minX, y: axesDrawer.align(axisCenter.y)))
        
        let widthInPixel = bounds.width
        
        for i in Int(bounds.minX)...Int(widthInPixel) {
            path.addLineToPoint(CGPoint(x: CGFloat(i), y: axesDrawer.align(CGFloat(function(Double(i))))))
        }
        
        path.stroke()
        setNeedsDisplay()
    }
    
    // for zooming in and out
    func changeScale(multiplier: CGFloat) {
        pointsPerUnit *= multiplier
    }
    
    // move center of the axis
    func changeCenter(point: CGPoint) {
        axisCenter = point
    }
    
    // move center horizontally by specified points
    func moveCenterX(x: CGFloat) {
        axisCenter.x += x
    }
    
    // move center vertically by specified points
    func moveCenterY(y: CGFloat) {
        axisCenter.y += y
    }
    
    override func drawRect(rect: CGRect) {
        if axisCenter == nil {
            axisCenter = centerPoint
        }
        axesDrawer.drawAxesInRect(rect, origin: axisCenter, pointsPerUnit: pointsPerUnit)
    }

}
