//
//  QuestionView.swift
//  FBLA
//
//  Created by Satvik Borra on 9/28/18.
//  Copyright © 2018 satvik borra. All rights reserved.
//

import UIKit



protocol QuestionViewDelegate : class {
    func submitButtonPressed(correctAnswer: Bool, scoreReceived: Int, correctAnswerText: String)
}

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
    var imageView : ImageView!
    
    var question : Question!
    

    init(frame: CGRect, question : Question) {
        super.init(frame: frame)
        
        self.question = question
        
        questionFrame = propToRect(prop: CGRect(x: 0.05, y: 0.075, width: 0.9, height: 0.20), frame: self.frame)
        questionFrameOut = propToRect(prop: CGRect(x: 0.05, y: -0.5, width: 0.9, height: 0.20), frame: self.frame)
        
//        var timerFrame : CGRect! = propToRect(prop: CGRect(x: 0.05, y: 0.1, width: 0.125, height: 0.125), frame: self.frame)
        
        if(question.choices.keys.count > 0){ //TODO or questionType == mc?
            var choices : [QuestionChoice] = []
            for (choiceName, choiceValue) in question.choices {
                var isCorrectAnswer : Bool = false
                if(choiceName == question.correctAnswer){
                    isCorrectAnswer = true
                }
                // TODO, ensure there is a correct value
                let choice = QuestionChoice(choiceValue: choiceValue, correctAnswer: isCorrectAnswer)
                choices.append(choice)
            }
            
            choices.shuffle()
            
            let hasImage = question.imageURL != ""
            
            var i : Int = 0
            let cellHeight : CGFloat = hasImage ? 0.115 : 0.145
            let verticalPadding : CGFloat = hasImage ? 0.014 : 0.02375
            let topOffset : CGFloat = hasImage ? 0.425 : 0.3
            
            for choice in choices {
                let choiceViewOutFrame = propToRect(prop: CGRect(x: i%2 == 0 ? -1 : 1, y: topOffset + (cellHeight+verticalPadding) * CGFloat(i), width: 1, height: cellHeight), frame: self.frame)

                let choiceViewInFrame = propToRect(prop: CGRect(x: 0.05, y: topOffset + (cellHeight+verticalPadding) * CGFloat(i), width: 0.9, height: cellHeight), frame: self.frame)
                let choiceView = QuestionChoiceView(outFrame: choiceViewOutFrame, inFrame: choiceViewInFrame, choice: choice, choiceId: i, selected: false)
                choiceView.pressed = {
                    self.submitAnswer()
                }
                choiceViews.append(choiceView)
                self.addSubview(choiceView)
                i += 1
            }
        }
        
        
        questionView = UIView(frame: questionFrameOut)
        
        let questionTextLabelFrame = CGRect(origin: CGPoint.zero, size: questionFrameOut.size)
        questionTextLabel = Label(outFrame: questionTextLabelFrame, inFrame: questionTextLabelFrame, text: question.question, textColor: UIColor.black, valign: .Default, _insets: true)
        questionTextLabel.textAlignment = .center
        questionTextLabel.layer.borderWidth = 1
        questionTextLabel.layer.cornerRadius = questionTextLabel.frame.height/10
        questionTextLabel.backgroundColor = UIColor.clear
        questionTextLabel.numberOfLines = 10
        
//        questionView.backgroundColor = UIColor.white
        questionView.addSubview(questionTextLabel)
        
 
        self.addSubview(questionView)
//        submitButton = Button(outFrame: submitButtonFrameOut, inFrame: submitButtonFrame, text: "Submit", _insets: false)
//        submitButton.pressed = {
//            self.submitAnswer()
//        }
//        if(useSubmitButton){
//            self.addSubview(submitButton)
//        }
//
//
        
        displayLink = CADisplayLink(target: self, selector: #selector(update))
        if #available(iOS 10.0, *) {
            displayLink.preferredFramesPerSecond = 60
        } else {
            // Fallback on earlier versions
            displayLink.frameInterval = 1
        }
        displayLink.add(to: RunLoop.main, forMode: .common)
        
        timerBar = UIView(frame: propToRect(prop: CGRect(x: 0, y: 0, width: 1, height: 0.05), frame: self.frame))
        timerFrameSize = timerBar.frame.size
        timerBar.backgroundColor = UIColor.green
        self.addSubview(timerBar)
    
    }
    
    @objc func update(){
        if(displayLink != nil){
            timer += CGFloat(displayLink.duration)
            
            if(timer >= timeToAnswerEachQuestion){
                submitAnswer()
            }
            
            timerBar.frame = CGRect(origin: timerBar.frame.origin, size: CGSize(width: timerFrameSize.width*(1.0-(timer / timeToAnswerEachQuestion)), height: timerBar.frame.height))
        }
    }
    
    func destroy() {
        if(displayLink != nil){ //pressing home twice
            displayLink.remove(from: RunLoop.main, forMode: .default)
            displayLink = nil
        }
    }
    
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
            
            //        questionTextLabel.layer.insertSublayer(shadowLayer, at: 0)
            questionView.layer.insertSublayer(questionTextLabelShadowView, below: nil) // also works
            
        }
    }
    
    func submitAnswer(){
        destroy()
        let score : Int = Int((1.0-(timer / timeToAnswerEachQuestion))*1000)
        self.delegate?.submitButtonPressed(correctAnswer: score <= 0 ? false : self.testIfCurrentlySelectedIsAnswer(), scoreReceived: score, correctAnswerText: self.getCorrectAnswerText())
    }
    
    func createImageView(outFrame: CGRect, inFrame : CGRect, imageURL : String){
        if let image = UIImage(named: imageURL) {
        
            imageView = ImageView(outFrame: outFrame, inFrame: inFrame)
            imageView.image = image
            imageView.layer.borderWidth = 3
            imageView.contentMode = .scaleAspectFit
            self.addSubview(imageView)
        }
    }
    
    //TODO replace selectedButton.enabled with isSelected()
    private func testIfCurrentlySelectedIsAnswer() -> Bool{
        for view in choiceViews {
            if view.selected == true {
                return view.choice!.correctAnswer
            }
        }
        return false
    }
//
    func getCorrectAnswerText() -> String{
        for view in choiceViews {
            if view.choice.correctAnswer == true {
                return view.choice!.choiceValue
            }
        }
        return ""
    }
   
    //TODO
    override func animateIn(completion: @escaping () -> Void) {
        for choiceView in choiceViews {
            choiceView.animateIn()
        }
        
//        questionTextLabel.animateIn()
        UIView.animate(withDuration: TimeInterval(transitionTime), animations: {
            self.questionView.frame = self.questionFrame
        })
        
        if(imageView != nil){
            imageView.animateIn()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(transitionTime), execute: {
            completion()
        })
    }
    
    override func animateOut(completion: @escaping () -> Void) {

        for choiceView in choiceViews {
            choiceView.animateOut()
        }
        
//        questionTextLabel.animateOut()
        UIView.animate(withDuration: TimeInterval(transitionTime), animations: {
            self.questionView.frame = self.questionFrameOut
        })

        if(imageView != nil){
            imageView.animateOut()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(transitionTime), execute: {
            completion()
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
