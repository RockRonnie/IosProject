//
//  HexaToColor.swift
//  StrawberryPie
//
//  Created by iosdev on 10/12/2019.
//  Copyright © 2019 Team Työkkäri. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat
        
        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])
            
            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0
                
                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255
                    
                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }
        
        return nil
    }
}

func judasRed() -> UIColor {
    let judasRed = #colorLiteral(red: 0.7960784314, green: 0.01568627451, blue: 0.01568627451, alpha: 1)
    let judasOrange = #colorLiteral(red: 1, green: 0.6196078431, blue: 0, alpha: 1)
    let judasBlue = #colorLiteral(red: 0, green: 0.6901960784, blue: 1, alpha: 1)
    let judasGrey = #colorLiteral(red: 0.9333333333, green: 0.9333333333, blue: 0.9333333333, alpha: 1)
    let judasBlack = #colorLiteral(red: 0.1490196078, green: 0.1411764706, blue: 0.1411764706, alpha: 1)
return judasRed
}
