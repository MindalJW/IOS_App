//
//  WriteDiaryViewController.swift
//  Diary
//
//  Created by 강지원 on 2022/12/29.
//

import UIKit

protocol WriteDiaryViewDelegate: AnyObject {
    func didSelectReigster(diary: Diary)
}//위임자가 대신해야할 함수(프로토콜)를 채택

class WriteDiaryViewController: UIViewController {
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var confirmButton: UIBarButtonItem!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var contentsTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureContentsTextView()
        self.configureDatePicker()
        self.configureInputField()
        self.confirmButton.isEnabled = false//처음에 등록버튼 비활성화
    }
    
    private let datePicker = UIDatePicker()
    private var diaryDate: Date?
    weak var delegate: WriteDiaryViewDelegate?//델리게이트 선언, 없을수도있기때문에 옵셔널타입
    
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
        //#selector( ) 메서드는 파라미터에 Function Notation 방식으로 함수를 전달합니다
        self.dateTextField.inputView = self.datePicker//키보드 대신 datePicker가 나오게함
    }
    
    private func configureInputField() {
        self.contentsTextView.delegate = self
        //콘텐츠텍스트뷰 위임
        self.titleTextField.addTarget(self, action: #selector(titleTextFieldDidChange(_:)), for: .editingChanged)
        //제목텍스트필드의 값이 변경될때마다 셀렉터 메서드 동작
        self.dateTextField.addTarget(self, action: #selector(dateTextFieldDidChange(_:)), for: .editingChanged)
        //데이트텍스트필드의 값이 변경될때마다 셀렉터 메서드 동작
    }
    
    @IBAction func tapConfirmButton(_ sender: Any) {//등록버튼을 누르면 호출
        guard let title = self.titleTextField.text else { return }
        guard let contents = self.contentsTextView.text else { return }
        guard let date = self.diaryDate else { return }
        
        let diary = Diary(title: title, contents: contents, date: date, isStar: false)
        self.delegate?.didSelectReigster(diary: diary)
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @objc private func datePickerValueDidChange(_ datePicker: UIDatePicker) {//데이트피커의 값이 변경될때마다 호출
        let formmater = DateFormatter()//날짜를 포맷
        formmater.dateFormat = "yyyy년 MM월 dd일(EEEEE)"
        formmater.locale = Locale(identifier: "ko_KR")//한국어
        self.diaryDate = datePicker.date//변수에 저장
        self.dateTextField.text = formmater.string(from: datePicker.date)
        //string형태로 포맷된 날짜를 변경하여 textfield 입력
        self.dateTextField.sendActions(for: .editingChanged)//날짜가 변경될때마다 .editingChanged액션을 보냄
    }
    
    @objc private func titleTextFieldDidChange(_ textField: UITextField) {
        self.validateInputField()
    }
    
    @objc private func dateTextFieldDidChange(_ textField: UITextField) {
        self.validateInputField()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }//빈화면을 터치하면 키패드 또는 데이트피커가 사라지게만듬
    
    private func validateInputField() {//모든 텍스트가 채워져야 등록버튼 활성화
        self.confirmButton.isEnabled = !(self.titleTextField.text?.isEmpty ?? true) &&
        !(self.dateTextField.text?.isEmpty ?? true) && !(self.contentsTextView.text?.isEmpty ?? true)
        //nill 병합 연산자 A ?? B A가 nil이면 B를 반환 아니면 A를 반환
    }
}

extension WriteDiaryViewController:UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {//위임받은 기능
        self.validateInputField()//텍스트뷰의 값이 변경될때마다 호출
    }
}
