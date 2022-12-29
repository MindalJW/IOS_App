//
//  CodePushViewController.swift
//  ScreenTransitionExample
//
//  Created by 강지원 on 2022/05/23.
//

import UIKit

class CodePushViewController: UIViewController {
    @IBOutlet weak var nameLabel: UILabel!
    var name: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let name = name {
            self.nameLabel.text = name
            self.nameLabel.sizeToFit()
        }
    }

    @IBAction func TapBackButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
