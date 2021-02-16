//
//  ViewController.swift
//  FetchRewards
//
//  Created by Sajan Shrestha on 2/15/21.
//

import UIKit

class EventsViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var eventsTable: UITableView!
    
    var eventsDisplayer = EventsDisplayer()
    var searchController : UISearchController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTable()
        configureSearchController()
        
        self.navigationItem.titleView = searchController.searchBar

        eventsDisplayer.delegate = self
    }

    private func configureTable() {
        
        eventsTable.delegate = self
        eventsTable.dataSource = self
        
        eventsTable.register(EventTableViewCell.self, forCellReuseIdentifier: EventTableViewCell.identifier)
        
        eventsTable.separatorStyle = .none
        
        eventsTable.rowHeight = UITableView.automaticDimension
        eventsTable.estimatedRowHeight = 200
    }
    
    private func configureSearchController() {
        self.searchController = UISearchController(searchResultsController:  nil)
        self.searchController.searchResultsUpdater = self
        self.searchController.delegate = self
        self.searchController.searchBar.delegate = self
        self.searchController.hidesNavigationBarDuringPresentation = false
    }
}


extension EventsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        eventsDisplayer.events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = eventsTable.dequeueReusableCell(withIdentifier: EventTableViewCell.identifier) as! EventTableViewCell
        
        let event = eventsDisplayer.events[indexPath.row]
        
        cell.titleLabel.text = event.title
        cell.locationLabel.text = event.venue.displayLocation
        cell.dateLabel.text = event.date
        cell.favoriteImageView.isHidden = event.isFavorite == false
                
        cell.eventImageView.image = UIImage(named: "smile")!
        setEventImage(for: event, in: cell)
        
        return cell
    }
    
    private func setEventImage(for event: Event, in cell: EventTableViewCell) {
        // checks if the image is already downloaded and cached
        guard let imageUrl = event.imageUrl else { return }
        
        if let image = eventsDisplayer.cachedEventImage(for: imageUrl) {
            cell.eventImageView.image = image
        }
        else {
            downloadEventImage(of: event, for: cell)
        }
    }
    
    // This function will download an event image and will ask 'eventsDispalyer' to put the image in a dictionary with the url as its key.
    private func downloadEventImage(of event: Event, for cell: EventTableViewCell) {
        
        guard let imageUrl = event.imageUrl, let url = URL(string: imageUrl) else { return }
        
        ImageDownloader.downloadImage(with: url) { image in
            DispatchQueue.main.async {
                cell.eventImageView.image = image
            }
            if let image = image {
                self.eventsDisplayer.cacheAvatarImage(image, key: imageUrl)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let event = eventsDisplayer.events[indexPath.row]
        let eventDetailViewController = EventDetailViewController(for: event) {
            self.eventsTable.reloadData()
        }
        navigationController?.pushViewController(eventDetailViewController, animated: true)
    }
}


extension EventsViewController: UISearchBarDelegate, UISearchResultsUpdating, UISearchControllerDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
}

extension EventsViewController: EventsDisplayerDelegate {
    func didSetEvents() {
        DispatchQueue.main.async {
            self.eventsTable.reloadData()
        }
    }
    
}
