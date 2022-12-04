//
//  GameCollectionViewCell.swift
//  Rawg
//
//  Created by Enrico Irawan on 20/11/22.
//

import UIKit
import SDWebImage

class GameCollectionViewCell: UICollectionViewCell {
    static let identifier = "TitleCollectionViewCell"

    private let posterImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        return imageView
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 2
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.textColor = .systemOrange
        return label
    }()

    private let dateReleasedLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 0
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.textColor = .systemGray
        return label
    }()

    private let ratingIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "star.fill")
        imageView.tintColor = .systemYellow
        return imageView
    }()

    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 0
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.textColor = .systemOrange
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.cornerRadius = 20
        contentView.backgroundColor = .white
        contentView.layer.shadowOffset = CGSize(width: 0, height: 0)
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.23
        contentView.layer.shadowRadius = 4

        contentView.addSubview(posterImage)
        contentView.addSubview(nameLabel)
        contentView.addSubview(dateReleasedLabel)
        contentView.addSubview(ratingIcon)
        contentView.addSubview(ratingLabel)

        configureConstraint()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    private func configureConstraint() {
        let posterImageConstraints = [
            posterImage.topAnchor.constraint(equalToSystemSpacingBelow: contentView.topAnchor, multiplier: 2),
            posterImage.leadingAnchor.constraint(equalToSystemSpacingAfter: contentView.leadingAnchor, multiplier: 2),
            contentView.trailingAnchor.constraint(equalToSystemSpacingAfter: posterImage.trailingAnchor, multiplier: 2),
            posterImage.heightAnchor.constraint(equalToConstant: 150)
        ]

        let nameLabelConstraints = [
            nameLabel.topAnchor.constraint(equalToSystemSpacingBelow: posterImage.bottomAnchor, multiplier: 2),
            nameLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: contentView.leadingAnchor, multiplier: 2),
            contentView.trailingAnchor.constraint(equalToSystemSpacingAfter: nameLabel.trailingAnchor, multiplier: 2)
        ]

        let dateReleasedLabelConstraints = [
            dateReleasedLabel.topAnchor.constraint(equalToSystemSpacingBelow: nameLabel.bottomAnchor, multiplier: 1),
            dateReleasedLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: contentView.leadingAnchor, multiplier: 2)
        ]

        let ratingIconConstraints = [
            ratingIcon.topAnchor.constraint(equalToSystemSpacingBelow: posterImage.bottomAnchor, multiplier: 2)
        ]

        let ratingLabelConstraints = [
            ratingLabel.topAnchor.constraint(equalToSystemSpacingBelow: posterImage.bottomAnchor, multiplier: 2),
            contentView.trailingAnchor.constraint(equalToSystemSpacingAfter: ratingLabel.trailingAnchor, multiplier: 2),
            ratingLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: ratingIcon.trailingAnchor, multiplier: 0.5)
        ]

        NSLayoutConstraint.activate(posterImageConstraints)
        NSLayoutConstraint.activate(nameLabelConstraints)
        NSLayoutConstraint.activate(dateReleasedLabelConstraints)
        NSLayoutConstraint.activate(ratingIconConstraints)
        NSLayoutConstraint.activate(ratingLabelConstraints)
    }

    public func configure(with game: GameModel) {
        guard let url = URL(string: game.backgroundImage ?? "https://upload.wikimedia.org/wikipedia/commons/d/d1/Image_not_available.png") else {
            return
        }

        posterImage.sd_setImage(with: url, completed: nil)
        nameLabel.text = game.name

        ratingLabel.text = game.rating.clean

        if game.released != nil {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy/MM/dd"
            let date = dateFormatter.date(from: game.released!)
            dateFormatter.dateFormat = "dd MMMM yyyy"
            dateReleasedLabel.text = dateFormatter.string(from: date!)
        } else {
            dateReleasedLabel.text = "Unknown release date"
        }
    }
}
