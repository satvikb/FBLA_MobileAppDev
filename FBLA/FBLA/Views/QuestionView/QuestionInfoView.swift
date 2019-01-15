//
//  QuestionInfoView.swift
//  FBLA
//
//  Created by Satvik Borra on 10/1/18.
//  Copyright © 2018 satvik borra. All rights reserved.
//

import UIKit

// This view is at the top of each question showing the current topic and question number
class QuestionInfoView : View {
    
    var questionTopicLabel : Label!
    var questionCounterLabel : Label!
    
    // Initialize the view with relevant data and create UI
    init(frame: CGRect, topicName : String, counterString : String) {
        super.init(frame: frame)
        
        let questionTopicLabelFrameOut = propToRect(prop: CGRect(x: 0, y: -1, width: 0.5, height: 1), frame: self.frame)
        let questionTopicLabelFrameIn = propToRect(prop: CGRect(x: 0.05, y: 0, width: 0.4, height: 1), frame: self.frame)

        questionTopicLabel = Label(outFrame: questionTopicLabelFrameOut, inFrame: questionTopicLabelFrameIn, text: topicName, textColor: UIColor.white, valign: .Default, _insets: false)
        questionTopicLabel.font = UIFont(name: "SFProText-Heavy", size: fontSize(propFontSize: 25))
        questionTopicLabel.textAlignment = .left
        self.addSubview(questionTopicLabel)
        
        
        let questionCounterLabelFrameOut = propToRect(prop: CGRect(x: 0.5, y: -1, width: 0.5, height: 1), frame: self.frame)
        let questionCounterLabelFrameIn = propToRect(prop: CGRect(x: 0.55, y: 0, width: 0.4, height: 1), frame: self.frame)
        
        questionCounterLabel = Label(outFrame: questionCounterLabelFrameOut, inFrame: questionCounterLabelFrameIn, text: counterString, textColor: UIColor.white, valign: .Default, _insets: false)
        questionCounterLabel.font = UIFont(name: "SFProText-Heavy", size: fontSize(propFontSize: 25))
        questionCounterLabel.textAlignment = .right
        self.addSubview(questionCounterLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Animation functions
    override func animateIn(completion: @escaping () -> Void) {
        questionTopicLabel.animateIn()
        questionCounterLabel.animateIn()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(transitionTime), execute: {
            completion()
        })
    }
    
    override func animateOut(completion: @escaping () -> Void) {
        questionTopicLabel.animateOut()
        questionCounterLabel.animateOut()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(transitionTime), execute: {
            completion()
        })
    }
    
}
