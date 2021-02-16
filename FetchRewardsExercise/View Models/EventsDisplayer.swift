//
//  EventDisplayer.swift
//  FetchRewards
//
//  Created by Sajan Shrestha on 2/15/21.
//

import UIKit

class EventsDisplayer {

    var displayedEvents = [Event]() {
        didSet {
            isLoadingEvents = false
            delegate?.didSetEvents()
        }
    }
    
    var isLoadingEvents = true
    
    var delegate: EventsDisplayerDelegate?
    
    init() {
        eventsClient = EventsClient()
        eventsClient.fetchEvents { events in
            self.displayedEvents = events
        }
    }
    
    private var eventsClient: EventsClient!
        
    func displayEvents(for searchText: String) {
        isLoadingEvents = true
        eventsClient.fetchEvents(for: searchText) { events in
            self.displayedEvents = events
        }
    }
    
    // MARK: - Caching
    func cachedEventImage(for string: String) -> UIImage? {
        cachedEventImages[string]
    }
    
    func cacheEventImage(_ image: UIImage, key: String) {
        cachedEventImages[key] = image
    }
    
    // This dictionary is used to cache fetched event images. The goal is to check this dictionary first before making a network call.
    private var cachedEventImages = [String: UIImage]()
}


protocol EventsDisplayerDelegate {
    func didSetEvents()
}
