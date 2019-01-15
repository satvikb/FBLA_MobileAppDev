//
//  ScreenScaler.swift
//  FBLA
//
//  Created by Satvik Borra on 9/27/18.
//  Copyright © 2018 satvik borra. All rights reserved.
//

import UIKit

// Constant to define a scale
let DEFAULT_WIDTH : CGFloat = 375

// Helper functions to translate a decimal proportional system to actual screen coordinates. This allows a "one size fits all" approach instead of worrying about multiple screen resolutions
func propToFloat(prop: CGFloat, by: CGFloat) -> CGFloat {
    return prop * by
}

func propToPoint(prop: CGPoint, size: CGSize) -> CGPoint {
    return CGPoint(x: prop.x * size.width, y: prop.y * size.height)
}

func propToRect(prop: CGRect, frame: CGRect) -> CGRect {
    return CGRect(x: prop.origin.x * frame.size.width, y: prop.origin.y * frame.size.height, width: prop.size.width * frame.size.width, height: prop.size.height * frame.size.height)
}

func fontSize(propFontSize : CGFloat) -> CGFloat {
    return propFontSize*(UIScreen.main.bounds.width/DEFAULT_WIDTH)
}

// Extension to use darker and lighter colors for complements
extension UIColor {
    
    func lighter(by percentage: CGFloat = 30.0) -> UIColor? {
        return self.adjust(by: abs(percentage) )
    }
    
    func darker(by percentage: CGFloat = 30.0) -> UIColor? {
        return self.adjust(by: -1 * abs(percentage) )
    }
    
    func adjust(by percentage: CGFloat = 30.0) -> UIColor? {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        if self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            return UIColor(red: min(red + percentage/100, 1.0),
                           green: min(green + percentage/100, 1.0),
                           blue: min(blue + percentage/100, 1.0),
                           alpha: alpha)
        } else {
            return nil
        }
    }
}
