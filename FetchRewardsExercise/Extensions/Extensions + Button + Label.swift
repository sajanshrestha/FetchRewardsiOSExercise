//
//  Extensions + UILabel.swift
//  FetchRewardsExercise
//
//  Created by Sajan Shrestha on 2/16/21.
//

import UIKit

extension UILabel {
    
    func titled() {
        self.numberOfLines = 0
        self.font = UIFont.systemFont(ofSize: 18.0, weight: .semibold)
    }
    
    func subTitled() {
        self.numberOfLines = 0
        self.font = UIFont.systemFont(ofSize: 14.0, weight: .semibold)
        self.textColor = UIColor.gray
    }
}

extension UIButton {
    var isOn: Bool {
        self.layer.opacity == 1
    }
    
    var isElevated: Bool {
        self.layer.shadowOpacity == 0.5
    }
}
