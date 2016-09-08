//
//  GraphView.swift
//  MHCalculator
//
//  Created by Minh Hoang on 7/27/16.
//  Copyright © 2016 Minh Hoang. All rights reserved.
//

import UIKit

// Declare the dataSource of the graphView, so that it can be used be other program.
protocol GraphViewDataSource: class {
    func points(sender: GraphView) -> [CGPoint]
}

@IBDesignable
class GraphView: UIView {
    
    // Mark: Properties of the graph. They can change how the graph is going to look like (color, scale, width).
    
    @IBInspectable
    var pointsPerUnit: CGFloat = 25.0 { didSet { setNeedsDisplay() } } // determine how many points per a unit. For example, if you want 50 points between 0 and 2, you would set pointsperUnit to 25. So, the bigger pointsperUnit, the smaller the graph is.
    
    @IBInspectable
    var axisCenter: CGPoint!  { didSet { setNeedsDisplay() } } // implicit unwrapped point. We will hand it a value as soon as possible
    
    @IBInspectable
    private var lineWidth: CGFloat = 3 { didSet { setNeedsDisplay() } }
    
    @IBInspectable
    var pathColor: UIColor = UIColor.blackColor() { didSet { setNeedsDisplay() } }
    
    private var centerPoint: CGPoint {
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }
    
    // Mark: Variables for GVC to generate all points for the view to graph
    
    var xMin: CGFloat { get { return -axisCenter.x / pointsPerUnit } }
    var xMax: CGFloat { get { return xMin + bounds.size.width / pointsPerUnit } }
    var increment: CGFloat { get { return 1.0 / pointsPerUnit } }
    
    // Mark: Graph drawing functions
    
    private let axesDrawer = AxesDrawer()
    weak var dataSource: GraphViewDataSource?
    
    override func drawRect(rect: CGRect) {
        // Give initial value for the center
        if axisCenter == nil {
            axisCenter = centerPoint
        }
        
        axesDrawer.drawAxesInRect(rect, origin: axisCenter, pointsPerUnit: pointsPerUnit)
        drawGraph()
    }
    
    func drawGraph() {

        // set up the path
        let path = UIBezierPath()
        path.lineWidth = lineWidth
        pathColor.set()
        
        // draw the graph
        if var points = dataSource?.points(self) where points.count > 1 {
            let firstPoint = points.removeFirst()
            path.moveToPoint(firstPoint)
            for point in points {
                path.addLineToPoint(point)
            }
        }
        
        path.stroke()
        setNeedsDisplay()
    }
    
    // MARK: Gestures
    
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
}
