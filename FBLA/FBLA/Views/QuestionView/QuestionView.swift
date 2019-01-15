//
//  QuestionView.swift
//  FBLA
//
//  Created by Satvik Borra on 9/28/18.
//  Copyright © 2018 satvik borra. All rights reserved.
//

import UIKit

// Delegate for ViewController to switch views
protocol QuestionViewDelegate : class {
    func submitButtonPressed(correctAnswer: Bool, scoreReceived: Int, correctAnswerText: String)
}

// This view handles showing the question and question choices
class QuestionView : View {
   
    weak var delegate : QuestionViewDelegate?
    
    var timerFrameSize : CGSize!
    var timerBar : UIView!
    var displayLink : CADisplayLink!
    var timer : CGFloat = 0
    let timeToAnswerEachQuestion : CGFloat = 15
    
    var questionView : UIView!
    var questionTextLabel : Label!
    
    var questionFrame : CGRect!
    var questionFrameOut : CGRect!
    
    var questionTextLabelShadowView : CAShapeLayer!
    
    var choiceViews : [QuestionChoiceView] = []
    
    var question : Question!
    

    init(frame: CGRect, question : Question) {
        super.init(frame: frame)
        
        self.question = question
        
        questionFrame = propToRect(prop: CGRect(x: 0.05, y: 0.075, width: 0.9, height: 0.20), frame: self.frame)
        questionFrameOut = propToRect(prop: CGRect(x: 0.05, y: -0.5, width: 0.9, height: 0.20), frame: self.frame)
        
        // Programatically create the choice views
        if(question.choices.keys.count > 0){
            var choices : [QuestionChoice] = []
            // Get choice values
            for (choiceName, choiceValue) in question.choices {
                var isCorrectAnswer : Bool = false
                if(choiceName == question.correctAnswer){
                    isCorrectAnswer = true
                }

                let choice = QuestionChoice(choiceValue: choiceValue, correctAnswer: isCorrectAnswer)
                choices.append(choice)
            }
            
            // Randomize order
            choices.shuffle()
            
            // Create views
            var i : Int = 0
            let cellHeight : CGFloat = 0.145
            let verticalPadding : CGFloat = 0.02375
            let topOffset : CGFloat = 0.3
            
            for choice in choices {
                let choiceViewOutFrame = propToRect(prop: CGRect(x: i%2 == 0 ? -1 : 1, y: topOffset + (cellHeight+verticalPadding) * CGFloat(i), width: 1, height: cellHeight), frame: self.frame)

                let choiceViewInFrame = propToRect(prop: CGRect(x: 0.05, y: topOffset + (cellHeight+verticalPadding) * CGFloat(i), width: 0.9, height: cellHeight), frame: self.frame)
                let choiceView = QuestionChoiceView(outFrame: choiceViewOutFrame, inFrame: choiceViewInFrame, choice: choice, choiceId: i)
                choiceView.pressed = {
                    // Submit the answer when pressed
                    self.submitAnswer()
                }
                // Keep track of the view
                choiceViews.append(choiceView)
                self.addSubview(choiceView)
                i += 1
            }
        }
        
        
        // Create the question label and put it under another view to allow for a shadow effect
        questionView = UIView(frame: questionFrameOut)
        let questionTextLabelFrame = CGRect(origin: CGPoint.zero, size: questionFrameOut.size)
        questionTextLabel = Label(outFrame: questionTextLabelFrame, inFrame: questionTextLabelFrame, text: question.question, textColor: UIColor.black, valign: .Default, _insets: true)
        questionTextLabel.textAlignment = .center
        questionTextLabel.layer.cornerRadius = questionTextLabel.frame.height/10
        questionTextLabel.font = UIFont(name: "SFProText-Light", size: fontSize(propFontSize: 60))
        questionTextLabel.backgroundColor = UIColor.clear
        questionTextLabel.numberOfLines = 10
        questionView.addSubview(questionTextLabel)
        self.addSubview(questionView)

        // Create the display link to create a timer
        displayLink = CADisplayLink(target: self, selector: #selector(update))
        if #available(iOS 10.0, *) {
            displayLink.preferredFramesPerSecond = 60
        } else {
            // Fallback on earlier versions
            displayLink.frameInterval = 1
        }
        displayLink.add(to: RunLoop.main, forMode: .common)
        
        // Create the timer bar
        timerBar = UIView(frame: propToRect(prop: CGRect(x: 0, y: 0, width: 1, height: 0.05), frame: self.frame))
        timerFrameSize = timerBar.frame.size
        timerBar.backgroundColor = UIColor.green
        self.addSubview(timerBar)
    
    }
    
