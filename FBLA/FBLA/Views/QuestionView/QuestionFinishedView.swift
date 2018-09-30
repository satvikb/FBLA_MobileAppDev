//
//  QuestionFinishedView.swift
//  FBLA
//
//  Created by Satvik Borra on 9/29/18.
//  Copyright © 2018 satvik borra. All rights reserved.
//

import UIKit

protocol QuestionFinishedViewDelegate : class {
    func nextQuestionButtonPressed()
    func homeButtonPressed()
}

class QuestionFinishedView : View {
 
    weak var delegate : QuestionFinishedViewDelegate?
    var resultLabel : Label!
    var resultShape : CAShapeLayer! //TODO
    var answerStreakLabel : Label!
    var actualAnswerLabel : Label!
    
    //TODO: make these images?
    var nextQuestionButton : Button!
    var homeButton : Button!
    
    var outFrame : CGRect!;
    var inFrame : CGRect!;
    
    init(outFrame : CGRect, inFrame: CGRect) {
        self.outFrame = outFrame
        self.inFrame = inFrame
        
        super.init(frame: outFrame);
        
        self.backgroundColor = UIColor.white
        self.layer.borderWidth = 3
        self.layer.cornerRadius = self.frame.width/10
        
        let resultLabelFrame = propToRect(prop: CGRect(x: 0.1, y: 0.1, width: 0.8, height: 0.2), frame: self.frame)
        resultLabel = Label(outFrame: resultLabelFrame, inFrame: resultLabelFrame, text: "RESULT", textColor: UIColor.black, valign: .Default, _insets: false)
        resultLabel.textAlignment = .center
        self.addSubview(resultLabel)
        
        let answerStreakLabelFrame = propToRect(prop: CGRect(x: 0.1, y: 0.5, width: 0.8, height: 0.2), frame: self.frame)
        answerStreakLabel = Label(outFrame: answerStreakLabelFrame, inFrame: answerStreakLabelFrame, text: "Answer Streak", textColor: UIColor.black, valign: .Default, _insets: false)
        answerStreakLabel.textAlignment = .center
        self.addSubview(answerStreakLabel)
        
        let actualAnswerLabelFrame = propToRect(prop: CGRect(x: 0.1, y: 0.3, width: 0.8, height: 0.2), frame: self.frame)
        actualAnswerLabel = Label(outFrame: actualAnswerLabelFrame, inFrame: actualAnswerLabelFrame, text: "{Actual}", textColor: UIColor.black, valign: .Default, _insets: false)
        actualAnswerLabel.textAlignment = .center
        self.addSubview(actualAnswerLabel)
        
        let nextQuestionButtonFrame = propToRect(prop: CGRect(x: 0.55, y: 0.7, width: 0.4, height: 0.2), frame: self.frame)
        nextQuestionButton = Button(outFrame: nextQuestionButtonFrame, inFrame: nextQuestionButtonFrame, text: "Next")
        nextQuestionButton.pressed = {
            self.delegate?.nextQuestionButtonPressed()
        }
        self.addSubview(nextQuestionButton)
        
        let homeButtonFrame = propToRect(prop: CGRect(x: 0.05, y: 0.7, width: 0.4, height: 0.2), frame: self.frame)
        homeButton = Button(outFrame: homeButtonFrame, inFrame: homeButtonFrame, text: "Home")
        homeButton.pressed = {
            self.delegate?.homeButtonPressed()
        }
        self.addSubview(homeButton)
    }
    
    func updateUI(didAnswerCorrectly : Bool, answerStreak : Int, actualAnswer : String = ""){
        
        resultLabel.text = didAnswerCorrectly == true ? "CORRECT" : "WRONG"
        answerStreakLabel.text = "Answer streak: \(answerStreak)"
        actualAnswerLabel.text = actualAnswer
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
