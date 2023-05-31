//
//  FavouriteLocationsCollectionViewCell.swift
//  WeatherApp
//
//  Created by Dávid Baľak on 02/06/2022.
//

import UIKit
import MapKit

class FavouriteLocationsCollectionViewCell: UICollectionViewCell {
    
    //MARK: - IBOOutlets
    @IBOutlet weak var cellMapView: MKMapView!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var countryNameLabel: UILabel!
    @IBOutlet weak var cellBottomView: UIView!
    
    
    func setupCellUI(favouriteLocation: FavouriteLocation) {
        self.contentView.layer.cornerRadius = 10
        self.contentView.layer.masksToBounds = true
        
        setupCellMap(lat: favouriteLocation.latitude,
                     long: favouriteLocation.longitude)
        setupCellLabels(cityName: favouriteLocation.locationName, countryName: favouriteLocation.countryName)
    }
    
    private func setupCellMap(lat: Double, long: Double) {
        let region = MKCoordinateRegion.init(center: CLLocationCoordinate2D(latitude: lat,
                                                                            longitude: long),
                                             latitudinalMeters: 60000,
                                             longitudinalMeters: 60000)
        cellMapView.setRegion(region, animated: true)
    }
    
    private func setupCellLabels(cityName: String, countryName: String) {
        cellBottomView.backgroundColor = UIColor.systemGray3
        cityNameLabel.font = FontsManager.systemBiggerSemiBold
        countryNameLabel.font = FontsManager.systemSmall
        
        cityNameLabel.text = cityName
        cityNameLabel.textColor = .customWhite
        countryNameLabel.text = countryName
        countryNameLabel.textColor = .customWhite
    }
}
