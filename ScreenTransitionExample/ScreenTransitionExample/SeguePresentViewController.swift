//
//  SeguePresentViewController.swift
//  ScreenTransitionExample
//
//  Created by 강지원 on 2022/05/23.
//

import UIKit

class SeguePresentViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func TapBackButton(_ sender: UIButton) {
        self.presentingViewController?.dismiss(animated: true)
    }
}
