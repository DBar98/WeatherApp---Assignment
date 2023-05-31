//
//  SearchTableViewCell.swift
//  WeatherApp
//
//  Created by Dávid Baľak on 04/06/2022.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupCellUI(with location: Location) {
        self.textLabel?.text = location.city
        self.detailTextLabel?.text = location.country
        self.detailTextLabel?.textColor = .label
        self.selectionStyle = .none
        self.accessoryType = .disclosureIndicator
    }

}
