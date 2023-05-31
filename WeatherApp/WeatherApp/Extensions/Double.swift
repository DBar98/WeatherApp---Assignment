//
//  Double.swift
//  WeatherApp
//
//  Created by Dávid Baľak on 01/06/2022.
//

extension Double {
    
    func roundToNearestInt() -> Int{
        return (Int(self.rounded()))
    }
}
