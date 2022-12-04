//
//  DetailViewController.swift
//  Touring
//
//  Created by Enrico Irawan on 16/11/22.
//

import UIKit

class DetailViewController: UIViewController {
    var gameId: Int = 0
    var selectedGame: GameDetail?
    var isFavorite: Bool = false
    
    private lazy var coreDataManager: CoreDataManager = { return CoreDataManager() }()

    let scrollViewWrapper: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .systemBackground
        return scrollView
    }()

    let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        label.textColor = .black
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 2
        return label
    }()

    private let releasedDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .body)
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
        label.font = UIFont.preferredFont(forTextStyle: .caption2)
        label.textColor = .black
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 0
        return label
    }()

    private let descriptionTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        label.textColor = .black
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 0
        label.text = "Description"
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textColor = .black
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 0
        return label
    }()
    
    private let favoriteButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(systemName: "heart.fill")
        button.setImage(image, for: .normal)
        button.tintColor = .systemGray
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.title = "Detail Game"
        self.tabBarController?.tabBar.isHidden = true

        view.addSubview(scrollViewWrapper)
        contentView.addSubview(imageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(ratingIcon)
        contentView.addSubview(ratingLabel)
        contentView.addSubview(releasedDateLabel)
        contentView.addSubview(descriptionTitleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(favoriteButton)
        scrollViewWrapper.addSubview(contentView)
        
        checkIsFavorite()
        
        favoriteButton.addTarget(self, action: #selector(addToFavorite), for: .touchUpInside)

        Task {
            do {
                let gameDetail = try await NetworkClient.shared.getDetailGame(with: gameId)
                selectedGame = gameDetail
                imageView.sd_setImage(with: URL(string: gameDetail.backgroundImage ?? "https://upload.wikimedia.org/wikipedia/commons/d/d1/Image_not_available.png"))
                nameLabel.text = gameDetail.name
                ratingLabel.text = gameDetail.rating.clean
                descriptionLabel.text = gameDetail.descriptionRaw.isEmpty ? "No description found" : gameDetail.descriptionRaw

                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy/MM/dd"
                let date = dateFormatter.date(from: gameDetail.released)
                dateFormatter.dateFormat = "dd MMMM yyyy"
                releasedDateLabel.text = dateFormatter.string(from: date!)
            } catch {
                let alert = UIAlertController(title: "Alert", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
        }

        configureConstraints()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        scrollViewWrapper.contentSize.height = view.frame.height + 200
    }
    
    @objc private func addToFavorite() {
        if isFavorite {
            removeFromFavorite()
        } else {
            insertToFavorite()
        }
    }
    
    private func insertToFavorite() {
        coreDataManager.insertGame(
            selectedGame?.id ?? 0,
            selectedGame?.name ?? "",
            selectedGame?.released ?? "",
            selectedGame?.backgroundImage ?? "https://upload.wikimedia.org/wikipedia/commons/d/d1/Image_not_available.png",
            selectedGame?.rating ?? 0) {
                NotificationCenter.default.post(name: NSNotification.Name("favorite"), object: nil)
                self.isFavorite = !self.isFavorite
                self.toogleFavorite()
            }
    }
    
    private func removeFromFavorite() {
        coreDataManager.deleteGame(gameId) {
            self.isFavorite = false
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: NSNotification.Name("favorite"), object: nil)
                self.toogleFavorite()
            }
        }
    }
    
    private func toogleFavorite() {
        favoriteButton.tintColor = isFavorite ? .systemPink : .systemGray
    }
    
    private func checkIsFavorite() {
        coreDataManager.checkIsFavorite(gameId) { [weak self] isFavorite in
            self?.isFavorite = isFavorite
            DispatchQueue.main.async {
                self?.toogleFavorite()
            }
        }
    }

    private func configureConstraints() {
        let scrollViewWrapperConstraints = [
            scrollViewWrapper.topAnchor.constraint(equalTo: view.topAnchor),
            scrollViewWrapper.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            view.bottomAnchor.constraint(equalTo: scrollViewWrapper.bottomAnchor),
            view.trailingAnchor.constraint(equalTo: scrollViewWrapper.trailingAnchor)
        ]

        let contentViewConstraints = [
            contentView.topAnchor.constraint(equalTo: scrollViewWrapper.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollViewWrapper.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ]

        let imageViewConstraints = [
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: view.bounds.height / 3)
        ]

        let nameLabelConstraints = [
            nameLabel.topAnchor.constraint(equalToSystemSpacingBelow: imageView.bottomAnchor, multiplier: 2),
            nameLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: contentView.leadingAnchor, multiplier: 2),
            nameLabel.widthAnchor.constraint(equalToConstant: view.bounds.width - 100)
        ]

        let ratingIconConstraints = [
            ratingIcon.topAnchor.constraint(equalToSystemSpacingBelow: imageView.bottomAnchor, multiplier: 2),
            contentView.trailingAnchor.constraint(equalToSystemSpacingAfter: ratingIcon.trailingAnchor, multiplier: 2),
            ratingIcon.heightAnchor.constraint(equalToConstant: 30),
            ratingIcon.widthAnchor.constraint(equalToConstant: 30)
        ]

        let ratingLabelConstraints = [
            ratingLabel.topAnchor.constraint(equalToSystemSpacingBelow: ratingIcon.bottomAnchor, multiplier: 1),
            contentView.trailingAnchor.constraint(equalToSystemSpacingAfter: ratingLabel.trailingAnchor, multiplier: 2)
        ]

        let releasedDateLabelConstraints = [
            releasedDateLabel.topAnchor.constraint(equalToSystemSpacingBelow: nameLabel.bottomAnchor, multiplier: 1),
            releasedDateLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: contentView.leadingAnchor, multiplier: 2),
            releasedDateLabel.widthAnchor.constraint(equalToConstant: view.bounds.width - 100)
        ]

        let descriptionTitleLabelConstraints = [
            descriptionTitleLabel.topAnchor.constraint(equalToSystemSpacingBelow: releasedDateLabel.bottomAnchor, multiplier: 4),
            descriptionTitleLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: contentView.leadingAnchor, multiplier: 2)
        ]

        let descriptionLabelConstraints = [
            descriptionLabel.topAnchor.constraint(equalToSystemSpacingBelow: descriptionTitleLabel.bottomAnchor, multiplier: 1),
            descriptionLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: contentView.leadingAnchor, multiplier: 2),
            contentView.trailingAnchor.constraint(equalToSystemSpacingAfter: descriptionLabel.trailingAnchor, multiplier: 2)
        ]
        
        let favoriteButtonConstraints = [
            view.trailingAnchor.constraint(equalTo: favoriteButton.trailingAnchor),
            favoriteButton.topAnchor.constraint(equalToSystemSpacingBelow: releasedDateLabel.bottomAnchor, multiplier: 4),
            favoriteButton.widthAnchor.constraint(equalToConstant: 50)
        ]

        NSLayoutConstraint.activate(scrollViewWrapperConstraints)
        NSLayoutConstraint.activate(contentViewConstraints)
        NSLayoutConstraint.activate(imageViewConstraints)
        NSLayoutConstraint.activate(nameLabelConstraints)
        NSLayoutConstraint.activate(ratingIconConstraints)
        NSLayoutConstraint.activate(ratingLabelConstraints)
        NSLayoutConstraint.activate(releasedDateLabelConstraints)
        NSLayoutConstraint.activate(descriptionTitleLabelConstraints)
        NSLayoutConstraint.activate(descriptionLabelConstraints)
        NSLayoutConstraint.activate(favoriteButtonConstraints)
    }

    public func configure(with id: Int) {
        gameId = id
    }
}
