//
//  EventTableViewCell.swift
//  FetchRewards
//
//  Created by Sajan Shrestha on 2/15/21.
//

import UIKit

class EventTableViewCell: UITableViewCell {
    
    static let identifier = "EventTableViewCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        addSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Views
    lazy var eventImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.layer.cornerRadius = 10.0
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var favoriteImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.image = UIImage(named: "heart")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        var label = UILabel()
        label.titled()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var locationLabel: UILabel = {
        var label = UILabel()
        label.subTitled()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var dateLabel: UILabel = {
        var label = UILabel()
        label.subTitled()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    // MARK: - Constants
    private let imageViewWidth: CGFloat = 80.0
    private let messageTextInset: CGFloat = 8.0
    
}

extension EventTableViewCell {
    
    private func addSubviews() {
        addEventImageView()
        addFavoriteImageView()
        addTitleLabel()
        addLocationLabel()
        addDateLabel()
    }
    
    private func addEventImageView() {
        self.addSubview(eventImageView)
        NSLayoutConstraint.activate([
            eventImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            eventImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            eventImageView.widthAnchor.constraint(equalToConstant: imageViewWidth),
            eventImageView.heightAnchor.constraint(equalToConstant: imageViewWidth),
        ])
    }
    
    private func addFavoriteImageView() {
        self.addSubview(favoriteImageView)
        NSLayoutConstraint.activate([
            favoriteImageView.leadingAnchor.constraint(equalTo: eventImageView.leadingAnchor, constant: -12),
            favoriteImageView.topAnchor.constraint(equalTo: eventImageView.topAnchor, constant: -12),
            favoriteImageView.heightAnchor.constraint(equalToConstant: 24),
            favoriteImageView.widthAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    private func addTitleLabel() {
        self.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: eventImageView.trailingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: eventImageView.topAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16)
        ])
    }
    
    private func addLocationLabel() {
        self.addSubview(locationLabel)
        NSLayoutConstraint.activate([
            locationLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            locationLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            locationLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
        ])
    }
    
    private func addDateLabel() {
        self.addSubview(dateLabel)
        NSLayoutConstraint.activate([
            dateLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            dateLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 4),
            dateLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8)
        ])
    }
}
