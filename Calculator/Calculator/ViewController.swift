//
//  ViewController.swift
//  Calculator
//
//  Created by Matthew Crawford on 4/3/16.
//  Copyright © 2016 Matthew Crawford. All rights reserved.
//

import UIKit
import Darwin

class ViewController: UIViewController {
    
    @IBOutlet weak var display: UILabel!
    
    var userIsInTheMiddleOfTypingANumber = false
    var userIsInTheMiddleOfTypingADecimal = false

    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if digit == "." {
            if userIsInTheMiddleOfTypingADecimal {
                return
            }
            else {
                userIsInTheMiddleOfTypingADecimal = true
            }
        }
        if userIsInTheMiddleOfTypingANumber {
            display.text = display.text! + digit
        }
        else {
            display.text = digit
            userIsInTheMiddleOfTypingANumber = true
        }
    }
    
    @IBAction func operate(sender: UIButton) {
        let operation = sender.currentTitle!
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        switch operation {
        case "×": performOperation { $0 * $1 }
        case "÷": performOperation { $1 / $0 }
        case "+": performOperation { $0 + $1 }
        case "−": performOperation { $1 - $0 }
        case "√": performOperation { sqrt($0)}
        case "sin": performOperation { sin($0) }
        case "cos": performOperation { cos($0) }
        default: break
        }
    }
    
    func performOperation(operation: (Double, Double) -> Double) {
        if operandStack.count >= 2 {
            displayValue = operation(operandStack.removeLast(), operandStack.removeLast())
            enter()
        }
    }
    
    @nonobjc
    func performOperation(operation: Double -> Double) {
        if operandStack.count >= 1 {
            displayValue = operation(operandStack.removeLast())
            enter()
        }
    }
    
    var operandStack = Array<Double>()
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        userIsInTheMiddleOfTypingADecimal = false
        operandStack.append(displayValue)
        print("operandStack = \(operandStack)")
    }
    
    @IBAction func clear() {
        display.text! = "0"
        operandStack.removeAll()
        userIsInTheMiddleOfTypingADecimal = false
        userIsInTheMiddleOfTypingANumber = false
    }
    
    
    var displayValue: Double {
        get {
            if display.text! == "∏" {
                return M_PI
            }
            print(display.text!)
            return Double(display.text!)!
        }
        set {
            display.text = "\(newValue)"
            userIsInTheMiddleOfTypingANumber = false
        }
    }
}

