//
//  DataStructures.swift
//  FBLA
//
//  Created by Satvik Borra on 9/27/18.
//  Copyright © 2018 satvik borra. All rights reserved.
//

import Foundation

struct AllData {
    var topicTotalCount : Int //needed?
    var questionTotalCount : Int //needed?
    var topics : [Topic]
}

struct Topic : Codable{
    var topicId : Int
    var topicName : String
    var questions : [Question]
}

struct Question : Codable{
    var questionDifficulty : Int
    var question : String
    var questionId : String
    var imageURL : String
    var choiceType : String
    var choices : [String:String]
    var correctAnswer : String
}

struct TopicInfo {
    var topicId : Int
    var topicName : String
    var topicQuestions : Int
    var questionsComplete : Int
}

struct QuestionChoice {
//    var choiceName : String // A, B, C, D, G, E, J, etc.
    var choiceValue : String
    var correctAnswer : Bool
}
