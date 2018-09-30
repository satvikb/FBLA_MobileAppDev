//
//  RadioButton.swift
//  FBLA
//
//  Created by Satvik Borra on 9/28/18.
//  Copyright © 2018 satvik borra. All rights reserved.
//

import UIKit

class RadioButton : Button {
    
    var enabled : Bool! = false
    
    init(outPos: CGPoint, inPos: CGPoint, radius : CGFloat, text: String, enabled : Bool = false) {
        let size = CGSize(width: radius, height: radius)
        
        let outFrame = CGRect(origin: outPos, size: size)
        let inFrame = CGRect(origin: inPos, size: size)
        //TODO force box sizes
        super.init(outFrame: outFrame, inFrame: inFrame, text: text)
        
        self.outFrame = outFrame
        self.inFrame = inFrame
        self.enabled = enabled
        
        self.layer.cornerRadius = self.frame.size.width/2
        
        self.layer.borderWidth = 3
        self.layer.borderColor = UIColor.black.cgColor
        
        updateUIForSelection()
    }
    
    override func buttonPressed() {
        enabled = !enabled
        
        updateUIForSelection()
        
        pressed()
    }
    
    func updateUIForSelection(){
        //TODO animate
        if(enabled){
            self.layer.backgroundColor = UIColor.green.cgColor
        }else{
            self.layer.backgroundColor = UIColor.red.cgColor
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
