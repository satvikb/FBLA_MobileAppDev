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
    
    var selectedButton : RadioButton!
    var selectedText : Label!
    var topicText : Label!
    var questionCount : Label!
    
    var topicLogoView : UIImageView!
    
    var shadowLayer: CAShapeLayer!

    init(frame: CGRect, topicInfo : TopicInfo, selected : Bool = true) {
        super.init(frame: frame)
        self.topicInfo = topicInfo
        
        //Initialize all of the views.
        
        // Center the selection button.
        let selectedButtonRadius = propToFloat(prop: 0.1, by: self.frame.size.height)
        let selectedButtonPoint = propToPoint(prop: CGPoint(x: 0.6, y: 0.75), size: self.frame.size)
        let selectedButtonVerticalPadding = self.frame.height - selectedButtonPoint.y - (selectedButtonRadius*2)
        let selectedButtonPointCentered = CGPoint(x: self.frame.width-(selectedButtonRadius*2)-selectedButtonVerticalPadding, y: selectedButtonPoint.y)
        selectedButton = RadioButton(outPos: selectedButtonPointCentered, inPos: selectedButtonPointCentered, radius: selectedButtonRadius, text: "", enabled: selected)
        selectedButton.pressed = {

        }
        self.addSubview(selectedButton)
        
        topicText = Label(outFrame: propToRect(prop: CGRect(x: 0, y: 0, width: 1, height: 0.2), frame: self.frame), inFrame: propToRect(prop: CGRect(x: 0.3, y: 0, width: 0.5, height: 1), frame: self.frame))
        topicText.text = topicInfo.topicName
        topicText.font = UIFont(name: "SFProText-Light", size: fontSize(propFontSize: 25))
//        topicText.layer.borderWidth = 3
        topicText.textAlignment = .center
        self.addSubview(topicText)
        
        selectedText = Label(outFrame: propToRect(prop: CGRect(x: 0, y: 0.75, width: 0.5, height: 0.1), frame: self.frame), inFrame: propToRect(prop: CGRect(x: 0, y: 0.75, width: 0.5, height: 0.1), frame: self.frame))
        selectedText.text = "Completed"
        selectedText.font = UIFont(name: "SFProText-Light", size: fontSize(propFontSize: 20))
//        selectedText.layer.borderWidth = 3
        selectedText.textAlignment = .center
        self.addSubview(selectedText)
        
        questionCount = Label(outFrame: propToRect(prop: CGRect(x: 0, y: 0.8, width: 0.5, height: 0.2), frame: self.frame), inFrame: propToRect(prop: CGRect(x: 0, y: 0.8, width: 0.5, height: 0.2), frame: self.frame))
        questionCount.text = "\(topicInfo.questionsComplete) / \(topicInfo.topicQuestions)"
        questionCount.textColor = UIColor.black
        questionCount.textAlignment = .center

        self.addSubview(questionCount)
        
        
        topicLogoView = UIImageView(frame: propToRect(prop: CGRect(x: 0.1, y: 0.225, width: 0.8, height: 0.5), frame: self.frame))
//        topicLogoView.layer.borderWidth = 3
        topicLogoView.image = UIImage(named: topicInfo.logoURL)
        topicLogoView.contentMode = .scaleAspectFit
        self.addSubview(topicLogoView)
        
        self.layer.borderColor = self.backgroundColor?.darker(by: 10)?.cgColor
//        self.layer.borderWidth = 1
        self.layer.cornerRadius = self.frame.height/10
    }
    
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
            
            //            layer.insertSublayer(shadowLayer, at: 0)
//            layer.insertSublayer(shadowLayer, below: nil) // also works
        }
    }
    
    //Handle touching in the view but not the button
    var touchDown : Bool = false
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchDown = true
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(touchDown){
            selectedButton.buttonPressed()
            touchDown = false
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
