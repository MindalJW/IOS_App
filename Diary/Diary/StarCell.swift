//
//  StarCell.swift
//  Diary
//
//  Created by 강지원 on 2022/12/29.
//

import UIKit

class StarCell: UICollectionViewCell {
    
    @IBOutlet weak var DateLabel: UILabel!
    @IBOutlet weak var TitleLabel: UILabel!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.contentView.layer.cornerRadius = 3.0
        self.contentView.layer.borderWidth = 1.0
        self.contentView.layer.borderColor = UIColor.black.cgColor
    }
}
