//
//  DataStructures.swift
//  FBLA
//
//  Created by Satvik Borra on 9/27/18.
//  Copyright © 2018 satvik borra. All rights reserved.
//

import Foundation

// Define all of the data structures to load data from source .json files
struct AllData {
    var topicTotalCount : Int
    var questionTotalCount : Int
    var topics : [Topic]
}

struct Topic : Codable{
    var topicId : Int
    var topicName : String
    var logoURL : String
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
    var logoURL : String
}

struct QuestionChoice {
    var choiceValue : String
    var correctAnswer : Bool
}
