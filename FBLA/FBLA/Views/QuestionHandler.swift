//
//  QuestionHandler.swift
//  FBLA
//
//  Created by Satvik Borra on 9/28/18.
//  Copyright © 2018 satvik borra. All rights reserved.
//

import UIKit

protocol QuestionHandlerDelegate : class {
//    func playTSVPlayButtonPressed(selectedTopics : [Topic])
}

class QuestionHandler : View, QuestionViewDelegate, QuestionFinishedViewDelegate{
    
    
    
    weak var delegate : QuestionHandlerDelegate?
    var topicSet : [Topic]! = []
    
    var currentQuestion : Question!;
    var currentQuestionView : QuestionView!
    var questionFinishedView : QuestionFinishedView!
    
    var answerStreak : Int = 0
    
    override init(frame: CGRect){
        super.init(frame: frame)
    
        questionFinishedView = QuestionFinishedView(outFrame: propToRect(prop: CGRect(x: 0.05, y: -1, width: 0.9, height: 0.9), frame: self.frame), inFrame: propToRect(prop: CGRect(x: 0.05, y: 0.05, width: 0.9, height: 0.9), frame: self.frame))
        questionFinishedView.delegate = self
//        self.addSubview(questionFinishedView)
    }
    
    func createQuestionView(){
        currentQuestion = nextQuestion()
        currentQuestionView = QuestionView(frame: propToRect(prop: CGRect(x: 0, y: 0.15, width: 1, height: 0.85), frame: self.frame), question: currentQuestion)
        currentQuestionView.layer.borderWidth = 1
        currentQuestionView.delegate = self
        self.addSubview(currentQuestionView)
        
        currentQuestionView.animateIn(completion: {})
    }
    
    func submitButtonPressed(correctAnswer: Bool, correctAnswerText: String) {
        if(correctAnswer){
            answerStreak += 1
        }
//        if(correctAnswer){
            currentQuestionView.animateOut(completion: {
                self.currentQuestionView.removeFromSuperview()
            })
        
        self.addSubview(questionFinishedView)
        questionFinishedView.updateUI(didAnswerCorrectly: correctAnswer, answerStreak: answerStreak, actualAnswer: correctAnswerText)
        questionFinishedView.animateIn(completion: {})
        self.bringSubviewToFront(questionFinishedView)
//        }
        
        if(!correctAnswer){
            answerStreak = 0
        }
    }
    
    func questionAvailable() -> Bool{
        return totalQuestionsRemaining() > 0
    }
    
    func totalQuestionsRemaining() -> Int{
        var total : Int = 0
        for t in topicSet{
            total += t.questions.count
        }
        return total
    }
    
    //todo
    func nextQuestion() -> Question {
        return topicSet.randomElement()!.questions.randomElement()!
    }
    
    func nextQuestionButtonPressed() {
        questionFinishedView.animateOut(completion: {
            self.questionFinishedView.removeFromSuperview()
        })
        
        createQuestionView()
    }
    
    func homeButtonPressed() {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
