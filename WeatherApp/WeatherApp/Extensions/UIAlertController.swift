//
//  UIAlertController.swift
//  WeatherApp
//
//  Created by Dávid Baľak on 04/06/2022.
//

import UIKit

extension UIAlertController{
    static func showAlertWithCancelButton(title: String, message: String) -> UIAlertController{
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
            alert.self.dismiss(animated: false, completion: nil)
        }))
        
        return alert
    }
}
