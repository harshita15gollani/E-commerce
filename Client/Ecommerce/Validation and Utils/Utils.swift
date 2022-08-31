//
//  Utils.swift
//  Ecommerce
//
//  Created by Jogi Reddy on 27/07/22.
//

import Foundation

import UIKit


extension UIColor {
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        return String(format:"#%06x", rgb)
    }
}

extension UIImageView {
    func load(urlString : String) {
        guard let url = URL(string: urlString)else {
            return
        }
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}

extension Notification.Name {
    static let  refreshAllTabs = Notification.Name("RefreshAllTabs")
}


class Utils {
    func encodeData(data : String) -> (String) {
        //var temp = ""
//        for (_, character) in data.enumerated() {
//            temp += String(((character.asciiValue * 2 ) % 126 ) + 32)
//        }
        return ""
    }
}

let brandImages:[String] = [
"/Users/jogireddy/Desktop/Ecommerce/Ecommerce/Validation and Utils/Images/MicrosoftTeams-image.png",
"/Users/jogireddy/Desktop/Ecommerce/Ecommerce/Validation and Utils/Images/MicrosoftTeams-image-2.png",
"/Users/jogireddy/Desktop/Ecommerce/Ecommerce/Validation and Utils/Images/MicrosoftTeams-image-3.png",
"/Users/jogireddy/Desktop/Ecommerce/Ecommerce/Validation and Utils/Images/MicrosoftTeams-image-4.png",
"/Users/jogireddy/Desktop/Ecommerce/Ecommerce/Validation and Utils/Images/MicrosoftTeams-image-5.png"]

let brandNames:[String] = ["Apple","asus","dell","hp","lenovo"]

let cat:[String] = [
"/Users/jogireddy/Desktop/Ecommerce/Ecommerce/Validation and Utils/Images/laptop.png",
"/Users/jogireddy/Desktop/Ecommerce/Ecommerce/Validation and Utils/Images/monitor.png",
"/Users/jogireddy/Desktop/Ecommerce/Ecommerce/Validation and Utils/Images/keyboard.png",
"/Users/jogireddy/Desktop/Ecommerce/Ecommerce/Validation and Utils/Images/mouse.png",
"/Users/jogireddy/Desktop/Ecommerce/Ecommerce/Validation and Utils/Images/webcam.png"
]

let catNames:[String] = ["laptop","monitor","keyboard","mouse","webcam"]
