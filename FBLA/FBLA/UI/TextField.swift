//
//  TextField.swift
//  FBLA
//
//  Created by Satvik Borra on 9/30/18.
//  Copyright © 2018 satvik borra. All rights reserved.
//

import UIKit

class TextField : UITextField{
    
    
    var outFrame : CGRect!
    var inFrame : CGRect!
    
    init(outFrame : CGRect, inFrame: CGRect) {
        self.outFrame = outFrame
        self.inFrame = inFrame
        
        super.init(frame: outFrame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func animateIn(time: CGFloat = transitionTime) {
        UIView.animate(withDuration: TimeInterval(time), animations: {
            self.frame = self.inFrame
        })
    }
    
    func animateOut(time: CGFloat = transitionTime){
        UIView.animate(withDuration: TimeInterval(time), animations: {
            self.frame = self.outFrame
        })
    }
}
