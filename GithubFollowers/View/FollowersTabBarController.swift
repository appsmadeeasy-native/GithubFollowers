//
//  FollowersTabBarController.swift
//  GithubFollowers
//
//  Created by Syed Mahmud on 1/6/22.
//

import UIKit

class FollowersTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let item1 = UINavigationController(rootViewController: SearchVC())
        item1.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), selectedImage: UIImage(systemName: "magnifyingglass"))
        let item2 = UINavigationController(rootViewController: FavoritesVC())
        item2.tabBarItem = UITabBarItem(title: "Favorites", image: UIImage(systemName: "star"), selectedImage: UIImage(systemName: "star"))
        let controllers = [item1, item2]
        self.viewControllers = controllers
        self.tabBar.backgroundColor = .secondarySystemBackground
        
        // Change tabBarItem text color
        let tabBarAppearance = UITabBarAppearance()
        let tabBarItemAppearance = UITabBarItemAppearance()
        tabBarItemAppearance.selected.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.systemGreen]
        tabBarItemAppearance.selected.iconColor = UIColor.systemGreen
        
        tabBarAppearance.stackedLayoutAppearance = tabBarItemAppearance
        tabBar.standardAppearance = tabBarAppearance
    }
}
