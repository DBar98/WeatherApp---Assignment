//
//  UIColorExtension.swift
//  WeatherApp
//
//  Created by Dávid Baľak on 30/05/2022.
//
import UIKit

extension UIColor {
    
    static let customPurple = UIColor().colorFromHex("#9437FF")
    static let customGray = UIColor().colorFromHex("#8E8E93")
    static let customBlack = UIColor().colorFromHex("#000000")
    static let customBlue = UIColor().colorFromHex("#0096FF")
    static let customRed = UIColor().colorFromHex("#FF3B30")
    static let customWhite = UIColor().colorFromHex("#FFFFFF")

    
    func colorFromHex(_ hex: String) -> UIColor {
        var hexString = hex.trimmingCharacters(in: .whitespaces).uppercased()
        
        if hexString.hasPrefix("#") {
            hexString.remove(at: hexString.startIndex)
        }
        
        if hexString.count != 6 {
            return UIColor.black
        }
        
        var rgb: UInt64 = 0
        Scanner(string: hexString).scanHexInt64(&rgb)
        
        return UIColor.init(red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
                            green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
                            blue: CGFloat(rgb & 0x0000FF) / 255.0,
                            alpha: 1.0)
    }
}
