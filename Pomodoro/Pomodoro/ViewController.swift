//
//  ViewController.swift
//  Pomodoro
//
//  Created by 강지원 on 2023/02/26.
//

import UIKit

enum TimerStatus {
    case start
    case pause
    case end
}

class ViewController: UIViewController {
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var toggleButton: UIButton!
    @IBOutlet weak var cancleButton: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var timerLabel: UILabel!
    
    var timerStatus: TimerStatus = .end
    var duration = 60
    var timer: DispatchSourceTimer?//DispatchSource의 이벤트중 하나로 지정된 간격 후에 코드를 실행할수있는 이벤트
    var currentSeconds = 0 //계속 변경되는 시간의 값을 받을 변수
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureToggleButton()
    }
    
    func setTimerInfoViewVisible(isHidden: Bool) {//타이머가 시작되면 보여야할것들
        self.timerLabel.isHidden = isHidden
        self.progressView.isHidden = isHidden
    }
    
    func configureToggleButton() {
        self.toggleButton.setTitle("시작", for: .normal)
        self.toggleButton.setTitle("일시정지", for: .selected)
    }
    
    func startTimer() {
        if self.timer == nil {
            self.timer = DispatchSource.makeTimerSource(flags: [], queue: .main)//타이머 인스턴스
            self.timer?.schedule(deadline: .now(), repeating: 1)/*타이머이벤트가 발생해야하는 시기를 .now로 설정 이후
                                                                 1초마다 반복하게 설정*/
            self.timer?.setEventHandler(handler: { [weak self] in /*타이머 이벤트가 실행될때 실행될 코드를 클러저에 지정
                                                                   클로저에서 self를 캡처할때 강한순환참조가
                                                                   발생할수있기떄문에 weakself를 사용하여 메모리 누수 방지*/
                self?.currentSeconds -= 1
                debugPrint(self?.currentSeconds)
                
                if self?.currentSeconds ?? 0 <= 0 { /*self?.currentSeconds가 nil일 경우 nil과 0을 비교하는 연산을
                                                     피하기 위해 nil 병합연산자 ?? 을 사용하여 nil일 경우 0을 할당하고
                                                     currentSeconds가 0보다 작으면 타이머가 종료된것이기 떄문에 stopTimer호출*/
                    self?.stopTimer()
                }
            })
            self.timer?.resume()//타이머를 시작하려면 resume메서드를 호출해야함
        }
    }
    
    func stopTimer() {
        if self.timerStatus == .pause {
            self.timer?.resume()/*timer가 suspend상태일때 타이머에 nil을 할당하게되면
                                 런타임에러가 발생하기때문에 먼저 resume메서드를
                                 호출해준뒤에 nil을 할당해야한다*/
        }
        self.timerStatus = .end
        self.cancleButton.isEnabled = false
        self.setTimerInfoViewVisible(isHidden: true)
        self.datePicker.isHidden = false
        self.toggleButton.isSelected = false
        self.timer?.cancel()
        self.timer = nil//타이머를 종료할때 항상 nil을 할당해주어야함, 안그러면 화면을 벗어나도 타이머가 계속 돌아갈수있음
    }
    
    @IBAction func tapCancleButton(_ sender: Any) {//종료버튼을 누르면 호출되는 함수
        self.stopTimer()
    }
    
    @IBAction func tapToggleButton(_ sender: Any) {
        self.duration = Int(self.datePicker.countDownDuration)//datePicker에서 선택한 시간이 몇초인지 알려줌
        
        switch self.timerStatus {//switch문을 통해 현재 타이머의 상태에따라 시작or일시정지 버튼을 눌렀을때 다른 코드가 실행되게함
        case .end:
            self.currentSeconds = self.duration//currentSeconds변수를 datePicker에서 설정한 시간으로 초기화
            self.timerStatus = .start//타이머 상태를 .start로 변경
            self.setTimerInfoViewVisible(isHidden: false)//timerLabel과 progressView의 isHidden상태를 false로 변경
            self.datePicker.isHidden = true//datePicker를 안보이게 설정
            self.toggleButton.isSelected = true //toggleButton(시작)의 isSelected를 true로 설정
            self.cancleButton.isEnabled = true //종료버튼 활성화
            self.startTimer()//DispatchSource의 timer이벤트를 시작
            
        case .start:
            self.timerStatus = .pause//타이머상태를 .pause로 변경
            self.toggleButton.isSelected = false/*toggleButton(시작)의 isSelected를 false로 설정
                                                 ->LabelTitle을 일시정지로 변경*/
            self.timer?.suspend()//DispatchSource의 timer이벤트를 suspend(일시정지)
            
        case .pause:
            self.timerStatus = .start//타이머 상태를 다시 .start로 변경
            self.toggleButton.isSelected = true//toggleButton(시작)의 isSelected를 true로 설정
            self.timer?.resume()//DispatchSource의 timer이벤트를 suspend(일시정지)
        }
    }
}

