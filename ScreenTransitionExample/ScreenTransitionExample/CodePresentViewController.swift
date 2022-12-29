//
//  CodePresentViewController.swift
//  ScreenTransitionExample
//
//  Created by 강지원 on 2022/05/23.
//

import UIKit

protocol SendDataDelegate: AnyObject {
    func sendData(name: String)
}

class CodePresentViewController: UIViewController {
    @IBOutlet weak var nameLabel: UILabel!
    var name: String?
    weak var delegate: SendDataDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let name = name {
            self.nameLabel.text = name
            self.nameLabel.sizeToFit()
        }
    }
    
    @IBAction func TapBackButton(_ sender : UIButton) {
        self.delegate?.sendData(name: "JIWON")
        self.presentingViewController?.dismiss(animated: true)
    }
}
   
