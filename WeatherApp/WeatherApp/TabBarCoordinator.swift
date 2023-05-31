//
//  TabBarCoordinator.swift
//  WeatherApp
//
//  Created by Dávid Baľak on 30/05/2022.
//
import Foundation

protocol TabBarCoordinatorType {
    func start() -> TabBarViewController
}

class TabBarCoordinator: TabBarCoordinatorType {
    
    func start() -> TabBarViewController {
        let tabBar = TabBarViewController()
        tabBar.setupAppearance()
        tabBar.viewControllers = tabBar.setupVCs()
        tabBar.modalPresentationStyle = .overFullScreen
        return tabBar
    }
}
