//
//  CustomFooterView.swift
//  WeatherApp
//
//  Created by Dávid Baľak on 01/06/2022.
//

import UIKit

enum TableViewButtonType {
    case defaulType, cancelType
    
    var buttonTitle: String {
        get {
            switch self {
            case .defaulType:
                return AppStrings.addToFavourites
            case .cancelType:
                return AppStrings.removeFromFavourites
            }
        }
    }
}

protocol CustomFooterViewDelegate: AnyObject {
    func didPressedFavouriteButton(isFavourite: Bool)
}

class CustomFooterView: UITableViewHeaderFooterView {

    @IBOutlet weak var favouriteButton: UIButton!
    var buttonType: TableViewButtonType?
    weak var delegate: CustomFooterViewDelegate?
   
    func setupView(buttonType: TableViewButtonType) {
        favouriteButton.setTitle(buttonType.buttonTitle, for: .normal)
        favouriteButton.titleLabel?.font = FontsManager.systemBiggerSemiBold
        
        switch buttonType {
        case .defaulType:
            self.favouriteButton.setTitleColor( .customPurple, for: .normal)
        case .cancelType:
            favouriteButton.setTitleColor(.customRed, for: .normal)
        }
        self.buttonType = buttonType
    }
    
    @IBAction func favouriteButtonPressed(_ sender: Any) {
        guard let buttonType = buttonType else { return }
        
        switch buttonType {
        case .defaulType:
            delegate?.didPressedFavouriteButton(isFavourite: true)
        case .cancelType:
            delegate?.didPressedFavouriteButton(isFavourite: false)
        }
    }
}
