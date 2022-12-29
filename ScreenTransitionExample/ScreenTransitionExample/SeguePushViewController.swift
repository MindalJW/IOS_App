//
//  SeguePushViewController.swift
//  ScreenTransitionExample
//
//  Created by 강지원 on 2022/05/23.
//

import UIKit

class SeguePushViewController: UIViewController {
    @IBOutlet weak var nameLabel: UILabel!
    var name: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("SegueViewController 뷰가 로드 되었다.")
        if let name = name {
            self.nameLabel.text = name
            self.nameLabel.sizeToFit()
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("SegueViewController 뷰가 나타날 것이다.")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("SegueViewController 뷰가 나타났다.")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("SegueViewController 뷰가 사라질 것이다.")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("SegueViewController 뷰가 사라졌다.")
    }
    
    @IBAction func tapBackButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        
    }
}
