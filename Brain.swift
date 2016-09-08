//
//  Brain.swift
//  MHCalculator
//
//  Created by Minh Hoang on 7/1/16.
//  Copyright © 2016 Minh Hoang. All rights reserved.
//

import Foundation

class Brain {
    
    private var accumulator: Double = 0
    
    // keep track of operands and operations
    private var internalProgram = [AnyObject]()
    
    // a sequence of operands, operations, parenthesis, etc. to help visualize the calculator
    private var sequence: [String] = []
    
    // generate description based on sequence of operands/operations
    var description: String {
        get {
            if sequence.count == 0 {
                return " "
            } else {
                var result = ""
                for o in sequence {
                    result = result + "\(o) "
                }
                
                // Add equal sign at the end
                if isPartialResult {
                    result = result + " ... "
                } else {
                    result = result + " = "
                }
                
                return result
            }
        }
    }
    
    // return true if there are still pending operations, such as +, -, /, *
    var isPartialResult: Bool = false
    
    // the output of the calculator
    var result: Double {
        get {
            return accumulator
        }
    }
    
    // set the operand/accumulator of the calculator. This method is called after an user entered a number
    func setOperand(operand: Double) {
        accumulator = operand
        isAccumulatorAVariable = false
        internalProgram.append(operand)
    }
    
    private var variableValues: Dictionary<String, Double> = [:]
    private var isAccumulatorAVariable = false
    private var lastVariable: String?
    
    // set the operand/accumulator of the calculator. This method is called after an user pressed any variable button
    func setOperand(operand: String) {
        if let value = variableValues[operand] {
            accumulator = value
        } else {
            accumulator = 0.0
        }
        lastVariable = operand
        isAccumulatorAVariable = true
        internalProgram.append(operand)
    }
    
    func addVariable(variable: String, value: Double) {
        variableValues[variable] = value
    }
    
    private var operations: Dictionary<String,Operation> = [
        "🍕" : Operation.Constant(M_PI),
        "cos" : Operation.UnaryOperation({ cos($0) }),
        "sin" : Operation.UnaryOperation({ sin($0) }),
        "tan" : Operation.UnaryOperation({ tan($0) }),
        "=" : Operation.Equal,
        "+" : Operation.BinaryOperation( {$0 + $1}),
        "-" : Operation.BinaryOperation( {$0 - $1}),
        "*" : Operation.BinaryOperation( {$0 * $1}),
        "/" : Operation.BinaryOperation( {$0 / $1}),
        "℃" : Operation.UnaryOperation( {($0 - 32) * 5 / 9}),
        "℉" : Operation.UnaryOperation( {$0 * 9/5 + 32}),
        "√" : Operation.UnaryOperation( {sqrt($0)}),
        "XOR" : Operation.BinaryOperation( {Double(Int($0) ^ Int($1))} ),
        "Inverse" : Operation.UnaryOperation( { -$0 } )
    ]
    
    private enum Operation {
        case Constant(Double)
        case UnaryOperation((Double) -> Double)
        case BinaryOperation((Double, Double) -> Double)
        case Equal
    }
    
    private var lastOperation: Operation = Operation.Constant(M_PI)
    
    func performOperation(symbol: String) {
        
        if let operation = operations[symbol] {
            
            switch operation {
            case .BinaryOperation(let function):
                
                // Populate the sequence
                if sequence.isEmpty {
                    addAccumulatorToSequence() // we only need to add left side operand if it is at the start of the sequence
                }
                
                if pendingOperation != nil {
                    // if before performing this operation, we have another binary operation, then we should perform it and get the result as the 1st operand
                    if isLastOperationWasUnary() == false {
                        addAccumulatorToSequence() // if last operation was unary then we have already have the operand in the descriptor
                    }
                    executePendingOperation()
                }
                
                sequence.append(symbol)
                pendingOperation = PendingBinaryOperation(binaryOperation: function, firstOperand: accumulator)
                isPartialResult = true
                
            case .Constant(let num):
                accumulator = num
                
            case .UnaryOperation(let function):
                
                if (isPartialResult) {
                    addAccumulatedWrappedWith(symbol)
                } else {
                    // Populate the sequence
                    if (sequence.isEmpty) {
                        addAccumulatorToSequence() // If there is already a sequence in the descriptor, then we just need to wrap it up. Else, we need to insert whatever in the accumulator in.
                    }
                    wrapSequence(symbol);
                }
                
                accumulator = function(accumulator)
                
            case .Equal:
                
                if isPartialResult && !isLastOperationWasUnary() {
                        addAccumulatorToSequence() // We need to add accumulator if we have a pending operation and if it is not just after the unary operation, because the unary already append the result and other operation does not.
                        isPartialResult = false
                }
                
                if pendingOperation != nil {
                    executePendingOperation()
                }
                
                isPartialResult = false
            }
            
            internalProgram.append(symbol)
            lastOperation = operation
        }
    }
    
