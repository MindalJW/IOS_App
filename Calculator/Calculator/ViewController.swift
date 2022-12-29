//
//  ViewController.swift
//  Calculator
//
//  Created by 강지원 on 2022/05/26.
//

import UIKit

enum Operation { // 열거형으로 연산자들 정의
    case Add
    case Subtract
    case Divide
    case Multiply
    case Equal
    case unknown
}

class ViewController: UIViewController {
    @IBOutlet weak var numberOutputLabel: UILabel! // 계산기의 결과값이 표시되는 라벨
    
    var displayNumber = "" // 화면에 표시되는 숫자
    var firstOperand = "" // 첫 피연산자
    var secondOperand = "" // 두번째 피연산자
    var result = "" // 결과값
    var currentOperation: Operation = .unknown // 처음 아무 연산자도 입력되어있지 않은 상태
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    @IBAction func tapNumberButton(_ sender: UIButton) { // 숫자버튼을 누르면 라벨에 표시
        guard let numberValue = sender.titleLabel?.text else { return } /* 버튼의 타이틀이 곧 표시할 값이기때문에
                                                                         타이틀을 라벨에 넘긴다 */
        if self.displayNumber.count < 9 { // 9자리까지 표시
            self.displayNumber += numberValue // 화면에 표시할 displayNumber프로퍼티에 버튼의 타이틀 추가
            self.numberOutputLabel.text = displayNumber // 라벨에 표시
        }
    }
    
    @IBAction func tapClearButton(_ sender: UIButton) { //AC버튼을 누르면 모두 초기화
        self.displayNumber = ""
        self.firstOperand = ""
        self.secondOperand = ""
        self.result = ""
        self.currentOperation = .unknown
        self.numberOutputLabel.text = "0"
        
    }
    
    @IBAction func tapDotButton(_ sender: UIButton) { //소수점 버튼
        if self.displayNumber.count < 8, !self.displayNumber.contains(".") {
            self.displayNumber += self.displayNumber.isEmpty ? "0." : "."
            self.numberOutputLabel.text = self.displayNumber
        }
    }
    
    @IBAction func dapDivideButton(_ sender: UIButton) {
        self.operation(.Divide)
    }
    
    @IBAction func tapMultiplyButton(_ sender: Any) {
        self.operation(.Multiply)
    }
    
    @IBAction func tapSubstractButton(_ sender: UIButton) {
        self.operation(.Subtract)
    }
    
    @IBAction func tapAddButton(_ sender: UIButton) {
        self.operation(.Add)
    }
    
    @IBAction func tapEqualButton(_ sender: UIButton) {
        self.operation(.Equal)
    }
    
    func operation(_ operation: Operation) { // 연산자 열거형을 파라미터로 받는 연산하기위한 함수
        
        if self.currentOperation != .unknown { /* 연산자가 unknown이 아니라면 즉, 연산자가 이미 한번 이상
                                                클릭되어 currentOperation에 저장되어있다면*/
            if !self.displayNumber.isEmpty { // displayNumber에 값이 저장되어 있다면
                self.secondOperand = self.displayNumber // 두번째 피연산자로 저장
                self.displayNumber = "" // 그리고 displayNumber값 초기화
                
                guard let firstOperand = Double(self.firstOperand) else { return } /* 각각 String타입이기 때문에                                                                           Double로 변환 */
                guard let secondOperand = Double(self.secondOperand) else { return }
                
                switch self.currentOperation { //전에 클릭된 연산자
                case .Add: // 더하기
                    self.result = "\(firstOperand + secondOperand)" // 연산값을 result프로퍼티에 저장
                    self.firstOperand = self.result /* 누적연산을 위해 결과값을 첫번째 피연산자
                                                        firstOperand로 다시 저장*/
                case .Subtract: // 빼기
                    self.result = "\(firstOperand - secondOperand)"
                    self.firstOperand = self.result
                    
                case .Multiply: // 곱하기
                    self.result = "\(firstOperand * secondOperand)"
                    self.firstOperand = self.result
                    
                case .Divide: // 나누기
                    self.result = "\(firstOperand / secondOperand)"
                    self.firstOperand = self.result
                    
                case .Equal: /* =이 눌렸었다면 =은 일단 연산을하는 연산자가 아니기때문에
                              연산을 하려고한 값 즉, secondOperand와 연산을
                              할수 없기때문에 secondOperand를 다시 firstOperand로
                              저장해서 새로운 연산을 할수있게함*/
                    self.firstOperand = self.secondOperand
                    self.result = self.firstOperand
                default:
                    break
                }
                
                if let result = Double(self.result), result.truncatingRemainder(dividingBy: 1) == 0 {
                    self.result = "\(Int(result))" // 정수형이 아닐때 나머지 연산은 truncatingRemainder활용
                }
                self.numberOutputLabel.text = self.result // 결과값을 라벨에 표시
            }
            self.currentOperation = operation // 지금 눌린 연산자를 currentOperation에 저장
        
        } else { // currentOperation이 unknown인 상태, 즉 이전에 연산자가 입력되지않은 처음 연산을 시작하려는 상태
            self.firstOperand = self.displayNumber // 버튼을 눌러 만든값을 첫번째 피연산자로 저장
            self.currentOperation = operation // 지금 눌린 연산자를 currentOperation에 저장
            self.displayNumber = "" //다음값을 받으면서 화면에 표시하기위해 displayNumber 초기화
        }
    }
}

