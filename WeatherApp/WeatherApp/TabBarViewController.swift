//
//  TabBarViewController.swift
//  WeatherApp
//
//  Created by Dávid Baľak on 30/05/2022.
//

import UIKit

class TabBarViewController: UITabBarController {
        
    var databaseManager = DatabaseManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNotificationObserver()
    }
    
    func setupAppearance() {
        view.backgroundColor = .systemBackground
    }
    
    //MARK: - Deinit
    deinit {
        NotificationCenter.default
            .removeObserver(self,
                            name:  NSNotification.Name(WeatherDetailViewModel.favouritesChanged),
                            object: nil)
    }
}

//MARK: - Setup View Controllers
extension TabBarViewController {
    func setupVCs() -> [UINavigationController]{
        
        let mapCoordinator = MapCoordinator()
        let mapViewController = mapCoordinator.start()
        let mapTabItem = UITabBarItem()
        mapTabItem.image =  UIImage(systemName: "map")
        mapTabItem.title = AppStrings.map
        mapViewController.tabBarItem = mapTabItem
        
        let searchCoordinator = SearchCoordinator()
        let searchViewController = searchCoordinator.start()
        let searchItem = UITabBarItem()
        searchItem.image =  UIImage(systemName: "magnifyingglass")
        searchItem.title = AppStrings.search
        searchViewController.tabBarItem = searchItem
        
        let favouriteCoordinator = FavouriteLocationsCoordinator()
        let favouriteViewController = favouriteCoordinator.start()
        let favouriteItem = UITabBarItem()
        favouriteItem.image =  UIImage(systemName: "star")
        
        let dbfavourites = try? databaseManager.getAllItems()
        if let dbfavourites = dbfavourites, dbfavourites.count > 0 {
            favouriteItem.badgeValue = String(dbfavourites.count)
        }
       
        favouriteItem.title = AppStrings.favourites
        favouriteViewController.tabBarItem = favouriteItem
        
        return [mapViewController, searchViewController, favouriteViewController]
    }
}

//MARK: - Observer Setup
extension TabBarViewController {
    @objc func tabBarUpdate() {
        if let favController = self.viewControllers?[2] {
            let dbfavourites = try? databaseManager.getAllItems()
            guard let favouritesCount = dbfavourites?.count else { return }
            favController.tabBarItem.badgeValue = String(favouritesCount)
        }
    }
    
    func setupNotificationObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(tabBarUpdate), name: Notification.Name(WeatherDetailViewModel.favouritesChanged), object: nil)
    }
}
