//
//  ScreenScaler.swift
//  FBLA
//
//  Created by Satvik Borra on 9/27/18.
//  Copyright © 2018 satvik borra. All rights reserved.
//

import UIKit

let DEFAULT_WIDTH : CGFloat = 375;

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
