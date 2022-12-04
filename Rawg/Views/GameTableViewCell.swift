//
//  GameTableViewCell.swift
//  Rawg
//
//  Created by Enrico Irawan on 20/11/22.
//

import UIKit

class GameTableViewCell: UITableViewCell {
    static let identifier = "GameTableViewCell"

    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill
        imageView.layer.cornerRadius = 14
        imageView.layer.masksToBounds = true
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.textColor = .black
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 2
        return label
    }()

    private let releasedDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.textColor = .black
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 2
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
        label.font = UIFont.preferredFont(forTextStyle: .footnote)
        label.textColor = .black
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(posterImageView)
        contentView.addSubview(ratingIcon)
        contentView.addSubview(ratingLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(releasedDateLabel)

        configureConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureConstraints() {
        let posterImageViewConstraints = [
            posterImageView.topAnchor.constraint(equalToSystemSpacingBelow: contentView.topAnchor, multiplier: 2),
            contentView.bottomAnchor.constraint(equalToSystemSpacingBelow: posterImageView.bottomAnchor, multiplier: 2),
            posterImageView.leadingAnchor.constraint(equalToSystemSpacingAfter: contentView.leadingAnchor, multiplier: 2),
            posterImageView.widthAnchor.constraint(equalToConstant: contentView.bounds.width / 2)
        ]

        let ratingIconConstraints = [
            ratingIcon.topAnchor.constraint(equalToSystemSpacingBelow: contentView.topAnchor, multiplier: 2),
            ratingIcon.leadingAnchor.constraint(equalToSystemSpacingAfter: posterImageView.trailingAnchor, multiplier: 2),
            ratingIcon.heightAnchor.constraint(equalToConstant: 15),
            ratingIcon.widthAnchor.constraint(equalToConstant: 15)
        ]

        let ratingLabelConstraints = [
            ratingLabel.topAnchor.constraint(equalToSystemSpacingBelow: contentView.topAnchor, multiplier: 2),
            ratingLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: ratingIcon.trailingAnchor, multiplier: 1)
        ]

        let titleLabelConstraints = [
            titleLabel.topAnchor.constraint(equalToSystemSpacingBelow: ratingIcon.bottomAnchor, multiplier: 1),
            titleLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: posterImageView.trailingAnchor, multiplier: 2),
            contentView.trailingAnchor.constraint(equalToSystemSpacingAfter: titleLabel.trailingAnchor, multiplier: 2)
        ]

        let releasedDateLabelConstraints = [
            releasedDateLabel.topAnchor.constraint(equalToSystemSpacingBelow: titleLabel.bottomAnchor, multiplier: 1),
            releasedDateLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: posterImageView.trailingAnchor, multiplier: 2),
            contentView.trailingAnchor.constraint(equalToSystemSpacingAfter: releasedDateLabel.trailingAnchor, multiplier: 2)
        ]

        NSLayoutConstraint.activate(posterImageViewConstraints)
        NSLayoutConstraint.activate(ratingIconConstraints)
        NSLayoutConstraint.activate(ratingLabelConstraints)
        NSLayoutConstraint.activate(titleLabelConstraints)
        NSLayoutConstraint.activate(releasedDateLabelConstraints)
    }

    public func configure(with game: GameModel) {
        guard let url = URL(string: game.backgroundImage ?? "https://upload.wikimedia.org/wikipedia/commons/d/d1/Image_not_available.png") else {
            return
        }

        posterImageView.sd_setImage(with: url, completed: nil)
        titleLabel.text = game.name.uppercased()
        ratingLabel.text = game.rating.clean

        if game.released != nil {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy/MM/dd"
            let date = dateFormatter.date(from: game.released!)
            dateFormatter.dateFormat = "dd MMMM yyyy"
            releasedDateLabel.text = dateFormatter.string(from: date!)
        } else {
            releasedDateLabel.text = "Unknown date released"
        }
    }

}
