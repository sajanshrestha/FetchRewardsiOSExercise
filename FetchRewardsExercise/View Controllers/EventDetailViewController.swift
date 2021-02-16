//
//  EventDetailViewController.swift
//  FetchRewards
//
//  Created by Sajan Shrestha on 2/15/21.
//

import UIKit

class EventDetailViewController: UIViewController {
    
    var event: Event
    var favButtonClicked: () -> Void
    
    init(for event: Event, favButtonClicked: @escaping () -> Void) {
        self.event = event
        self.favButtonClicked = favButtonClicked
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        addSubviews()
    }
    
    // MARK: - Views
    var imageView: UIImageView = {
        var imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var favoriteButton: UIButton = {
        var button = UIButton()
        button.setImage(UIImage(named: "heart"), for: .normal)
        button.layer.opacity = event.isFavorite ? 1.0 : 0.5
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = event.isFavorite ? 0.6 : 0.0
        button.layer.shadowOffset = .zero
        button.layer.shadowRadius = 2
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var titleLabel: UILabel = {
        var label = UILabel()
        label.text = event.title
        label.titled()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var locationLabel: UILabel = {
        var label = UILabel()
        label.text = event.venue.displayLocation
        label.subTitled()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var dateLabel: UILabel = {
        var label = UILabel()
        label.text = event.date.getFormattedString()
        label.subTitled()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Constants
    private let buttonWidth: CGFloat = 26.0
    private let horizontalSpacing: CGFloat = 16.0
    private let verticalSpacing: CGFloat = 8.0
}

extension EventDetailViewController {
    
    private func addSubviews() {
        addImageView()
        addFavoriteButton()
        addFavoriteButtonTarget()
        addTitle()
        addLocationLabel()
        addDateLabel()
    }
    
    private func addImageView() {
        view.addSubview(imageView)
                
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
        addImage()
    }
    
    private func addImage() {
        if let url = URL(string: event.performers.first?.image ?? "") {
            ImageDownloader.downloadImage(with: url) { image in
                DispatchQueue.main.async {
                    self.imageView.image = image
                }
            }
        }
    }
    
    private func addFavoriteButton() {
        view.addSubview(favoriteButton)
                
        NSLayoutConstraint.activate([
            favoriteButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -horizontalSpacing),
            favoriteButton.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: verticalSpacing),
            favoriteButton.widthAnchor.constraint(equalToConstant: buttonWidth),
            favoriteButton.heightAnchor.constraint(equalToConstant: buttonWidth)
        ])
    }
    
    private func addFavoriteButtonTarget() {
        favoriteButton.addTarget(self, action: #selector(favoriteButtonClicked), for: .touchUpInside)
    }
    
    @objc func favoriteButtonClicked() {
        favButtonClicked()
        toggleOpacity()
        updateFavoriteEventsList()
    }
    
    private func toggleOpacity() {
        UIView.animate(withDuration: 0.3) {
            self.favoriteButton.layer.opacity = self.favoriteButton.isOn ? 0.5 : 1
            self.favoriteButton.layer.shadowOpacity = self.favoriteButton.isElevated ? 0.0 : 0.5
        }
    }
    
    private func updateFavoriteEventsList() {
        if favoriteButton.isOn {
            UserDefaults.addEventId(event.id)
        }
        else {
            UserDefaults.removeEventId(event.id)
        }
    }
    
    private func addTitle() {
        view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: horizontalSpacing),
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: verticalSpacing),
            titleLabel.trailingAnchor.constraint(equalTo: favoriteButton.leadingAnchor, constant: -horizontalSpacing)
        ])
    }
    
    private func addLocationLabel() {
        view.addSubview(locationLabel)
        
        NSLayoutConstraint.activate([
            locationLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: horizontalSpacing),
            locationLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: verticalSpacing),
            locationLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -horizontalSpacing)
        ])
    }
    
    private func addDateLabel() {
        view.addSubview(dateLabel)
        
        NSLayoutConstraint.activate([
            dateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: horizontalSpacing),
            dateLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 4),
            dateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -horizontalSpacing)
        ])
    }
}

