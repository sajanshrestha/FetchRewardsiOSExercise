//
//  EventDisplayer.swift
//  FetchRewards
//
//  Created by Sajan Shrestha on 2/15/21.
//

import UIKit

class EventsDisplayer {

    var events = [Event]() {
        didSet {
            delegate?.didSetEvents()
        }
    }
    
    var delegate: EventsDisplayerDelegate?
    
    init() {
        eventsClient = EventsClient()
        eventsClient.fetchEvents { events in
            self.events = events
        }
    }
    
    private var eventsClient: EventsClient!
    
    func cachedEventImage(for string: String) -> UIImage? {
        cachedEventImages[string]
    }
    
    func cacheAvatarImage(_ image: UIImage, key: String) {
        cachedEventImages[key] = image
    }
    
    // This dictionary is used to cache fetched event images. The goal is to check this dictionary first before making a network call.
    private var cachedEventImages = [String: UIImage]()
}


protocol EventsDisplayerDelegate {
    func didSetEvents()
}
