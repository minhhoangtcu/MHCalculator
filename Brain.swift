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
    
    // keeps track of the sequence of operands and operations passed into the calculator
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
    private var isPartialResult: Bool = false
    
    // the output of the calculator
    var result: Double {
        get {
            return accumulator
        }
    }
    
    // the input of the calculator
    func setOperand(operand: Double) {
        accumulator = operand
    }
    
    private var operations: Dictionary<String,Operation> = [
        "🍕" : Operation.Constant(M_PI),
        "cos" : Operation.UnaryOperation({ cos($0) }),
        "sin" : Operation.UnaryOperation({ sin($0) }),
        "=" : Operation.Equal,
        "+" : Operation.BinaryOperation( {$0 + $1}),
        "-" : Operation.BinaryOperation( {$0 - $1}),
        "*" : Operation.BinaryOperation( {$0 * $1}),
        "/" : Operation.BinaryOperation( {$0 / $1}),
        "℃" : Operation.UnaryOperation( {($0 - 32) * 5 / 9}),
        "℉" : Operation.UnaryOperation( {$0 * 9/5 + 32}),
        "√" : Operation.UnaryOperation( {sqrt($0)})
    ]
    
    private enum Operation {
        case Constant(Double)
        case UnaryOperation((Double) -> Double)
        case BinaryOperation((Double, Double) -> Double)
        case Equal
    }
    
    func performOperation(symbol: String) {
        
        if let operation = operations[symbol] {
            switch operation {
            case .BinaryOperation(let function):
                
                // Populate the sequence
                if sequence.isEmpty {
                    sequence.append(String(accumulator)) // we only need to add left side operand if it is at the start of the sequence
                }
                sequence.append(symbol)
                
                // if before performing this operation, we have another binary operation, then we should perform it and get the result as the 1st operand
                if (pendingOperation != nil) {
                    executePendingOperation()
                }
                pendingOperation = PendingBinaryOperation(binaryOperation: function, firstOperand: accumulator)
                isPartialResult = true
                
            case .Constant(let num):
                accumulator = num
                isPartialResult = false
                
            case .UnaryOperation(let function):
                
                if (isPartialResult) {
                    sequence.append(getWrapedString(symbol, text: String(accumulator)))
                } else {
                    // Populate the sequence
                    if (sequence.isEmpty) {
                        sequence.append(String(accumulator)) // If there is already a sequence in the descriptor, then we just need to wrap it up. Else, we need to insert whatever in the accumulator in.
                    }
                    wrapSequence(symbol);
                }
                
                accumulator = function(accumulator)
                isPartialResult = false
                
            case .Equal:
                if isPartialResult {
                    sequence.append(String(accumulator)) // Only time when we need to put accumulator is after removing ...
                    isPartialResult = false
                }
                if pendingOperation != nil {
                    executePendingOperation()
                }
            }
        }
    }
    
    private func getWrapedString(symbol: String, text: String) -> String {
        return "\(symbol)(\(accumulator))"
    }
    
    private func wrapSequence(symbol: String) {
        sequence.insert("(", atIndex: 0)
        sequence.insert(symbol, atIndex: 0)
        sequence.append(")")
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
        accumulator = 0
        pendingOperation = nil
        sequence.removeAll()
    }
    
}




