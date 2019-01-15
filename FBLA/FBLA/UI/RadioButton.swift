//
//  RadioButton.swift
//  FBLA
//
//  Created by Satvik Borra on 9/28/18.
//  Copyright © 2018 satvik borra. All rights reserved.
//

import UIKit

// Circular button used in TopicScrollViewCell
class RadioButton : Button {
    
    var enabled : Bool! = false
    
    var checkmarkPath : UIBezierPath!
    var xPath : UIBezierPath!

    var selectionShapeLayer : CAShapeLayer!
    
    init(outPos: CGPoint, inPos: CGPoint, radius : CGFloat, text: String, enabled : Bool = false) {
        let size = CGSize(width: radius*2, height: radius*2)
        
        let outFrame = CGRect(origin: outPos, size: size)
        let inFrame = CGRect(origin: inPos, size: size)

        super.init(outFrame: outFrame, inFrame: inFrame, text: text)
        
        self.outFrame = outFrame
        self.inFrame = inFrame
        self.enabled = enabled
        
        self.layer.cornerRadius = self.frame.size.width/2

        // Create checkmark and X path and the shape to display it based on the enabled state
        checkmarkPath = UIBezierPath()
        checkmarkPath.move(to: p(0.3, 0.55))
        checkmarkPath.addLine(to: p(0.4, 0.65))
        checkmarkPath.addLine(to: p(0.7, 0.3))

        xPath = UIBezierPath()
        xPath.move(to: p(0.3, 0.7))
        xPath.addLine(to: p(0.7, 0.3))
        xPath.move(to: p(0.3, 0.3))
        xPath.addLine(to: p(0.7, 0.7))
        
        selectionShapeLayer = CAShapeLayer()
        selectionShapeLayer.frame = CGRect(origin: CGPoint.zero, size: self.inFrame.size)
        selectionShapeLayer.path = xPath.cgPath
        selectionShapeLayer.strokeColor = UIColor.black.cgColor
        selectionShapeLayer.fillColor = UIColor.clear.cgColor
        selectionShapeLayer.lineWidth = 3
        selectionShapeLayer.lineCap = .square
        self.layer.addSublayer(selectionShapeLayer)
        
        updateUIForSelection()
        
        self.layer.borderWidth = 2
        self.layer.backgroundColor = UIColor.clear.cgColor
    }
    
    func p(_ propX: CGFloat, _ propY: CGFloat) -> CGPoint{
        return CGPoint(x: propX * self.inFrame.size.width, y: propY * self.inFrame.size.height)
    }
    
    // Handle button pressing
    override func buttonPressed() {
        enabled = !enabled
        
        updateUIForSelection()
        
        pressed()
    }

    // Update UI
    func updateUIForSelection(){
        if(enabled){
            selectionShapeLayer.path = checkmarkPath.cgPath
        }else{
            selectionShapeLayer.path = UIBezierPath().cgPath
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
