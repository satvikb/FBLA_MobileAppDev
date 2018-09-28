//
//  ScreenScaler.swift
//  FBLA
//
//  Created by Satvik Borra on 9/27/18.
//  Copyright © 2018 satvik borra. All rights reserved.
//

import UIKit

func propToRect(prop: CGRect, frame: CGRect) -> CGRect {
    return CGRect(x: prop.origin.x * frame.size.width, y: prop.origin.y * frame.size.height, width: prop.size.width * frame.size.width, height: prop.size.height * frame.size.height)
}
