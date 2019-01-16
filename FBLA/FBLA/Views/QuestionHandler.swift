//
//  QuestionHandler.swift
//  FBLA
//
//  Created by Satvik Borra on 9/28/18.
//  Copyright © 2018 satvik borra. All rights reserved.
//

import UIKit

protocol QuestionHandlerDelegate : class {
    func questionHandlerHomeButtonPressed()
    func shareButton(text: String)
    
}

// This class handles the questions by putting all of the QuestionViews under one manager
class QuestionHandler : View, QuestionViewDelegate, QuestionFinishedViewDelegate, AllQuestionsCompleteViewDelegate{
    
    weak var delegate : QuestionHandlerDelegate?
    
    // Keep track of topic
    private var topicSet : [Topic]! = []
    
    var startTotalQuestions : Int = 0
    
    // Current question information
    var currentTopic : Topic!
    var currentQuestion : Question!
    
    // Question views
    var currentQuestionView : QuestionView!
    var currentQuestionInfoView : QuestionInfoView!
    var questionFinishedView : QuestionFinishedView!
    var allQuestionsCompleteView : AllQuestionsCompleteView!
    
    // Score data
    var answerStreak : Int = 0
    var score : Int = 0
    
    override init(frame: CGRect){
        super.init(frame: frame)
    
        // Initialize the only static view
        questionFinishedView = QuestionFinishedView(outFrame: propToRect(prop: CGRect(x: 0.05, y: -1, width: 0.9, height: 0.9), frame: self.frame), inFrame: propToRect(prop: CGRect(x: 0.05, y: 0.05, width: 0.9, height: 0.9), frame: self.frame))
        questionFinishedView.delegate = self
    }
    
    // Update topic set
    func setTopicSet(topics : [Topic]){
        topicSet = topics
        startTotalQuestions = totalQuestionsRemaining()
    }
    
    // Create the next question if possible and display it. If no question is available the AllQuestionsCompleteView is shown
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
    
    // Called from subviews and handles scores and question set to pass onto the QuestionFinishedView
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
        
        // Show the next view with updated data
        self.addSubview(questionFinishedView)
        questionFinishedView.updateUI(didAnswerCorrectly: correctAnswer, answerStreak: answerStreak, score: score, scoreChanged: scoreReceived, actualAnswer: correctAnswerText)
        questionFinishedView.animateIn(completion: {})
        self.bringSubviewToFront(questionFinishedView)
        
        // Reset the answer streak
        if(!correctAnswer){
            answerStreak = 0
        }
    }
    
    // Function to test if a question is available
    func questionAvailable() -> Bool{
        return totalQuestionsRemaining() > 0
    }
    
    // Calculate the number of questions remaining based on topic set
    func totalQuestionsRemaining() -> Int{
        var total : Int = 0
        for t in topicSet{
            total += t.questions.count
        }
        return total
    }
    
    // Get the next question
    func nextQuestion() -> Question {
        // Make sure the topic has unanswered questions
        repeat{
            currentTopic = topicSet.randomElement()!
        }while(currentTopic.questions.count == 0)
        
        return currentTopic.questions.randomElement()!
    }
    
    // Delegate function to share score
    func questionFinishedShareButton(text: String) {
        self.delegate?.shareButton(text: text)
    }
    
    // Delegate functions
    func questionFinishedNextQuestionButton() {
        questionFinishedView.animateOut(completion: {
            self.questionFinishedView.removeFromSuperview()
        })
        
        createQuestionView()
    }
    
    func questionFinishedHomeButton() {
        score = 0
        answerStreak = 0
        questionFinishedView.animateOut(completion: {
            self.questionFinishedView.removeFromSuperview()
        })
        self.delegate?.questionHandlerHomeButtonPressed()
    }
    
    func allQuestionsCompleteHomeButton() {
        score = 0
        answerStreak = 0
        allQuestionsCompleteView.animateOut(completion: {
            self.allQuestionsCompleteView.removeFromSuperview()
        })
        self.delegate?.questionHandlerHomeButtonPressed()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
