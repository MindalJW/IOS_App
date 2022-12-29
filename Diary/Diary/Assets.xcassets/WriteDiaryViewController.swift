//
//  WriteDiaryViewController.swift
//  Diary
//
//  Created by 강지원 on 2022/12/29.
//

import UIKit

class WriteDiaryViewController: UIViewController {
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var confirmButton: UIBarButtonItem!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var contentsTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureContentsTextView()
        self.configureDatePicker()
    }
    
    private let datePicker = UIDatePicker()
    private var diaryDate: Date?
    
    private func configureContentsTextView() {
        let borderColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1.0)
        self.contentsTextView.layer.borderColor = borderColor.cgColor
        self.contentsTextView.layer.borderWidth = 0.5
        self.contentsTextView.layer.cornerRadius = 5.0
    }
    
    private func configureDatePicker() {
        self.datePicker.datePickerMode = .date
        self.datePicker.preferredDatePickerStyle = .wheels
        self.datePicker.addTarget(self, action:#selector(datePickerValueDidChange(_:)), for: .valueChanged)
        //특정 이벤트가 발생할때마다 내가 작성한 메서드를 동작하도록 만들수있는 메서드
        self.dateTextField.inputView = self.datePicker//키보드 대신 datePicker가 나오게함
    }
    
    @IBAction func tapConfirmButton(_ sender: Any) {
    }
    
    @objc private func datePickerValueDidChange(_ datePicker: UIDatePicker) {
        let formmater = DateFormatter()//날짜를 포맷
        formmater.dateFormat = "yyyy년 MM월 dd일(EEEEE)"
        formmater.locale = Locale(identifier: "ko_KR")//한국어
        self.diaryDate = datePicker.date//변수에 저장
        self.dateTextField.text = formmater.string(from: datePicker.date)//string형태로 포맷된 날짜를 변경하여 textfield 입력
    }
}
