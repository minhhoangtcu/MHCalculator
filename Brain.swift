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
    
    var result: Double {
        get {
            return accumulator
        }
    }
    
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
                // if before performing this operation, we have another binary operation, then we should perform it and get the result as the 1st operand
                if (pendingOperation != nil) {
                    executePendingOperation()
                }
                pendingOperation = PendingBinaryOperation(binaryOperation: function, firstOperand: accumulator)
            case .Constant(let num):
                accumulator = num
            case .UnaryOperation(let function):
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




