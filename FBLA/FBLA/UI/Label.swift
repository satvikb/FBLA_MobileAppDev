//
//  Label.swift
//  FBLA
//
//  Created by Satvik Borra on 9/27/18.
//  Copyright © 2018 satvik borra. All rights reserved.
//

import UIKit

class Label : UILabel {
    
    var outFrame : CGRect!;
    var inFrame : CGRect!;
    
    init(outFrame : CGRect, inFrame: CGRect) {
        self.outFrame = outFrame;
        self.inFrame = inFrame
        super.init(frame: outFrame)
        
        self.font = UIFont(name: "Helvetica", size: 20)
        self.textAlignment = .center
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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
