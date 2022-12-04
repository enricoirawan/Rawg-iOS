//
//  ViewController.swift
//  Rawg
//
//  Created by Enrico Irawan on 19/11/22.
//

import UIKit

enum Sections: Int {
    case popularGames = 0
    case recommendedGames = 1
    case others = 2
}

class HomeViewController: UIViewController {
    let sectionTitle: [String] = [
        "Popular Games",
        "Recommended Games",
        "Others"
    ]

    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "enrico_photo")
        return imageView
    }()

    private let greetingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 0
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.text = "Welcome back"
        label.textColor = .systemGray
        return label
    }()

    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 0
        label.font = UIFont.preferredFont(forTextStyle: .title2)
        label.text = "Enrico Irawan"
        label.textColor = .systemOrange
        return label
    }()

    private let searchIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "magnifyingglass")
        imageView.tintColor = .systemOrange
        return imageView
    }()

    private let homeFeedTable: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.identifier)
        table.showsVerticalScrollIndicator = false
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        view.addSubview(profileImageView)
        view.addSubview(greetingLabel)
        view.addSubview(usernameLabel)
        view.addSubview(searchIcon)
        view.addSubview(homeFeedTable)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(searchTapped))
        searchIcon.addGestureRecognizer(tapGesture)
        searchIcon.isUserInteractionEnabled = true

        homeFeedTable.dataSource = self
        homeFeedTable.delegate = self

        configureConstraint()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }

    private func configureConstraint() {
        let profileImageViewConstraints = [
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            profileImageView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.safeAreaLayoutGuide.leadingAnchor, multiplier: 2),
            profileImageView.heightAnchor.constraint(equalToConstant: 50),
            profileImageView.widthAnchor.constraint(equalToConstant: 50)
        ]

        let greetingLabelConstraints = [
            greetingLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            greetingLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: profileImageView.trailingAnchor, multiplier: 2)
        ]

        let usernameLabelConstraints = [
            usernameLabel.topAnchor.constraint(equalTo: greetingLabel.bottomAnchor),
            usernameLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: profileImageView.trailingAnchor, multiplier: 2)
        ]

        let searchIconConstraints = [
            searchIcon.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 1),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: searchIcon.trailingAnchor, multiplier: 2),
            searchIcon.heightAnchor.constraint(equalToConstant: 30),
            searchIcon.widthAnchor.constraint(equalToConstant: 30)
        ]

        let homeFeedTableConstraints = [
            homeFeedTable.topAnchor.constraint(equalToSystemSpacingBelow: profileImageView.bottomAnchor, multiplier: 2),
            view.bottomAnchor.constraint(equalToSystemSpacingBelow: homeFeedTable.bottomAnchor, multiplier: 2),
            homeFeedTable.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: homeFeedTable.trailingAnchor)
        ]

        NSLayoutConstraint.activate(profileImageViewConstraints)
        NSLayoutConstraint.activate(greetingLabelConstraints)
        NSLayoutConstraint.activate(usernameLabelConstraints)
        NSLayoutConstraint.activate(searchIconConstraints)
        NSLayoutConstraint.activate(homeFeedTableConstraints)
    }

    @objc private func searchTapped() {
        self.navigationController?.pushViewController(SearchViewController(), animated: true)
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitle.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.identifier, for: indexPath) as? CollectionViewTableViewCell else {
            return UITableViewCell()
        }

        cell.delegate = self

        switch indexPath.section {
            case Sections.popularGames.rawValue:
                Task {
                    do {
                        let games = try await NetworkClient.shared.getPopularGames()
                        cell.configure(with: games)
                    } catch {
                        let alert = UIAlertController(title: "Alert", message: error.localizedDescription, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                        self.present(alert, animated: true)
                    }
                }
            case Sections.recommendedGames.rawValue:
                Task {
                    do {
                        let games = try await NetworkClient.shared.getRecommendedGames()
                        cell.configure(with: games)
                    } catch {
                        let alert = UIAlertController(title: "Alert", message: error.localizedDescription, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                        self.present(alert, animated: true)
                    }
                }
            case Sections.others.rawValue:
                Task {
                    do {
                        let games = try await NetworkClient.shared.getOtherGames()
                        cell.configure(with: games)
                    } catch {
                        let alert = UIAlertController(title: "Alert", message: error.localizedDescription, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                        self.present(alert, animated: true)
                    }
                }
            default:
                return UITableViewCell()
        }

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 280
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else {return}
        header.textLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        header.textLabel?.frame = CGRect(x: header.bounds.origin.x + 20, y: header.bounds.origin.y, width: 100, height: header.bounds.height)
        header.textLabel?.textColor = .systemOrange
        header.textLabel?.text = header.textLabel?.text?.capitalizedFirstLetter()
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitle[section]
    }
}

extension HomeViewController: CollectionViewTableViewCellDelegate {
    func collectionViewTableViewCellDidTapCell(_ cell: CollectionViewTableViewCell, id: Int) {
        let detailVC = DetailViewController()
        detailVC.configure(with: id)
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}
