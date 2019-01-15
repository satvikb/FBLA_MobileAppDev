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
    func questionHandlerHomeButtonPressed()
    func shareButton(text: String)
    
}

class QuestionHandler : View, QuestionViewDelegate, QuestionFinishedViewDelegate, AllQuestionsCompleteViewDelegate{
    
    
    
    weak var delegate : QuestionHandlerDelegate?
    
    private var topicSet : [Topic]! = []
    
    var startTotalQuestions : Int = 0
    
    var currentTopic : Topic!
    var currentQuestion : Question!
    var currentQuestionView : QuestionView!
    var currentQuestionInfoView : QuestionInfoView!

    var questionFinishedView : QuestionFinishedView!
    var allQuestionsCompleteView : AllQuestionsCompleteView!
    
    var answerStreak : Int = 0
    var score : Int = 0
    override init(frame: CGRect){
        super.init(frame: frame)
    
        questionFinishedView = QuestionFinishedView(outFrame: propToRect(prop: CGRect(x: 0.05, y: -1, width: 0.9, height: 0.9), frame: self.frame), inFrame: propToRect(prop: CGRect(x: 0.05, y: 0.05, width: 0.9, height: 0.9), frame: self.frame))
        questionFinishedView.delegate = self
//        self.addSubview(questionFinishedView)
    }
    
    func setTopicSet(topics : [Topic]){
        topicSet = topics
        
        startTotalQuestions = totalQuestionsRemaining()
    }
    
    func createQuestionView(){
        if(questionAvailable()){
            currentQuestion = nextQuestion()
            
            currentQuestionView = QuestionView(frame: propToRect(prop: CGRect(x: 0, y: 0.15, width: 1, height: 0.85), frame: self.frame), question: currentQuestion)
            currentQuestionView.delegate = self
            self.addSubview(currentQuestionView)
            self.sendSubviewToBack(currentQuestionView) //to be behind question finished view
            currentQuestionView.animateIn(completion: {})

            currentQuestionInfoView = QuestionInfoView(frame: propToRect(prop: CGRect(x: 0, y: 0, width: 1, height: 0.15), frame: self.frame), topicName: currentTopic.topicName, counterString: "\((startTotalQuestions - self.totalQuestionsRemaining())+1) / \(self.startTotalQuestions)")
            self.addSubview(currentQuestionInfoView)
            self.sendSubviewToBack(currentQuestionInfoView)
            currentQuestionInfoView.animateIn(completion: {})
        }else{
            allQuestionsCompleteView = AllQuestionsCompleteView(outFrame: propToRect(prop: CGRect(x: 1, y: 0.05, width: 0.9, height: 0.9), frame: self.frame), inFrame: propToRect(prop: CGRect(x: 0.05, y: 0.05, width: 0.9, height: 0.9), frame: self.frame))
            allQuestionsCompleteView.delegate = self
            allQuestionsCompleteView.updateUI(score: score)
            self.addSubview(allQuestionsCompleteView)
            
            allQuestionsCompleteView.animateIn(completion: {})
        }
    }
    
    func submitButtonPressed(correctAnswer: Bool, scoreReceived: Int, correctAnswerText: String) {
        if(correctAnswer){
            answerStreak += 1
            score += scoreReceived
            DataHandler.completedQuestion(questionId: currentQuestion.questionId)
            
            if let topicIndex:Int = self.topicSet.index(where: {$0.topicId == currentTopic.topicId}) {
                if let index:Int = self.topicSet[topicIndex].questions.index(where: {$0.questionId == currentQuestion.questionId}) {
                    self.topicSet[topicIndex].questions.remove(at: index)
                }
            }
        }
        
        currentQuestionView.animateOut(completion: {
            self.currentQuestionView.removeFromSuperview()
        })
        currentQuestionInfoView.animateOut(completion: {
            self.currentQuestionInfoView.removeFromSuperview()
        })
        
        self.addSubview(questionFinishedView)
        questionFinishedView.updateUI(didAnswerCorrectly: correctAnswer, answerStreak: answerStreak, score: score, scoreChanged: scoreReceived, actualAnswer: correctAnswerText)
        questionFinishedView.animateIn(completion: {})
        self.bringSubviewToFront(questionFinishedView)
        
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
        repeat{
            currentTopic = topicSet.randomElement()!
        }while(currentTopic.questions.count == 0)
        
        return currentTopic.questions.randomElement()!
    }
    
    func questionFinishedShareButton(text: String) {
        self.delegate?.shareButton(text: text)
    }
    
    func questionFinishedNextQuestionButton() {
        questionFinishedView.animateOut(completion: {
            self.questionFinishedView.removeFromSuperview()
        })
        
        createQuestionView()
        
    }
    
    func questionFinishedHomeButton() {
        questionFinishedView.animateOut(completion: {
            self.questionFinishedView.removeFromSuperview()
        })
        self.delegate?.questionHandlerHomeButtonPressed()
    }
    
    func allQuestionsCompleteHomeButton() {
        allQuestionsCompleteView.animateOut(completion: {
            self.allQuestionsCompleteView.removeFromSuperview()
        })
        self.delegate?.questionHandlerHomeButtonPressed()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
