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
    
    var checkmarkPath : UIBezierPath!
    var xPath : UIBezierPath!

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
        
//        self.layer.borderWidth = 3
//        self.layer.borderColor = UIColor.black.cgColor
        updateUIForSelection()
        
        
        checkmarkPath = UIBezierPath()
//        checkmarkPath.move(to: p(0.3, 0.65))
//        checkmarkPath.addLine(to: p(0.7, 0.3))
//        checkmarkPath.addLine(to: p(0.5, 0.5))
//        checkmarkPath.addLine(to: p(0.3, 0.65))
//        checkmarkPath.addLine(to: p(0.1, 0.55))
//        checkmarkPath.addLine(to: p(0.7, 0.3))
//        checkmarkPath.addLine(to: p(0.5, 0.5))
//        checkmarkPath.addLine(to: p(0.3, 0.65))
        checkmarkPath.move(to: p(0.1, 0.55))
        checkmarkPath.addLine(to: p(0.3, 0.65))
        checkmarkPath.addLine(to: p(0.5, 0.5))
        checkmarkPath.addLine(to: p(0.7, 0.3))

        
        xPath = UIBezierPath()
        xPath.move(to: p(0.2, 0.7))
        xPath.addLine(to: p(0.7, 0.3))
//        xPath.addLine(to: p(0.5, 0.5))
        xPath.move(to: p(0.2, 0.3))
        xPath.addLine(to: p(0.7, 0.7))
        
        let testLayer = CAShapeLayer()
        testLayer.frame = CGRect(origin: CGPoint.zero, size: self.inFrame.size)
        testLayer.path = xPath.cgPath
        testLayer.strokeColor = UIColor.white.cgColor
        testLayer.fillColor = UIColor.clear.cgColor
        testLayer.lineWidth = 3
        testLayer.lineCap = .square
//        testLayer.
//        testLayer.borderWidth = 3
//        testLayer.borderColor = UIColor.red.cgColor
        self.layer.addSublayer(testLayer)
        
        
    }
    
    func p(_ propX: CGFloat, _ propY: CGFloat) -> CGPoint{
        return CGPoint(x: propX * self.inFrame.size.width, y: propY * self.inFrame.size.height)
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
