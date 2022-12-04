//
//  FavoriteViewController.swift
//  Rawg
//
//  Created by Enrico Irawan on 19/11/22.
//

import UIKit

class FavoriteViewController: UIViewController {
    public var games: [GameModel] = [GameModel]()
    private lazy var coreDataManager: CoreDataManager = { return CoreDataManager() }()
    
    public let favoriteTable: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(GameTableViewCell.self, forCellReuseIdentifier: GameTableViewCell.identifier)
        table.showsVerticalScrollIndicator = false
        return table
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.title = "Favorite".uppercased()
        
        view.addSubview(favoriteTable)

        favoriteTable.dataSource = self
        favoriteTable.delegate = self

        configureConstraint()
        getFavoriteGames()
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name("favorite"), object: nil, queue: nil) { _ in
            self.getFavoriteGames()
        }
    }
    
    private func getFavoriteGames() {
        coreDataManager.getAllGames { [weak self] games in
            self?.games = games
            DispatchQueue.main.async {
                self?.favoriteTable.reloadData()
            }
        }
    }
    
    private func configureConstraint() {
        let favoriteTableConstraints = [
            favoriteTable.topAnchor.constraint(equalToSystemSpacingBelow: view.topAnchor, multiplier: 2),
            favoriteTable.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: favoriteTable.trailingAnchor, multiplier: 2),
            view.bottomAnchor.constraint(equalToSystemSpacingBelow: favoriteTable.bottomAnchor, multiplier: 2)
        ]

        NSLayoutConstraint.activate(favoriteTableConstraints)
    }
}

extension FavoriteViewController: UITableViewDelegate, UITableViewDataSource {
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let selectedGame = games[indexPath.row]
        
        if editingStyle == .delete {
            coreDataManager.deleteGame(selectedGame.id) {
                DispatchQueue.main.async {
                    self.games.remove(at: indexPath.row)
                    self.favoriteTable.deleteRows(at: [indexPath], with: .automatic)
                    self.favoriteTable.reloadData()
                }
            }
          }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedGame = games[indexPath.row]
        let detailVC = DetailViewController()
        detailVC.gameId = selectedGame.id
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}
