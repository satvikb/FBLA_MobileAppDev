//
//  QuestionFinishedView.swift
//  FBLA
//
//  Created by Satvik Borra on 9/29/18.
//  Copyright © 2018 satvik borra. All rights reserved.
//

import UIKit

// Delegate methods to handle view switching
protocol QuestionFinishedViewDelegate : class {
    func questionFinishedShareButton(text: String)
    func questionFinishedNextQuestionButton()
    func questionFinishedHomeButton()
}

// This view is shown when an answer choice is selected
class QuestionFinishedView : View {
 
    weak var delegate : QuestionFinishedViewDelegate?
    
    // UI variables to show information
    var answerStreakLabel : Label!
    var actualAnswerLabel : Label!
    var scoreLabel : Label!
    var scoreChangeLabel : Label!
    
    // Button variables for each action
    var homeButton : Button!
    var shareButton : Button!
    var nextQuestionButton : Button!
    
    // Variables to show a checkmark or an X based on answer
    var selectionShapeLayer : CAShapeLayer!
    var checkmarkPath : UIBezierPath!
    var xPath : UIBezierPath!
    
    // Keep track of the share text when the share button is pressed.
    var shareText : String = ""
    
    var outFrame : CGRect!
    var inFrame : CGRect!
    
    init(outFrame : CGRect, inFrame: CGRect) {
        self.outFrame = outFrame
        self.inFrame = inFrame
        
        super.init(frame: outFrame)
        
        self.backgroundColor = UIColor.white
        self.layer.borderWidth = 3
        self.layer.cornerRadius = self.frame.width/10
        
        // Create the labels with blank text
        let answerStreakLabelFrame = propToRect(prop: CGRect(x: 0.1, y: 0.5, width: 0.8, height: 0.1), frame: self.frame)
        answerStreakLabel = Label(outFrame: answerStreakLabelFrame, inFrame: answerStreakLabelFrame, text: "", textColor: UIColor.white, valign: .Default, _insets: false)
        answerStreakLabel.textAlignment = .center
        answerStreakLabel.font = UIFont(name: "SFProText-Light", size: fontSize(propFontSize: 23))
        self.addSubview(answerStreakLabel)
        
        let actualAnswerLabelFrame = propToRect(prop: CGRect(x: 0.1, y: 0, width: 0.8, height: 0.2), frame: self.frame)
        actualAnswerLabel = Label(outFrame: actualAnswerLabelFrame, inFrame: actualAnswerLabelFrame, text: "", textColor: UIColor.white, valign: .Default, _insets: false)
        actualAnswerLabel.textAlignment = .center
        actualAnswerLabel.numberOfLines = 5
        actualAnswerLabel.font = UIFont(name: "SFProText-Light", size: fontSize(propFontSize: 23))

        self.addSubview(actualAnswerLabel)
        
        let scoreChangeLabelFrame = propToRect(prop: CGRect(x: 0.1, y: 0.575, width: 0.8, height: 0.15), frame: self.frame)
        scoreChangeLabel = Label(outFrame: scoreChangeLabelFrame, inFrame: scoreChangeLabelFrame, text: "", textColor: UIColor.white, valign: .Default, _insets: false)
        scoreChangeLabel.textAlignment = .center
        scoreChangeLabel.font = UIFont(name: "SFProText-Light", size: fontSize(propFontSize: 40))
        self.addSubview(scoreChangeLabel)
        
        let scoreLabelFrame = propToRect(prop: CGRect(x: 0.1, y: 0.68, width: 0.8, height: 0.15), frame: self.frame)
        scoreLabel = Label(outFrame: scoreLabelFrame, inFrame: scoreLabelFrame, text: "{Score}", textColor: UIColor.white, valign: .Default, _insets: false)
        scoreLabel.textAlignment = .center
        scoreLabel.font = UIFont(name: "SFProText-Light", size: fontSize(propFontSize: 40))
        self.addSubview(scoreLabel)
        
        // Create buttons with appropriate functions
        let nextQuestionButtonFrame = propToRect(prop: CGRect(x: 0.65, y: 0.85, width: 0.2, height: 0.1), frame: self.frame)
        nextQuestionButton = Button(outFrame: nextQuestionButtonFrame, inFrame: nextQuestionButtonFrame, text: "", _insets: false, imageURL: "next.png")
        nextQuestionButton.backgroundColor = UIColor.clear
        nextQuestionButton.pressed = {
            self.delegate?.questionFinishedNextQuestionButton()
        }
        self.addSubview(nextQuestionButton)
        
        let homeButtonFrame = propToRect(prop: CGRect(x: 0.15, y: 0.85, width: 0.2, height: 0.1), frame: self.frame)
        homeButton = Button(outFrame: homeButtonFrame, inFrame: homeButtonFrame, text: "", _insets: false, imageURL: "home.png")
        homeButton.backgroundColor = UIColor.clear
        homeButton.pressed = {
            self.delegate?.questionFinishedHomeButton()
        }
        self.addSubview(homeButton)
        
        let shareButtonFrame = propToRect(prop: CGRect(x: 0.4, y: 0.85, width: 0.2, height: 0.1), frame: self.frame)
        shareButton = Button(outFrame: shareButtonFrame, inFrame: shareButtonFrame, text: "", _insets: false, imageURL: "share.png")
        shareButton.backgroundColor = UIColor.clear
        shareButton.pressed = {
            self.delegate?.questionFinishedShareButton(text: self.shareText)
        }
        self.addSubview(shareButton)
        
        // Create the paths for the checkmark and the X
        checkmarkPath = UIBezierPath()
        checkmarkPath.move(to: p(0.3, 0.35))
        checkmarkPath.addLine(to: p(0.45, 0.45))
        checkmarkPath.addLine(to: p(0.7, 0.25))
        
        
        xPath = UIBezierPath()
        xPath.move(to: p(0.3, 0.45))
        xPath.addLine(to: p(0.7, 0.25))
        xPath.move(to: p(0.3, 0.25))
        xPath.addLine(to: p(0.7, 0.45))
        
        // Layer to display checkmark or X
        selectionShapeLayer = CAShapeLayer()
        selectionShapeLayer.frame = propToRect(prop: CGRect(x: 0, y: 0, width: 0.4, height: 0.4), frame: self.frame)
        selectionShapeLayer.path = xPath.cgPath
        selectionShapeLayer.strokeColor = UIColor.white.cgColor
        selectionShapeLayer.fillColor = UIColor.clear.cgColor
        selectionShapeLayer.lineWidth = 10
        selectionShapeLayer.lineCap = .square
        self.layer.addSublayer(selectionShapeLayer)
        
    }
    
