//
//  Event.swift
//  FetchRewards
//
//  Created by Sajan Shrestha on 2/15/21.
//

import Foundation

struct EventsResponse: Codable {
    var events: [Event]
}

struct Event: Codable {
    var id: Int
    var title: String
    var venue: Venue
    var date: String
    var performers: [Performer]
    var imageUrl: String? {
        performers.first?.image
    }
    var isFavorite: Bool {
        UserDefaults.eventIds.contains(id)
    }
    
    enum CodingKeys: String, CodingKey{
        case id
        case title
        case venue
        case date = "datetime_utc"
        case performers
    }
}


struct Venue: Codable {
    var displayLocation: String
    
    enum CodingKeys: String, CodingKey {
        case displayLocation = "display_location"
    }
}

struct Performer: Codable {
    var image: String
}
