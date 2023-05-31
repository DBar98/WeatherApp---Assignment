//
//  WeatherDetailTableViewCell.swift
//  WeatherApp
//
//  Created by Dávid Baľak on 01/06/2022.
//

import UIKit

class WeatherDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var dailyCloudsLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    //MARK: - Setup Cell UI
    func setupCellUI(with item: ForecastItem) {
        let date = Date(timeIntervalSince1970: Double(item.day))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        self.backgroundColor = .clear
        self.selectionStyle = .none
        
        dayLabel.text = dateFormatter.string(from: date)
        dailyCloudsLabel.text = String(format: "%.0f",(item.dailyRain)) + " %"
        dailyCloudsLabel.textColor = .customBlue
        temperatureLabel.text = String("\(item.temperature.roundToNearestInt())°C")
        weatherIcon.image = UIImage(systemName: item.conditionImage)?.withRenderingMode(.alwaysOriginal)
    }
}
