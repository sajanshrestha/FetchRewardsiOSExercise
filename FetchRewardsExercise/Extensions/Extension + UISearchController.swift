//
//  Extension + UISearchController.swift
//  FetchRewardsExercise
//
//  Created by Sajan Shrestha on 2/16/21.
//

import UIKit

extension UISearchController {
    func configureTextField() {
        if let searchTextField = self.searchBar.value(forKey: "searchField") as? UITextField {
            searchTextField.textColor = .white
            searchTextField.layer.borderColor = UIColor.white.cgColor
            searchTextField.layer.cornerRadius = 8.0
            searchTextField.layer.borderWidth = 0.2
        }
    }
}
