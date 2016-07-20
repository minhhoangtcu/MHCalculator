//
//  ViewController.swift
//  MHCalculator
//
//  Created by Minh Hoang on 6/30/16.
//  Copyright © 2016 Minh Hoang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet private weak var displayLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    private var calculatorDisplay: Double {
        get {
            return Double(displayLabel.text!)!
        }
        set {
            displayLabel.text = String(newValue)
        }
    }
    
    private var calculatorDescription: String? {
        get {
            return descriptionLabel.text
        }
        set {
            descriptionLabel.text = newValue
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
        
        if isTyping && isTypingFloat {
            appendToDisplay(num)
        } else if isTyping && !isTypingFloat {
            calculatorDisplay = calculatorDisplay*10 + Double(num)!
        } else {
            startTypingNumber()
            calculatorDisplay = Double(num)! // safe to unwrap, because only numbers call this function
        }
    }
    
    @IBAction func dotPressed() {
        if !isTypingFloat {
            isTypingFloat = true
            appendToDisplay(".")
            startTypingNumber()
        }
        // else we just need to ignore, because we cannot have two dots
    }
    
    private func startTypingNumber() {
        if !brain.isPartialResult {
            brain.clear()
        }
        isTyping = true
    }
    
    private func appendToDisplay(text: String) {
        displayLabel.text = displayLabel.text! + text
    }
    
    private var brain = Brain()

    @IBAction private func operationPressed(sender: AnyObject) {
        finishTyping()
        if let symbol = sender.currentTitle! {
            brain.setOperand(calculatorDisplay)
            brain.performOperation(symbol)
        }
        calculatorDisplay = brain.result
        calculatorDescription = brain.description
    }
    
    @IBAction func clearPressed() {
        calculatorDisplay = 0
        calculatorDescription = nil
        brain.clear()
        finishTyping()
    }
    
    var savedProgram: Brain.PropertyList?
    
    @IBAction func savePressed() {
        savedProgram = brain.program
    }
    
    @IBAction func restorePressed() {
        if savedProgram != nil {
            brain.program = savedProgram!
            calculatorDisplay = brain.result
            calculatorDescription = brain.description
        }
    }
    
    @IBAction func memorizedVariablePressed(sender: AnyObject) {
        
    }
    
    @IBAction func saveVariablePressed(sender: AnyObject) {
        
    }
    
    
}

