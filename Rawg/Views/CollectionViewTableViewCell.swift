//
//  CollectionViewTableViewCell.swift
//  Rawg
//
//  Created by Enrico Irawan on 20/11/22.
//

import UIKit

protocol CollectionViewTableViewCellDelegate: AnyObject {
    func collectionViewTableViewCellDidTapCell(_ cell: CollectionViewTableViewCell, id: Int)
}

class CollectionViewTableViewCell: UITableViewCell {
    static let identifier = "CollectionViewTableViewCell"

    var delegate: CollectionViewTableViewCellDelegate?

    private var games: [GameModel] = [GameModel]()

    private let collectionViews: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(GameCollectionViewCell.self, forCellWithReuseIdentifier: GameCollectionViewCell.identifier)
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()

    private let activityIndicator: UIActivityIndicatorView = {
        let loading = UIActivityIndicatorView()
        loading.style = .large
        loading.color = .systemGray
        return loading
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(collectionViews)

        collectionViews.backgroundView = activityIndicator
        activityIndicator.startAnimating()

        collectionViews.dataSource = self
        collectionViews.delegate = self

        configureConstraint()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    private func configureConstraint() {
        let collectionViewsConstraint = [
            collectionViews.topAnchor.constraint(equalTo: contentView.topAnchor),
            collectionViews.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: collectionViews.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: collectionViews.bottomAnchor)
        ]

        NSLayoutConstraint.activate(collectionViewsConstraint)
    }

    public func configure(with games: [GameModel]) {
        self.games = games
        self.collectionViews.reloadData()
        activityIndicator.stopAnimating()
    }
}

extension CollectionViewTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return games.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GameCollectionViewCell.identifier, for: indexPath) as? GameCollectionViewCell else {
            return UICollectionViewCell()
        }

        let game = games[indexPath.row]
        cell.configure(with: game)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: contentView.frame.width - 80, height: contentView.frame.height - 40)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let game = games[indexPath.row]
        self.delegate?.collectionViewTableViewCellDidTapCell(self, id: game.id)
    }
}
