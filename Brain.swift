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
    
    var description: String {
        get {
            if sequence.count == 0 {
                return " "
            } else {
                var result = ""
                for o in sequence {
                    result = result + "\(o) "
                }
                return result
            }
        }
    }
    
    // return true if there are still pending operations, such as +, -, /, *
    private var isPartialResult: Bool {
        get {
            return pendingOperation != nil
        }
    }
    
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
        "/" : Operation.BinaryOperation( {$0 / $1})
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
                sequence.append(String(accumulator))
                sequence.append(symbol)
                sequence.append("...")
                
                // if before performing this operation, we have another binary operation, then we should perform it and get the result as the 1st operand
                if (pendingOperation != nil) {
                    executePendingOperation()
                }
                pendingOperation = PendingBinaryOperation(binaryOperation: function, firstOperand: accumulator)
                
            case .Constant(let num):
                accumulator = num
            case .UnaryOperation(let function):
                
                // Populate the sequence
                sequence.append(symbol)
                sequence.append("(\(accumulator))")
                
                accumulator = function(accumulator)
                
            case .Equal:
                if (pendingOperation != nil) {
                    executePendingOperation()
                }
            }
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
        accumulator = 0
        pendingOperation = nil
    }
    
}




