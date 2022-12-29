//
//  RoundButton.swift
//  JiwonCaculator
//
//  Created by 강지원 on 2022/05/28.
//

import UIKit

@IBDesignable
class RoundButton: UIButton {
    @IBInspectable var isRound: Bool = false {
        didSet {
            if isRound {
                self.layer.cornerRadius = self.frame.height / 2
            }
        }
    }
}
