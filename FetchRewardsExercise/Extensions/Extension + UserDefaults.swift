//
//  Extension + UserDefaults.swift
//  FetchRewardsExercise
//
//  Created by Sajan Shrestha on 2/15/21.
//

import Foundation

extension UserDefaults {
    
    static let FAVORITE_EVENT_ID = "favorite_events"
    
    static var eventIds: [Int] {
        guard let eventIds = UserDefaults.standard.array(forKey: FAVORITE_EVENT_ID) as? [Int] else { return [] }
        return eventIds
    }
    
    static func addEventId(_ id: Int) {
        var eventIds = UserDefaults.eventIds
        eventIds.append(id)
        UserDefaults.standard.setValue(eventIds, forKey: FAVORITE_EVENT_ID)
    }
    
    static func removeEventId(_ id: Int) {
        var eventIds = UserDefaults.eventIds
        eventIds.removeAll { $0 == id }
        UserDefaults.standard.setValue(eventIds, forKey: FAVORITE_EVENT_ID)
    }

}
