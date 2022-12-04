//
//  MainTabBarViewController.swift
//  Rawg
//
//  Created by Enrico Irawan on 19/11/22.
//

import UIKit

class MainTabBarViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()

        let homeVC = UINavigationController(rootViewController: HomeViewController())
        let favoriteVC = UINavigationController(rootViewController: FavoriteViewController())
        let accountVC = UINavigationController(rootViewController: AccountViewController())

        homeVC.tabBarItem.image = UIImage(systemName: "house")
        homeVC.title = "Home"

        favoriteVC.tabBarItem.image = UIImage(systemName: "heart")
        favoriteVC.title = "Favorite"

        accountVC.tabBarItem.image = UIImage(systemName: "person.circle")
        accountVC.title = "Account"

        tabBar.tintColor = .systemOrange
        tabBar.backgroundColor = .systemBackground
        tabBar.layer.shadowOffset = CGSize(width: 0, height: 0)
        tabBar.layer.shadowRadius = 2
        tabBar.layer.shadowColor = UIColor.black.cgColor
        tabBar.layer.shadowOpacity = 0.3

        setViewControllers([homeVC, favoriteVC, accountVC], animated: true)
    }
}
