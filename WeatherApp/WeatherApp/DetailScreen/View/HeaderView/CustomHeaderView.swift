//
//  CustomHeaderView.swift
//  WeatherApp
//
//  Created by Dávid Baľak on 01/06/2022.
//

import UIKit

class CustomHeaderView: UITableViewHeaderFooterView {

    @IBOutlet weak var currentTemperatureLabel: UILabel!
    @IBOutlet weak var currentWeatherDescLabel: UILabel!
    @IBOutlet weak var feelsLikeLabel: UILabel!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    func setupHeaderUI(currentWeatherData: CurrentWeatherData) {
        self.currentTemperatureLabel.text = currentWeatherData.currentTemp
        self.currentWeatherDescLabel.text = currentWeatherData.currentWeatherDesc
        self.feelsLikeLabel.text = currentWeatherData.feelsLike
        
        setupHeaderFonts()
    }
    
    func setupHeaderFonts() {
        currentTemperatureLabel.font = FontsManager.systemBlack
        currentWeatherDescLabel.font = FontsManager.systemBig
        feelsLikeLabel.font = FontsManager.systemBigger
        feelsLikeLabel.textColor = .customGray
    }

}
