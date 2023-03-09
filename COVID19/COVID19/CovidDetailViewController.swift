//
//  CovidDetailViewController.swift
//  COVID19
//
//  Created by 강지원 on 2023/03/08.
//

import UIKit

class CovidDetailViewController: UITableViewController {
    
    
    @IBOutlet weak var regionalOutbreakCell: UITableViewCell!
    @IBOutlet weak var overseasInflowCell: UITableViewCell!
    @IBOutlet weak var percentageCell: UITableViewCell!
    @IBOutlet weak var deathCell: UITableViewCell!
    @IBOutlet weak var recoverdCell: UITableViewCell!
    @IBOutlet weak var totalCaseCell: UITableViewCell!
    @IBOutlet weak var newCaseCell: UITableViewCell!
    
    var covidOverview: CovidOverview?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    func configureView() {
        guard let covidOverview = self.covidOverview else { return }
        self.title = covidOverview.countryName
        self.newCaseCell.detailTextLabel?.text = "\(covidOverview.newCase)명"
        self.totalCaseCell.detailTextLabel?.text = "\(covidOverview.totalCase)명"
        self.recoverdCell.detailTextLabel?.text = "\(covidOverview.recovered)명"
        self.deathCell.detailTextLabel?.text = "\(covidOverview.death)명"
        self.percentageCell.detailTextLabel?.text = "\(covidOverview.percentage)명"
        self.overseasInflowCell.detailTextLabel?.text = "\(covidOverview.newCcase)명"
        self.regionalOutbreakCell.detailTextLabel?.text = "\(covidOverview.newFcase)"
        
    }
}
