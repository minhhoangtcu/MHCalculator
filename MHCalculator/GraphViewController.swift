//
//  GraphViewController.swift
//  MHCalculator
//
//  Created by Minh Hoang on 7/26/16.
//  Copyright © 2016 Minh Hoang. All rights reserved.
//

import UIKit

class GraphViewController: UIViewController {
    
    var brain: Brain!
    
    @IBOutlet weak var graphView: GraphView! {
        didSet {
            updateUI()
        }
    }

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
    
    
    private func updateUI() {
        if graphView != nil {
            
            
            
        }
    }
    
}