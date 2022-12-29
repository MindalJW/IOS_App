//
//  ViewController.swift
//  ScreenTransitionExample
//
//  Created by 강지원 on 2022/05/23.
//

import UIKit

class ViewController: UIViewController, SendDataDelegate {
    
    func sendData(name: String) {
        self.nameLabel.text = name
        self.nameLabel.sizeToFit()
    }
    
    @IBOutlet weak var nameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ViewController 뷰가 로드 되었다.")
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("ViewController 뷰가 나타날 것이다.")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("ViewController 뷰가 나타났다.")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("ViewController 뷰가 사라질 것이다.")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("ViewController 뷰가 사라졌다.")
    }
    @IBAction func TapCodePushButton(_ sender: Any) {
        guard let viewController = self.storyboard?.instantiateViewController(identifier: "CodePushViewController") as? CodePushViewController else { // 스토리보드의 뷰컨트롤러를 인스턴스화
            return
        }
        viewController.name = "JIWON"
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    @IBAction func TapCodePresentButton(_ sender: UIButton) {
        guard let viewController = self.storyboard?.instantiateViewController(identifier: "CodePresentViewController") as? CodePresentViewController else { return }
        viewController.modalPresentationStyle = .fullScreen
        viewController.name = "JIWON"
        viewController.delegate = self
        self.present(viewController, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController = segue.destination as? SeguePushViewController {
            viewController.name = "Gunter"
        }
    }
}

