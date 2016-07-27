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
    
    @IBInspectable
    var scale: CGFloat = 1.0
    
    private var axisCenter: CGPoint {
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }
    
    override func drawRect(rect: CGRect) {
        print("yo")
    }

}