    // Helper function to translate proportional points to screen coordinates
    func p(_ propX: CGFloat, _ propY: CGFloat) -> CGPoint{
        return CGPoint(x: propX * self.inFrame.size.width, y: propY * self.inFrame.size.height)
    }
    
    // Update the labels with correct information after every question is answered
    func updateUI(didAnswerCorrectly : Bool, answerStreak : Int, score: Int, scoreChanged: Int, actualAnswer : String = ""){
        shareText = "I got \(score) on BizQuiz! See if you can beat my score!"
        if(answerStreak > 0){
            answerStreakLabel.text = didAnswerCorrectly ? "Answer streak: \(answerStreak)" : ""
        }
        actualAnswerLabel.text = didAnswerCorrectly ? "" : "Correct Answer: \n \(actualAnswer)"
        scoreLabel.text = "\(score)"
        scoreChangeLabel.text = didAnswerCorrectly ? "+\(scoreChanged)" : ""
        self.backgroundColor = didAnswerCorrectly ? UIColor(red: 38/255, green: 166/255, blue: 91/255, alpha: 1) : UIColor(red: 1, green: 0.412, blue: 0.38, alpha: 1)
        
        selectionShapeLayer.path = didAnswerCorrectly ? checkmarkPath.cgPath : xPath.cgPath

    }
    
    // Animation functions
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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
