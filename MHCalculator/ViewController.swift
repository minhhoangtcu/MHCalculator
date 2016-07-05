//
//  ViewController.swift
//  MHCalculator
//
//  Created by Minh Hoang on 6/30/16.
//  Copyright © 2016 Minh Hoang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet private weak var display: UILabel!
    
    private var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        set {
            display.text = String(newValue)
        }
    }

    private var isTyping = false
    private var isTypingFloat = false
    
    private func finishTyping() {
        isTyping = false
        isTypingFloat = false
    }
    
    @IBAction private func numberPressed(sender: UIButton) {
        
        let num = sender.currentTitle!
        
        if num == "." {
            if !isTypingFloat {
                isTypingFloat = true
                display.text = display.text! + num
            }
            // else we just need to ignore, because we cannot have two dots
        } else if isTyping {
            display.text = display.text! + num
        } else {
            display.text = num
            isTyping = true
        }
        
        
    }
    
    private var brain = Brain()

    @IBAction private func operationPressed(sender: AnyObject) {
        finishTyping()
        if let symbol = sender.currentTitle! {
            if (symbol == "AC") {
                displayValue = 0
                brain.clear()
            } else {
                brain.setOperand(displayValue)
                brain.performOperation(symbol)
            }
        }
        displayValue = brain.result
    }
}

