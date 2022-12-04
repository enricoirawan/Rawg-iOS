//
//  SearchViewController.swift
//  Rawg
//
//  Created by Enrico Irawan on 20/11/22.
//

import UIKit

class SearchViewController: UIViewController {
    private let searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: SearchResultViewController())
        controller.searchBar.placeholder = "Search games"
        controller.searchBar.searchBarStyle = .minimal
        return controller
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        self.tabBarController?.tabBar.isHidden = true
        navigationController?.navigationBar.tintColor = UIColor.systemOrange

        title = "Search"
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.systemOrange]
        navigationController?.navigationBar.titleTextAttributes = textAttributes

        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
    }
}

extension SearchViewController: UISearchResultsUpdating, SearchResultViewControllerDelegate {
    func searchResultViewControllerDidTapItem(_ game: GameModel) {
        let detailVC = DetailViewController()
        detailVC.configure(with: game.id)
        self.navigationController?.pushViewController(detailVC, animated: true)
    }

    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar

        guard let query = searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty,
              query.trimmingCharacters(in: .whitespaces).count >= 3,
              let resultsController = searchController.searchResultsController as? SearchResultViewController else {
            return
        }

        resultsController.delegate = self

        Task {
            do {
                resultsController.activityIndicator.startAnimating()
                let games = try await NetworkClient.shared.searchGames(with: query)
                resultsController.games = games
                resultsController.searchResultTable.reloadData()
                resultsController.activityIndicator.stopAnimating()
            } catch {
                let alert = UIAlertController(title: "Alert", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
        }
    }
}
