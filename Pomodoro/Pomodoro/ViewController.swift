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
    var currentSeconds = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureToggleButton()
    }
    
    func setTimerInfoViewVisible(isHidden: Bool) {
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
                
                if self?.currentSeconds ?? 0 <= 0 {
                    self?.stopTimer()
                }
            })
            self.timer?.resume()//타이머를 시작하려면 resume메서드를 호출해야함
        }
    }
    
    func stopTimer() {
        if self.timerStatus == .pause {
            self.timer?.resume()
        }
        self.timerStatus = .end
        self.cancleButton.isEnabled = false
        self.setTimerInfoViewVisible(isHidden: true)
        self.datePicker.isHidden = false
        self.toggleButton.isSelected = false
        self.timer?.cancel()
        self.timer = nil//타이머를 종료할때 항상 nil을 할당해주어야함, 안그러면 화면을 벗어나도 타이머가 계속 돌아갈수있음
    }
    
    @IBAction func tapCancleButton(_ sender: Any) {
        self.stopTimer()
    }
    
    @IBAction func tapToggleButton(_ sender: Any) {
        self.duration = Int(self.datePicker.countDownDuration)//datePicker에서 선택한 시간이 몇초인지 알려줌
        
        switch self.timerStatus {
        case .end:
            self.currentSeconds = self.duration
            self.timerStatus = .start
            self.setTimerInfoViewVisible(isHidden: false)
            self.datePicker.isHidden = true
            self.toggleButton.isSelected = true
            self.cancleButton.isEnabled = true
            self.startTimer()
            
        case .start:
            self.timerStatus = .pause
            self.toggleButton.isSelected = false
            self.timer?.suspend()
            
        case .pause:
            self.timerStatus = .start
            self.toggleButton.isSelected = true
            self.timer?.resume()
        }
    }
}

