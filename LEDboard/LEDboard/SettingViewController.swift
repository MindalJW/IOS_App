import UIKit

protocol LEDBoardSettingDelegate: AnyObject { // 델리게이트 패턴을 이용해 이전화면을 설정한 데이터들 전달
    func changedSetting(text: String?, textColor: UIColor, backgroundColor: UIColor)
    //전광판에 표시할 글자, 글자색, 배경색
}

class SettingViewController: UIViewController {
    @IBOutlet weak var orangeButton: UIButton! /* 버튼과 텍스트필드등 콘텐츠들 연결 */
    @IBOutlet weak var Bluebutton: UIButton!
    @IBOutlet weak var blackButton: UIButton!
    @IBOutlet weak var greenButton: UIButton!
    @IBOutlet weak var purpleButton: UIButton!
    @IBOutlet weak var yellowButton: UIButton!
    @IBOutlet weak var textField: UITextField!
    
    weak var delegate: LEDBoardSettingDelegate?
    var textColor: UIColor = .yellow         // 델리게이트의 메서드를 통해
    var backgroundColor: UIColor = .black    // 데이터를 전달하기 위하여 프러퍼티 생성
    var ledText: String?                    /* 전광판의 데이터를 설정화면으로 다시가져오기 위한 프로퍼티*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView() // ViewDidLoad()가 호출될 때 전광판의 데이터들로 설정값이 저장되야함
    }
    
    private func configureView() { // 전광판의 설정한 데이터들이 다시 설정화면으로 돌아왔을때 설정되어있게하기위한 함수
        if let ledText = self.ledText { // 전광판의 텍스트 옵셔널 바인딩
            self.textField.text = ledText // 그리고 설정화면의 텍스트필드에 저장
        }
        self.changeTextColor(color: self.textColor) /*changeTextColor()메서드를
                                                        이용해 전광판뷰에서 전달받은 textColor로 변경*/
        self.changeBackgroundColorButton(color: self.backgroundColor) /*changeBackgroundColor()메서드를
                                                                       이용해 전광판뷰에서 전달받은
                                                                       BackgroundColor로 변경*/
    }
    
    @IBAction func tapTextColorButton(_ sender: UIButton) { // 이 액션함수에는 버튼3개가 연결되어있음
        if sender == self.yellowButton {
            self.changeTextColor(color: .yellow)
            self.textColor = .yellow//전달을 위한 프로퍼티에 데이터 저장
        } else if sender == self.purpleButton {
            self.changeTextColor(color: .purple)
            self.textColor = .purple//전달을 위한 프로퍼티에 데이터 저장
        } else {
            self.changeTextColor(color: .green)
            self.textColor = .green//전달을 위한 프로퍼티에 데이터 저장
        }
    }
    
    @IBAction func tapBackgroundColorButton(_ sender: UIButton) { // 이 액션함수에도 버튼3개가 연결되어있음
        if sender == self.blackButton {
            self.changeBackgroundColorButton(color: .black)
            self.backgroundColor = .black//전달을 위한 프로퍼티에 데이터 저장
        } else if sender == self.Bluebutton {
            self.changeBackgroundColorButton(color: .blue)
            self.backgroundColor = .blue//전달을 위한 프로퍼티에 데이터 저장
        } else {
            self.changeBackgroundColorButton(color: .orange)
            self.backgroundColor = .orange//전달을 위한 프로퍼티에 데이터 저장
        }
    }
    @IBAction func tapSaveButton(_ sender: Any) { // 저장버튼을 누르면 이전화면으로 넘어가고 설정한대로 전광판뷰가 나타남
        self.delegate?.changedSetting(
            text: self.textField.text,
            textColor: self.textColor,
            backgroundColor: backgroundColor) // 델리게이트를 사용해서 데이터들을 전달
        self.navigationController?.popViewController(animated: true) //popViewController로 이전화면으로 넘어감
    }
    
    private func changeTextColor(color: UIColor) { // 설정한 버튼은 선명해지고 아닌것들은 흐려지는 함수
        self.yellowButton.alpha = color == UIColor.yellow ? 1 : 0.2 //3항연산
        self.purpleButton.alpha = color == UIColor.purple ? 1 : 0.2 //3항연산
        self.greenButton.alpha = color == UIColor.green ? 1 : 0.2 //3항연산
    }
    
    private func changeBackgroundColorButton(color: UIColor) { // 설정한 버튼은 선명해지고 아닌것들은 흐려지는 함수
        self.blackButton.alpha = color == UIColor.black ? 1 : 0.2 //3항연산
        self.Bluebutton.alpha = color == UIColor.blue ? 1 : 0.2 //3항연산
        self.orangeButton.alpha = color == UIColor.orange ? 1 : 0.2 //3항연산
    }
}
