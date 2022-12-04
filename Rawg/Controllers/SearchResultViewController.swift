//
//  SearchResultViewController.swift
//  Rawg
//
//  Created by Enrico Irawan on 20/11/22.
//

import UIKit

protocol SearchResultViewControllerDelegate: AnyObject {
    func searchResultViewControllerDidTapItem(_ game: GameModel)
}

class SearchResultViewController: UIViewController {
    public var games: [GameModel] = [GameModel]()

    public var delegate: SearchResultViewControllerDelegate?

    public let searchResultTable: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(GameTableViewCell.self, forCellReuseIdentifier: GameTableViewCell.identifier)
        table.showsVerticalScrollIndicator = false
        return table
    }()

    public let activityIndicator: UIActivityIndicatorView = {
        let loading = UIActivityIndicatorView()
        loading.style = .large
        loading.color = .systemGray
        return loading
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(searchResultTable)

        searchResultTable.backgroundView = activityIndicator
        searchResultTable.dataSource = self
        searchResultTable.delegate = self

        configureConstraint()
    }

    private func configureConstraint() {
        let searchResultTableConstraints = [
            searchResultTable.topAnchor.constraint(equalToSystemSpacingBelow: view.topAnchor, multiplier: 2),
            searchResultTable.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: searchResultTable.trailingAnchor, multiplier: 2),
            view.bottomAnchor.constraint(equalToSystemSpacingBelow: searchResultTable.bottomAnchor, multiplier: 2)
        ]

        NSLayoutConstraint.activate(searchResultTableConstraints)
    }
}

extension SearchResultViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return games.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: GameTableViewCell.identifier, for: indexPath) as? GameTableViewCell {
            let game = games[indexPath.row]
            cell.configure(with: game)
            return cell
        } else {
            return UITableViewCell()
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Search result"
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedGame = games[indexPath.row]
        self.delegate?.searchResultViewControllerDidTapItem(selectedGame)
    }
}
