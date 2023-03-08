//
//  CovidDetailViewController.swift
//  COVID19
//
//  Created by 강지원 on 2023/03/08.
//

import UIKit

class CovidDetailViewController: UITableViewController {
    
    @IBOutlet weak var regionalOutbreakCell: UILabel!
    @IBOutlet weak var overseasInflowCell: UITableViewCell!
    @IBOutlet weak var percentageCell: UITableViewCell!
    @IBOutlet weak var deathCell: UITableViewCell!
    @IBOutlet weak var recoverdCell: UITableViewCell!
    @IBOutlet weak var totalCaseCell: UITableViewCell!
    @IBOutlet weak var newCaseCell: UITableViewCell!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