    private func isLastOperationWasUnary() -> Bool {
        switch lastOperation { // I could not figure out how to compare the type of an object with an enum, so we have to do this switch thing
        case .UnaryOperation(_):
            return true
        default:
            return false
        }
    }
    
    private func getWrapedString(symbol: String, text: String) -> String {
        return "\(symbol)(\(text))"
    }
    
    private func wrapSequence(symbol: String) {
        sequence.insert("(", atIndex: 0)
        sequence.insert(symbol, atIndex: 0)
        sequence.append(")")
    }
    
    private func addAccumulatorToSequence() {
        if isAccumulatorAVariable && lastVariable != nil {
            sequence.append(lastVariable!)
        } else {
            sequence.append(String(accumulator))
        }
    }
    
    private func addAccumulatedWrappedWith(symbol: String) {
        if isAccumulatorAVariable && lastVariable != nil {
            sequence.append(getWrapedString(symbol, text: lastVariable!))
        } else {
            sequence.append(getWrapedString(symbol, text: String(accumulator)))
        }
    }
    
    private func executePendingOperation() {
        accumulator =  pendingOperation!.binaryOperation(pendingOperation!.firstOperand, accumulator)
        pendingOperation = nil
    }
    
    private var pendingOperation: PendingBinaryOperation?
    
    // We need to save the last used binary operation in case the user hit equal
    private struct PendingBinaryOperation {
        var binaryOperation: (Double, Double) -> Double
        var firstOperand: Double
    }
    
    func clear() {
        print("Brain: cleared all")
        accumulator = 0
        pendingOperation = nil
        sequence.removeAll()
        internalProgram.removeAll()
    }
    
    typealias PropertyList = AnyObject
    
    var program: PropertyList {
        get {
            return internalProgram
        }
        set {
            clear()
            if let arrayOfOps = newValue as? [AnyObject] {
                runProgram(arrayOfOps)
            }
        }
    }
    
    func recalculate() {
        sequence.removeAll()
        runProgram(internalProgram)
    }
    
    func undo() {
        if internalProgram.count != 0 {
            var lastProgram = internalProgram
            
            // remove all operands before an operation and remove the last operation
            while !isOperation(lastProgram.last!) { // more than 1 -> can unwrap
                lastProgram.removeLast()
            }
            lastProgram.removeLast()
            
            clear()
            runProgram(lastProgram)
        }
    }
    
    private func runProgram(arrayOfOps: PropertyList) {
        for op in arrayOfOps as! [AnyObject] {
            if isDouble(op) {
                setOperand(op as! Double)
            } else if isOperation(op) {
                performOperation(op as! String)
            } else {
                setOperand(op as! String) // has to be a variable
            }
        }
    }

    private func isDouble(text: AnyObject) -> Bool {
        if let _ = text as? Double {
            return true
        }
        return false
    }

    private func isOperation(text: AnyObject) -> Bool {
        if let s = text as? String {
            if operations[s] != nil {
                return true
            }
        }
        return false
    }
    
    // Generate the output of the function y for the given internal program.
    public func y(x: Double) -> Double? {
        if internalProgram.count == 0 {
            return nil
        }
        addVariable("M", value: x)
        recalculate()
        return accumulator
    }
}




