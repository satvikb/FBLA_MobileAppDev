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
//    var selectedButton : RadioButton!;
    var choiceTextLabel : Label!;
    
    var choice : QuestionChoice!
    var choiceId : Int!
    
    var outFrame : CGRect!;
    var inFrame : CGRect!;
    
    var selected : Bool = false
    
    init(outFrame: CGRect, inFrame: CGRect, choice : QuestionChoice, choiceId : Int, selected : Bool = true) {
        self.outFrame = outFrame
        self.inFrame = inFrame
        
        super.init(frame: outFrame)
        
        self.choice = choice
        self.choiceId = choiceId
        
        //actually button diameter
//        let buttonRadius = propToFloat(prop: 0.75, by: self.frame.size.height)
//        selectedButton = RadioButton(outPos: propToPoint(prop: CGPoint(x: 0.05, y: 0.25), size: self.frame.size), inPos: propToPoint(prop: CGPoint(x: 0.05, y: 0.25), size: self.frame.size), radius: buttonRadius, text: "", enabled: selected)
//        selectedButton.pressed = {
//            self.delegate?.selectionChange(choiceView: self, selected: self.selectedButton.enabled)
//        }
//        self.addSubview(selectedButton)
        
        let initialFrame = propToRect(prop: CGRect(x: 0.05, y: 0, width: 0.9, height: 1), frame: self.frame)
        
        choiceTextLabel = Label(outFrame: CGRect(x: initialFrame.origin.x, y: initialFrame.origin.y, width: initialFrame.size.width, height: initialFrame.size.height), inFrame: propToRect(prop: CGRect(x: 0, y: 0, width: 1, height: 1), frame: self.frame), text: choice.choiceValue, textColor: UIColor.black, valign: .Default, _insets: false)
        choiceTextLabel.adjustsFontSizeToFitWidth = true
        choiceTextLabel.numberOfLines = 10
//        choiceTextLabel.layer.borderWidth = 3
        
        self.addSubview(choiceTextLabel)
        
        self.layer.borderColor = UIColor.green.cgColor
        self.layer.borderWidth = 3
    }
    
    
    //Handle touching in the view but not the button
    var touchDown : Bool = false
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchDown = true;
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(touchDown){
//            selectedButton.buttonPressed()
            selected = true
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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
