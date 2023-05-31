//
//  FavouriteLocation+CoreDataProperties.swift
//  WeatherApp
//
//  Created by Dávid Baľak on 02/06/2022.
//
//

import Foundation
import CoreData


extension FavouriteLocation {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavouriteLocation> {
        return NSFetchRequest<FavouriteLocation>(entityName: "FavouriteLocation")
    }

    @NSManaged public var longitude: Double
    @NSManaged public var latitude: Double
    @NSManaged public var locationName: String
    @NSManaged public var countryName: String

}

extension FavouriteLocation : Identifiable {

}
