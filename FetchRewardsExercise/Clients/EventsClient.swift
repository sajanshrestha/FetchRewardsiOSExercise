//
//  EventsClient.swift
//  FetchRewards
//
//  Created by Sajan Shrestha on 2/15/21.
//

import Foundation

struct EventsClient {
  
    func fetchEvents(completion: @escaping ([Event]) -> Void) {
        
        var urlComponents = URLComponents(string: SeatGeek.baseUrl)
        
        let clientIdQuery = URLQueryItem(name: SeatGeek.clientId.key, value: SeatGeek.clientId.value)
        let secretIdQuery = URLQueryItem(name: SeatGeek.clientSecret.key, value: SeatGeek.clientSecret.value)
        urlComponents?.queryItems = [clientIdQuery, secretIdQuery]
        
        guard let url = urlComponents?.url else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            do {
                let eventsResponse = try JSONDecoder().decode(EventsResponse.self, from: data)
                let events = eventsResponse.events
                completion(events)
            }
            catch {
                print("error")
            }
            
        }.resume()
    }
}
