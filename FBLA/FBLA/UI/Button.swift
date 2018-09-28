//
//  Button.swift
//  FBLA
//
//  Created by Satvik Borra on 9/27/18.
//  Copyright © 2018 satvik borra. All rights reserved.
//

import UIKit

class Button : UIView {
    
    var touchDown : Bool = false;
    var pressed = {}
    var label : UILabel!;
    
    var outFrame : CGRect!;
    var inFrame : CGRect!;
    
    init(outFrame : CGRect, inFrame: CGRect, text: String = "") {
        self.outFrame = outFrame
        self.inFrame = inFrame
        
        super.init(frame: outFrame);
        
        let labelFrame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height);
        label = Label(outFrame: labelFrame, inFrame: labelFrame)
        label.text = text;
        label.textAlignment = .center;
        self.addSubview(label)
        
        self.backgroundColor = UIColor.blue;
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchDown = true;
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(touchDown){
            pressed();
            touchDown = false;
        }
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
