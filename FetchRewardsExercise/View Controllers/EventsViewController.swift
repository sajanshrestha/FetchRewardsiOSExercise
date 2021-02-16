//
//  ViewController.swift
//  FetchRewards
//
//  Created by Sajan Shrestha on 2/15/21.
//

import UIKit
import SVProgressHUD

class EventsViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var eventsTable: UITableView!
    var searchController : UISearchController!
    
    // view model
    var eventsDisplayer = EventsDisplayer()
    
    // instance of timer to throttle the search
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialUISetup()
        
        eventsDisplayer.delegate = self
        
        updateUIwithLoadingStatus()
    }
}

// MARK: - Initial UI Set up
extension EventsViewController {
    
    private func initialUISetup() {
        configureTable()
        configureSearchController()
        configureNavigationBar()
    }
    
    private func configureSearchController() {
        self.searchController = UISearchController(searchResultsController: nil)
        self.searchController.configureTextField()
        self.searchController.searchBar.delegate = self
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.definesPresentationContext = true
    }
    
    private func configureNavigationBar() {
        self.navigationItem.titleView = searchController.searchBar
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.1705367863, green: 0.2440392971, blue: 0.3120354414, alpha: 1)
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }

    private func configureTable() {
        
        eventsTable.delegate = self
        eventsTable.dataSource = self
        
        eventsTable.register(EventTableViewCell.self, forCellReuseIdentifier: EventTableViewCell.identifier)
        
        eventsTable.separatorStyle = .none
        
        eventsTable.rowHeight = UITableView.automaticDimension
        eventsTable.estimatedRowHeight = 200
    }
    
    private func updateUIwithLoadingStatus() {
        if eventsDisplayer.isLoadingEvents {
            // show loading indicator
            SVProgressHUD.show()
            eventsTable.isHidden = true
        }
        else {
            // show the events
            SVProgressHUD.dismiss()
            eventsTable.isHidden = false
        }
    }
}

// MARK: - TableView delegate and datasource
extension EventsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        eventsDisplayer.displayedEvents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = eventsTable.dequeueReusableCell(withIdentifier: EventTableViewCell.identifier) as! EventTableViewCell
        
        let event = eventsDisplayer.displayedEvents[indexPath.row]
        
        cell.titleLabel.text = event.title
        cell.locationLabel.text = event.venue.displayLocation
        cell.dateLabel.text = event.date.getFormattedString()
        cell.favoriteImageView.isHidden = event.isFavorite == false
            
        // placeholder image
        cell.eventImageView.image = UIImage(named: "logo")!
        
        setEventImage(for: event, in: cell)
        
        return cell
    }
    
    private func setEventImage(for event: Event, in cell: EventTableViewCell) {
        guard let imageUrl = event.imageUrl else { return }
        
        // checks if the image is already downloaded and cached
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
                self.eventsDisplayer.cacheEventImage(image, key: imageUrl)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let event = eventsDisplayer.displayedEvents[indexPath.row]
        
        let eventDetailViewController = EventDetailViewController(for: event) {
            self.eventsTable.reloadData()
        }
        navigationController?.pushViewController(eventDetailViewController, animated: true)
    }
}


extension EventsViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let searchedText = searchBar.text {
            timer?.invalidate()
            timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { _ in
                self.eventsDisplayer.displayEvents(for: searchedText)
            })
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        eventsDisplayer.cancelSearch()
    }
}

extension EventsViewController: EventsDisplayerDelegate {
    func didSetEvents() {
        DispatchQueue.main.async {
            self.updateUIwithLoadingStatus()
            self.eventsTable.reloadData()
        }
    }
    
}
