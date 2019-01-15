//
//  AllQuestionsCompleteView.swift
//  FBLA
//
//  Created by Satvik Borra on 10/1/18.
//  Copyright © 2018 satvik borra. All rights reserved.
//

import UIKit

protocol AllQuestionsCompleteViewDelegate : class {
    func allQuestionsCompleteHomeButton()
}

class AllQuestionsCompleteView : View {
    
    weak var delegate : AllQuestionsCompleteViewDelegate?
    var infoLabel : Label!
    var resultShape : CAShapeLayer! //TODO
    var answerStreakLabel : Label!
    var actualAnswerLabel : Label!
    
    var scoreLabel : Label!

    //TODO: make these images?
    var nextQuestionButton : Button!
    var homeButton : Button!
    
    var outFrame : CGRect!
    var inFrame : CGRect!
    
    init(outFrame : CGRect, inFrame: CGRect) {
        self.outFrame = outFrame
        self.inFrame = inFrame
        
        super.init(frame: outFrame)
        
        self.backgroundColor = UIColor(red: 43/255, green: 43/255, blue: 43/255, alpha: 1)
        self.layer.borderWidth = 3
        self.layer.cornerRadius = self.frame.width/10
        
        let infoLabelFrame = propToRect(prop: CGRect(x: 0.1, y: 0.1, width: 0.8, height: 0.5), frame: self.frame)
        infoLabel = Label(outFrame: infoLabelFrame, inFrame: infoLabelFrame, text: "All Questions have been answered. Please return to the settings page to reset progress if needed.", textColor: UIColor.white, valign: .Default, _insets: false)
        infoLabel.textAlignment = .center
        infoLabel.numberOfLines = 3
        self.addSubview(infoLabel)

        let homeButtonFrame = propToRect(prop: CGRect(x: 0.05, y: 0.7, width: 0.9, height: 0.2), frame: self.frame)
        homeButton = Button(outFrame: homeButtonFrame, inFrame: homeButtonFrame, text: "", _insets: false, imageURL: "home.png")
        homeButton.pressed = {
            self.delegate?.allQuestionsCompleteHomeButton()
        }
        homeButton.backgroundColor = UIColor.clear
        self.addSubview(homeButton)
        
        let scoreLabelFrame = propToRect(prop: CGRect(x: 0.1, y: 0.5, width: 0.8, height: 0.15), frame: self.frame)
        scoreLabel = Label(outFrame: scoreLabelFrame, inFrame: scoreLabelFrame, text: "", textColor: UIColor.white, valign: .Default, _insets: false)
        scoreLabel.textAlignment = .center
        scoreLabel.font = UIFont(name: "SFProText-Light", size: fontSize(propFontSize: 40))
        self.addSubview(scoreLabel)
    }
    
    func updateUI(score: Int){
        scoreLabel.text = "Final Score: \(score)"
    }

    override func animateIn(completion: @escaping () -> Void) {
        UIView.animate(withDuration: TimeInterval(transitionTime), animations: {
            self.frame = self.inFrame
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(transitionTime), execute: {
            completion()
        })
    }
    
    override func animateOut(completion: @escaping () -> Void) {
        UIView.animate(withDuration: TimeInterval(transitionTime), animations: {
            self.frame = self.outFrame
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(transitionTime), execute: {
            completion()
        })
    }
    //    func animateIn(time: CGFloat = transitionTime) {
    //        UIView.animate(withDuration: TimeInterval(time), animations: {
    //            self.frame = self.inFrame
    //        })
    //    }
    //
    //    func animateOut(time: CGFloat = transitionTime){
    //        UIView.animate(withDuration: TimeInterval(time), animations: {
    //            self.frame = self.outFrame
    //        })
    //    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
