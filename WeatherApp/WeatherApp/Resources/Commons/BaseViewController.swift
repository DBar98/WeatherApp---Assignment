//
//  BaseViewController.swift
//  WeatherApp
//
//  Created by Dávid Baľak on 05/06/2022.
//

import UIKit

class BaseViewController: UIViewController {
    
    func setupViewNavigation() {        
        guard let navigationBar = navigationController?.navigationBar else { return }
        let font = FontsManager.largeTitle
        navigationBar.largeTitleTextAttributes = [ NSAttributedString.Key.font: font]
        navigationBar.prefersLargeTitles = true
        self.navigationItem.backButtonTitle = ""
    }
}
