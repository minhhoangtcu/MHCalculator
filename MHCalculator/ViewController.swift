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
    
    private let MAX_CHARS_IN_DISPLAY = 8
    private var isWithinCharsLimit: Bool {
        get {
            return displayLabel.text!.characters.count <= MAX_CHARS_IN_DISPLAY
        }
    }
    
    private var calculatorDisplay: Double {
        get {
            let format = NSNumberFormatter()
            format.numberStyle = .DecimalStyle
            format.maximumFractionDigits = 6
            return format.numberFromString(displayLabel.text!)!.doubleValue
        }
        set {
            let format = NSNumberFormatter()
            format.numberStyle = .DecimalStyle
            format.maximumFractionDigits = 6
            displayLabel.text = format.stringFromNumber(newValue)
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
    
    private var lastProgram: Brain.PropertyList?
    
    @IBAction private func numberPressed(sender: UIButton) {
        
        let num = sender.currentTitle!
        
        if isTyping && isTypingFloat {
            if isWithinCharsLimit {
                appendToDisplay(num)
            }
        } else if isTyping && !isTypingFloat {
            if isWithinCharsLimit {
                calculatorDisplay = calculatorDisplay*10 + Double(num)!
            }
        } else {
            lastProgram = brain.program
            startTypingNumber()
            calculatorDisplay = Double(num)! // safe to unwrap, because only numbers call this function
        }
    }
    
    @IBAction func dotPressed() {
        if !isTypingFloat && isWithinCharsLimit {
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
        
        if let symbol = sender.currentTitle! {
            if isTypingFloat || isTyping { // set the operand according to the display (what user typed in) only when the user actually typed in something. Else, the user is using a variable.
                brain.setOperand(calculatorDisplay)
            }
            lastProgram = brain.program
            brain.performOperation(symbol)
        }
        finishTyping()
        calculatorDisplay = brain.result
        calculatorDescription = brain.description
    }
    
    @IBAction func clearPressed() {
        calculatorDisplay = 0
        calculatorDescription = nil
        brain.clear()
        finishTyping()
    }
    
    private var savedProgram: Brain.PropertyList?
    
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
        if let variable = sender.currentTitle! {
            if !brain.isPartialResult {
                brain.clear()
            }
            brain.setOperand(variable)
        }
    }
    
    @IBAction func saveVariablePressed(sender: AnyObject) {
        if let variable = sender.currentTitle!!.characters.last { // have no idea why I need two "!!"
            brain.addVariable(String(variable), value: calculatorDisplay)
            if lastProgram != nil {
                brain.program = lastProgram! // reload last program to show result
            } else {
                brain.recalculate()
            }
            finishTyping() // before we were typing number for the calculator
            calculatorDisplay = brain.result
            calculatorDescription = brain.description
        }
    }
    
    @IBAction func undoPressed() {
        if isTyping || isTypingFloat {
            if displayLabel.text?.characters.last == "." {
                isTypingFloat = false
            }
            removeLastFromDisplay()
        } else {
            brain.undo()
            calculatorDisplay = brain.result
            calculatorDescription = brain.description
        }
    }
    
    private func removeLastFromDisplay() {
        if displayLabel.text?.characters.count == 1 {
            calculatorDisplay = 0
            finishTyping()
        } else if calculatorDisplay != 0 {
            displayLabel.text!.removeAtIndex(displayLabel.text!.endIndex.predecessor())
        }
    }
    
}

