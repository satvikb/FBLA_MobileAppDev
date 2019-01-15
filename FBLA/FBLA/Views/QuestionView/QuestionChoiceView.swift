//
//  QuestionChoiceView.swift
//  FBLA
//
//  Created by Satvik Borra on 9/28/18.
//  Copyright © 2018 satvik borra. All rights reserved.
//

import UIKit

// The view for the individual choice view
class QuestionChoiceView : UIView {
    
    var choiceTextLabel : Label!
    
    var choice : QuestionChoice!
    var choiceId : Int!
    
    var outFrame : CGRect!
    var inFrame : CGRect!
    
    var selected : Bool = false
    
    var pressed = {}
    
    var shadowLayer: CAShapeLayer!
    
    // Initialize the view with position and question choice information
    init(outFrame: CGRect, inFrame: CGRect, choice : QuestionChoice, choiceId : Int) {
        self.outFrame = outFrame
        self.inFrame = inFrame
        
        super.init(frame: outFrame)
        
        self.choice = choice
        self.choiceId = choiceId
        
        // Create the frame for the label
        let initialFrame = propToRect(prop: CGRect(x: 0.05, y: 0, width: 0.85, height: 1), frame: self.frame)
        
        // Create the label text
        choiceTextLabel = Label(outFrame: initialFrame, inFrame: initialFrame, text: choice.choiceValue, textColor: UIColor.white, valign: .Default, _insets: false)
        choiceTextLabel.adjustsFontSizeToFitWidth = true
        choiceTextLabel.numberOfLines = 10
        choiceTextLabel.font = UIFont(name: "SFProText-Light", size: fontSize(propFontSize: 30))
        
        self.addSubview(choiceTextLabel)

        // Set the background color for each view
        switch self.choiceId{
        case 0:
            self.backgroundColor = UIColor(red: 0.5, green: 0.75, blue: 0.86, alpha: 1)
            break
        case 1:
            self.backgroundColor = UIColor(red: 1, green: 0.34, blue: 0.51, alpha: 1)
            break
        case 2:
            self.backgroundColor = UIColor(red: 1, green: 0.62, blue: 0.34, alpha: 1)
            break
        case 3:
            self.backgroundColor = UIColor(red: 0.34, green: 1, blue: 0.67, alpha: 1).darker(by: 30)
            break
        default:
            self.backgroundColor = UIColor.clear
        }
        
        // Make the view have rounded corners
        self.layer.cornerRadius = self.frame.size.height/10
    }
    
    // Create the shadow effect for the question choice
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if shadowLayer == nil {
            shadowLayer = CAShapeLayer()
            shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: self.layer.cornerRadius).cgPath
            shadowLayer.fillColor = self.backgroundColor?.cgColor
            
            shadowLayer.shadowColor = UIColor.darkGray.cgColor
            shadowLayer.shadowPath = shadowLayer.path
            shadowLayer.shadowOffset = CGSize(width: 2.0, height: 2.0)
            shadowLayer.shadowOpacity = 0.8
            shadowLayer.shadowRadius = 2
            
            layer.insertSublayer(shadowLayer, below: nil)
        }
    }
    
    //Handle touching in the view but not the button
    var touchDown : Bool = false
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchDown = true
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(touchDown){
            // Keep track of a touch down
            selected = true
            touchDown = false
            self.pressed()
        }
    }
    
    // Animation functions
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
