//
//  DatabaseManager.swift
//  WeatherApp
//
//  Created by Dávid Baľak on 03/06/2022.
//

import UIKit
import CoreData

class DatabaseManager {
    
    static let shared = DatabaseManager()
    
    private init() {
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func getAllItems() throws -> [FavouriteLocation] {
        
        do {
            let items = try context.fetch(FavouriteLocation.fetchRequest())
            return items
        } catch {
            throw CustomError.databaseGetFailed
        }
    }
    
    func saveItem(long: Double, lat: Double, locationName: String, locationCountry: String) throws {
        let newItem = FavouriteLocation(context: context)
        newItem.latitude = lat
        newItem.longitude = long
        newItem.locationName = locationName
        newItem.countryName = locationCountry
        
        do {
            try context.save()
        } catch {
            throw CustomError.databaseSaveFailed
        }
    }
    
    func deleteItem(item: FavouriteLocation) {
        context.delete(item)
        try? context.save()
    }
}
