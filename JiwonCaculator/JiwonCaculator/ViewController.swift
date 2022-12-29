//
//  ViewController.swift
//  JiwonCaculator
//
//  Created by 강지원 on 2022/05/28.
//

import UIKit

enum Operator {
    case Divide
    case Multiply
    case Add
    case Substract
    case unknown
}

class ViewController: UIViewController {
    @IBOutlet weak var numberOutputLabel: UILabel!
    var displayNumber = ""
    var currentOperator: Operator = .unknown
    var firstOperand = ""
    var secondOperand = ""
    var result = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }


    @IBAction func tapNumberPad(_ sender: UIButton) {
        guard let number = sender.titleLabel?.text else { return }
        if displayNumber.count < 9 {
            displayNumber += number
            self.numberOutputLabel.text = displayNumber
        }
    }
    
    
    @IBAction func tapDotButton(_ sender: UIButton) {
        if self.displayNumber.count < 8, !self.displayNumber.contains(".") {
            self.displayNumber += self.displayNumber.isEmpty ? "0." : "."
            self.numberOutputLabel.text = self.displayNumber
        }
    }
    
    @IBAction func tapClearButton(_ sender: UIButton) {
        self.displayNumber = ""
        self.currentOperator = .unknown
        self.firstOperand = ""
        self.secondOperand = ""
        self.result = ""
        self.numberOutputLabel.text = "0"
    }
    
    @IBAction func tapOperatorButton(_ sender: UIButton) {
        if let title = sender.titleLabel?.text {
            if title == "÷" {
                operation(.Divide)
            }
        }
        if sender.titleLabel?.text! == "+" {
            operation(.Add)
        }
        if sender.titleLabel!.text! == "―" {
            operation(.Substract)
        }
        if sender.currentTitle == "×" {
            operation(.Multiply)
        }
        
        if sender.titleLabel!.text == "=" {
            operation(self.currentOperator)
        }
    }
    
    func operation(_ operator: Operator) {
        if self.currentOperator != .unknown{
            if !self.displayNumber.isEmpty {
                self.secondOperand = displayNumber
                displayNumber = ""
                
                guard let firstOperand = Double(firstOperand) else { return }
                guard let secondOperand = Double(secondOperand) else { return }
                
                switch currentOperator {
                case .Divide:
                    self.result = "\(firstOperand / secondOperand)"
                case .Multiply:
                    self.result = "\(firstOperand * secondOperand)"
                case .Add:
                    self.result = "\(firstOperand + secondOperand)"
                case .Substract:
                    self.result = "\(firstOperand - secondOperand)"
                default:
                    break
                }
                self.firstOperand = self.result
                self.numberOutputLabel.text = self.result
            }
            self.currentOperator = `operator`
            
        } else {
            self.firstOperand = self.displayNumber
            self.currentOperator = `operator`
            self.displayNumber = ""
        }
    }
}

