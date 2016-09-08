//
//  GraphViewController.swift
//  MHCalculator
//
//  Created by Minh Hoang on 7/26/16.
//  Copyright © 2016 Minh Hoang. All rights reserved.
//

import UIKit

class GraphViewController: UIViewController, GraphViewDataSource {
    
    var program: Brain.PropertyList?
    
    @IBOutlet weak var graphView: GraphView! {
        didSet {
            graphView.dataSource = self
        }
    }
    
    func points(sender: GraphView) -> [CGPoint] {
        var points = [CGPoint]()
        
        // at the start of the program, CVC has not segue/transfer brain into GVC
        if program == nil {
            return points
        }
        
        let brain = Brain()
        
        //print("xMin: \(sender.xMin) \txMax: \(sender.xMax)")
        
        var runner = sender.xMin
        while runner <= sender.xMax {
            // We have to reload the brain for each iteration because it will fill itself with data
            brain.clear()
            brain.loadProgram(program!)
            
            if let y = brain.y(Double(runner)) {
                points.append(
                    CGPoint (
                        x: runner*graphView.pointsPerUnit + graphView.axisCenter.x,
                        y: graphView.axisCenter.y - CGFloat(y) * graphView.pointsPerUnit
                    )
                )
                //print("x: \(runner) \ty: \(y)")
            }
            runner += sender.increment
        }
        
        return points
    }
    
    private func updateUI() {
        if graphView != nil {
            
        }
    }
    
    // Mark: Gestures
    
    @IBAction func zoom(regconizer: UIPinchGestureRecognizer) {
        switch regconizer.state {
        case .Changed, .Ended:
            graphView.changeScale(regconizer.scale)
            regconizer.scale = 1.0
        default:
            break
        }
    }
    
    @IBAction func moveCenter(regconizer: UITapGestureRecognizer) {
        switch regconizer.state {
        case .Ended:
            graphView.changeCenter(regconizer.locationInView(graphView))
        default:
            break
        }
    }
    
    @IBAction func pan(regconizer: UIPanGestureRecognizer) {
        switch regconizer.state {
        case .Changed, .Ended:
            let trans = regconizer.translationInView(graphView)
            graphView.moveCenterX(trans.x)
            graphView.moveCenterY(trans.y)
            regconizer.setTranslation(CGPointZero, inView: graphView)
        default:
            break
        }
    }
}