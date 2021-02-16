//
//  EventsClient.swift
//  FetchRewards
//
//  Created by Sajan Shrestha on 2/15/21.
//

import Foundation

struct EventsClient {
  
    func fetchEvents(for query: String? = nil, completion: @escaping ([Event]) -> Void) {
        
        guard let urlComponents = urlComponents(for: query) else { return }
        
        guard let url = urlComponents.url else { return }
                
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
    
    private func urlComponents(for query: String?) -> URLComponents? {
        
        var urlComponents = URLComponents(string: SeatGeek.baseUrl)
        var queryItems = [URLQueryItem]()
        
        if let query = query {
            let searchQuery = URLQueryItem(name: SeatGeek.queryKey, value: query)
            queryItems.append(searchQuery)
        }
        
        let clientIdQuery = URLQueryItem(name: SeatGeek.clientId.key, value: SeatGeek.clientId.value)
        let secretIdQuery = URLQueryItem(name: SeatGeek.clientSecret.key, value: SeatGeek.clientSecret.value)
        queryItems.append(contentsOf: [clientIdQuery, secretIdQuery])
        
        urlComponents?.queryItems = queryItems
        return urlComponents
    }
}
