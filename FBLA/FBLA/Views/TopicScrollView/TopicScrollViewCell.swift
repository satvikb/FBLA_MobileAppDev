//
//  TopicScrollViewCell.swift
//  FBLA
//
//  Created by Satvik Borra on 9/28/18.
//  Copyright © 2018 satvik borra. All rights reserved.
//

import UIKit

class TopicScrollViewCell : UIView {
    
    var topicInfo : TopicInfo!
    
    var selectedButton : RadioButton!;
    var topicText : Label!;
    var questionCount : Label!;
    
    init(frame: CGRect, topicInfo : TopicInfo, selected : Bool = true) {
        super.init(frame: frame)
        self.topicInfo = topicInfo
        
        selectedButton = RadioButton(outPos: propToPoint(prop: CGPoint(x: 0.05, y: 0.25), size: self.frame.size), inPos: propToPoint(prop: CGPoint(x: 0.05, y: 0.25), size: self.frame.size), radius: propToFloat(prop: 0.5, by: self.frame.size.height), text: "", enabled: selected)
        selectedButton.pressed = {
            print("Pressed")
        }
        self.addSubview(selectedButton)
        
        topicText = Label(outFrame: propToRect(prop: CGRect(x: 0.2, y: 0, width: 0.6, height: 1), frame: self.frame), inFrame: propToRect(prop: CGRect(x: 0.3, y: 0, width: 0.5, height: 1), frame: self.frame))
        topicText.text = topicInfo.topicName
        
        topicText.layer.borderWidth = 3
        
        self.addSubview(topicText)
        
        
        questionCount = Label(outFrame: propToRect(prop: CGRect(x: 0.8, y: 0, width: 0.2, height: 1), frame: self.frame), inFrame: propToRect(prop: CGRect(x: 0.8, y: 0, width: 0.2, height: 1), frame: self.frame))
        questionCount.text = "\(topicInfo.questionsComplete) / \(topicInfo.topicQuestions)"
        questionCount.textColor = UIColor.red
        self.addSubview(questionCount)
        
        
        
        self.layer.borderColor = UIColor.green.cgColor
        self.layer.borderWidth = 3
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
