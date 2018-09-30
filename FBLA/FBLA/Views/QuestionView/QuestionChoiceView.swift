//
//  QuestionChoiceView.swift
//  FBLA
//
//  Created by Satvik Borra on 9/28/18.
//  Copyright © 2018 satvik borra. All rights reserved.
//

import UIKit

protocol QuestionChoiceViewDelegate : class {
    func selectionChange(choiceView : QuestionChoiceView, selected : Bool)
}

class QuestionChoiceView : UIView {
    
    weak var delegate : QuestionChoiceViewDelegate?
    var selectedButton : RadioButton!;
    var choiceTextLabel : Label!;
    
    var choice : QuestionChoice!
    var choiceId : Int!
    
    var outFrame : CGRect!;
    var inFrame : CGRect!;
    
    init(outFrame: CGRect, inFrame: CGRect, choice : QuestionChoice, choiceId : Int, selected : Bool = true) {
        self.outFrame = outFrame
        self.inFrame = inFrame
        
        super.init(frame: outFrame)
        
        self.choice = choice
        self.choiceId = choiceId
        
        selectedButton = RadioButton(outPos: propToPoint(prop: CGPoint(x: 0.05, y: 0.25), size: self.frame.size), inPos: propToPoint(prop: CGPoint(x: 0.05, y: 0.25), size: self.frame.size), radius: propToFloat(prop: 0.5, by: self.frame.size.height), text: "", enabled: selected)
        selectedButton.pressed = {
            print("Pressed")
            self.delegate?.selectionChange(choiceView: self, selected: self.selectedButton.enabled)
        }
        self.addSubview(selectedButton)
        
        choiceTextLabel = Label(outFrame: propToRect(prop: CGRect(x: 0.15, y: 0, width: 0.85, height: 1), frame: self.frame), inFrame: propToRect(prop: CGRect(x: 0.3, y: 0, width: 0.5, height: 1), frame: self.frame), text: choice.choiceValue, textColor: UIColor.black, valign: .Default, _insets: false)
        
//        choiceTextLabel.layer.borderWidth = 3
        
        self.addSubview(choiceTextLabel)
        
        self.layer.borderColor = UIColor.green.cgColor
        self.layer.borderWidth = 3
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