    // Called every frame to keep track of the time passed. Used to calculate score and if time ran out
    @objc func update(){
        if(displayLink != nil){
            timer += CGFloat(displayLink.duration)
            
            // Game over if time ran out
            if(timer >= timeToAnswerEachQuestion){
                submitAnswer()
            }
            
            // Animate the timer bar
            timerBar.frame = CGRect(origin: timerBar.frame.origin, size: CGSize(width: timerFrameSize.width*(1.0-(timer / timeToAnswerEachQuestion)), height: timerBar.frame.height))
        }
    }
    
    // Stop the CADisplayLink to prevent extra run loops
    func destroy() {
        if(displayLink != nil){
            displayLink.remove(from: RunLoop.main, forMode: .default)
            displayLink = nil
        }
    }
    
    // Create the shadow effect
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if questionTextLabelShadowView == nil {
            questionTextLabelShadowView = CAShapeLayer()
            questionTextLabelShadowView.path = UIBezierPath(roundedRect: questionTextLabel.frame, cornerRadius: questionTextLabel.layer.cornerRadius).cgPath
            questionTextLabelShadowView.fillColor = UIColor.white.cgColor
            
            questionTextLabelShadowView.shadowColor = UIColor.darkGray.cgColor
            questionTextLabelShadowView.shadowPath = questionTextLabelShadowView.path
            questionTextLabelShadowView.shadowOffset = CGSize(width: 2.0, height: 2.0)
            questionTextLabelShadowView.shadowOpacity = 0.8
            questionTextLabelShadowView.shadowRadius = 2
            questionView.layer.insertSublayer(questionTextLabelShadowView, below: nil)
        }
    }
    
    func submitAnswer(){
        destroy()
        let score : Int = Int((1.0-(timer / timeToAnswerEachQuestion))*1000)
        self.delegate?.submitButtonPressed(correctAnswer: score <= 0 ? false : self.testIfCurrentlySelectedIsAnswer(), scoreReceived: score, correctAnswerText: self.getCorrectAnswerText())
    }
    
    // Test if the right answer was selected
    private func testIfCurrentlySelectedIsAnswer() -> Bool{
        for view in choiceViews {
            if view.selected == true {
                return view.choice!.correctAnswer
            }
        }
        return false
    }

    // Get the text for the correct answer for the next view, if needed
    func getCorrectAnswerText() -> String{
        for view in choiceViews {
            if view.choice.correctAnswer == true {
                return view.choice!.choiceValue
            }
        }
        return ""
    }
   
    // Animation functions
    override func animateIn(completion: @escaping () -> Void) {
        for choiceView in choiceViews {
            choiceView.animateIn()
        }
        
        UIView.animate(withDuration: TimeInterval(transitionTime), animations: {
            self.questionView.frame = self.questionFrame
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(transitionTime), execute: {
            completion()
        })
    }
    
    override func animateOut(completion: @escaping () -> Void) {

        for choiceView in choiceViews {
            choiceView.animateOut()
        }
        
        UIView.animate(withDuration: TimeInterval(transitionTime), animations: {
            self.questionView.frame = self.questionFrameOut
        })

        DispatchQueue.main.asyncAfter(deadline: .now() + Double(transitionTime), execute: {
            completion()
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
