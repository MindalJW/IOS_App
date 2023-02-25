//
//  WriteDiaryViewController.swift
//  Diary
//
//  Created by 강지원 on 2022/12/29.
//

import UIKit

enum DiaryEditorMode {//수정버튼을 통해 들어왔는지 등록버튼을 통해 들어왔는지 확인을 위한 열거형
    case new
    case edit(IndexPath, Diary)
}

protocol WriteDiaryViewDelegate: AnyObject {
    func didSelectReigster(diary: Diary)//등록버튼을 눌렀을때 실행되는 메서드
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
        self.configureEditMode()
        self.confirmButton.isEnabled = false//처음에 등록버튼 비활성화
    }
    
    private func configureEditMode() {//수정을 눌러 일기작성화면에 들어왔으면 원래의 내용을 처음 일기작성화면에 표시
        switch self.diaryEditorMode {//다이어리에디터모드변수의값이
            case let .edit(_, diary): //.edit일 경우
            self.titleTextField.text = diary.title // 제목 텍스트 필드에 다이어리의 제목을 설정
            self.contentsTextView.text = diary.contents // 내용 텍스트 뷰에 다이어리의 내용을 설정
            self.dateTextField.text = self.dateToString(date: diary.date) // 날짜 텍스트 필드에 다이어리의 날짜를 문자열로 변환한 것을 설정
            self.diaryDate = diary.date // 다이어리 날짜에 다이어리의 날짜를 설정
            self.confirmButton.title = "수정" // 확인 버튼의 제목을 "수정"으로 변경
            
        default:
            break
        }
    }
    
    private func dateToString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd(EEEEE)"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: date)
    }
    
    private let datePicker = UIDatePicker()//데이트피커 인스턴스화
    private var diaryDate: Date?//날짜를 저장할 변수
    weak var delegate: WriteDiaryViewDelegate?//델리게이트 선언, 없을수도있기때문에 옵셔널타입
    var diaryEditorMode: DiaryEditorMode = .new
    
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
        self.contentsTextView.delegate = self//UITextView에는 AddTarget메서드가 없기때문에 델리게이트패턴으로 구현
        //콘텐츠텍스트뷰 위임
        self.titleTextField.addTarget(self, action: #selector(titleTextFieldDidChange(_:)), for: .editingChanged)
        //제목텍스트필드의 값이 변경될때마다 셀렉터 메서드 동작
        self.dateTextField.addTarget(self, action: #selector(dateTextFieldDidChange(_:)), for: .editingChanged)
        //데이트텍스트필드의 값이 변경될때마다 셀렉터 메서드 동작
    }
    
    @IBAction func tapConfirmButton(_ sender: Any) {//등록버튼을 누르면 호출
        guard let title = self.titleTextField.text else { return } //제목 옵셔널 바인딩
        guard let contents = self.contentsTextView.text else { return }//내용 옵셔널 바인딩
        guard let date = self.diaryDate else { return }//날짜 옵셔널 바인딩
        
        switch self.diaryEditorMode {
        case .new:
            let diary = Diary(title: title, contents: contents, date: date, isStar: false)//다이어리 객체 생성
            self.delegate?.didSelectReigster(diary: diary)//위임자(ViewController)에게 전달
        case let .edit(indexPath, diary)://수정모드일때
            let diary = Diary(title: title, contents: contents, date: date, isStar: diary.isStar)//다이어리 객체 생성
            NotificationCenter.default.post(//노티피케이션센터 포스트 등록
                name: NSNotification.Name("editDiary"),//노티피케이션 이름 editDiary로 설정
                object: diary,//오브젝트로 다이어리객체를 넘겨줌
                userInfo: [//유저인포로 인덱스패치를 넘겨줌
                    "indexPath.row": indexPath.row
                ])
        }
        self.navigationController?.popViewController(animated: true)//등록버튼을 누르면 현재화면 팝
        
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

extension WriteDiaryViewController: UITextViewDelegate {//UITextView에는 AddTarget메서드가 없기때문에 델리게이트패턴으로 구현
    func textViewDidChange(_ textView: UITextView) {//위임받은 기능
        self.validateInputField()//텍스트뷰의 값이 변경될때마다 호출
    }
}
