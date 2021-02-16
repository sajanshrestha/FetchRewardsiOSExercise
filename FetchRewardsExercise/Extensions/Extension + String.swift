//
//  Extension + String.swift
//  FetchRewardsExercise
//
//  Created by Sajan Shrestha on 2/16/21.
//

import Foundation

extension String {
    func getFormattedString() -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss"
        if let date = dateFormatter.date(from: self) {
            let formatter = DateFormatter()
            formatter.dateStyle = .long
            formatter.timeStyle = .short
            let result = formatter.string(from: date)
            return result
        }
        return self
    }
}
