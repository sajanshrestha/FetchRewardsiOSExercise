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
    
    init(for event: Event, buttonClicked: @escaping () -> Void) {
        self.event = event
        self.favButtonClicked = buttonClicked
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        addSubviews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    // MARK: - Views
    var imageView: UIImageView = {
        var imageView = UIImageView()
        imageView.layer.cornerRadius = 20.0
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var backButton: UIButton = {
        var button = UIButton()
        button.setTitle("Back", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var favoriteButton: UIButton = {
        var button = UIButton()
        button.setImage(UIImage(named: "heart"), for: .normal)
        button.layer.opacity = event.isFavorite ? 1.0 : 0.5
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var titleLabel: UILabel = {
        var label = UILabel()
        label.text = event.title
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 18.0, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var locationLabel: UILabel = {
        var label = UILabel()
        label.text = event.venue.displayLocation
        label.font = UIFont.systemFont(ofSize: 14.0, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var dateLabel: UILabel = {
        var label = UILabel()
        label.text = event.date
        label.font = UIFont.systemFont(ofSize: 14.0, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Constants
    private let buttonWidth: CGFloat = 40.0
    private let horizontalSpacing: CGFloat = 16.0
    private let verticalSpacing: CGFloat = 8.0
}

extension EventDetailViewController {
    
    private func addSubviews() {
        addImageView()
        addBackButton()
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
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5)
        ])
        
        if let url = URL(string: event.performers.first?.image ?? "") {
            ImageDownloader.downloadImage(with: url) { image in
                DispatchQueue.main.async {
                    self.imageView.image = image
                }
            }

        }
    }
    
    private func addBackButton() {
        view.addSubview(backButton)
        
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: horizontalSpacing),
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: verticalSpacing)
        ])
        
        backButton.addTarget(self, action: #selector(handleBackButtonPress), for: .touchUpInside)
    }
    
    @objc func handleBackButtonPress() {
        navigationController?.popViewController(animated: true)
    }
    
    private func addFavoriteButton() {
        view.addSubview(favoriteButton)
                
        NSLayoutConstraint.activate([
            favoriteButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -horizontalSpacing),
            favoriteButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
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
            self.favoriteButton.layer.opacity = self.favoriteButton.layer.opacity == 0.5 ? 1 : 0.5
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
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -horizontalSpacing)
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
            dateLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: verticalSpacing),
            dateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -horizontalSpacing)
        ])
    }
}


extension UIButton {
    var isOn: Bool {
        self.layer.opacity == 1
    }
}
