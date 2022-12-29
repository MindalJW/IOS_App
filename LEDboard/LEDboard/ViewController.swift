import UIKit

class ViewController: UIViewController, LEDBoardSettingDelegate  { //델리게이트 패턴을 위한 프로토콜 채택
    
    @IBOutlet weak var contantLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.contantLabel.textColor = .yellow // 초기값 설정
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) { /* segue를 이용한 화면전환에서 데이터를
                                                                         전달하기위한 제일좋은 위치는 전처리 prepare()메서드
                                                                         세그웨이를 실행하기 직전에 시스템에서 자동으로 호출*/
        if let settingViewController = segue.destination as? SettingViewController { // 전환되려는 화면을 인스턴스화 후 다운캐스팅 여기서 다운캐스팅을 하는 이유는 다운캐스팅을 하지않으면 UIViewController타입의 인스턴스가 생성됨
            settingViewController.delegate = self // 전환되기전 위임자를 ViewController로 저장
            settingViewController.ledText = self.contantLabel.text // 전환되기전 전광판의 텍스트를 letText프로퍼티에 전달
            settingViewController.textColor = self.contantLabel.textColor // 전환되기전 전광판의 텍스트색을 TextColor프로퍼티에 전달
            settingViewController.backgroundColor = self.view.backgroundColor ?? .black /* 전환되기전 전광판의 배경색을 BackgroundColor프로퍼티에전달 */
        }
    }
    
    func changedSetting(text: String?, textColor: UIColor, backgroundColor: UIColor) { // 위임자를 자기로 정했으니 데이터를 전달받음
        if let text = text {
            self.contantLabel.text = text
        }
        self.contantLabel.textColor = textColor
        self.view.backgroundColor = backgroundColor
    }
}

