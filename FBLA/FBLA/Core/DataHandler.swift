//
//  LoadData.swift
//  FBLA
//
//  Created by Satvik Borra on 9/27/18.
//  Copyright © 2018 satvik borra. All rights reserved.
//

import Foundation


class DataHandler {
    
    // The key to store in UserDefaults
    static let completedQuestionsKey = "completedQuestions"

    // Function to read data from files
    static func readData() -> AllData {
        
        var topics : [Topic] = []
        var questionCount : Int = 0
        
        let filePath = Bundle.main.resourcePath!

        do {
            // Get the directory contents urls (including subfolders urls)
            let directoryContents = try FileManager.default.contentsOfDirectory(at: URL(fileURLWithPath: filePath), includingPropertiesForKeys: nil, options: [])
            
            let jsonFiles = directoryContents.filter{ $0.pathExtension == "json" }

            // Loop through all Question files to load data
            for path in jsonFiles {
                do {
                    let data = try Data(contentsOf: path, options: .mappedIfSafe)
                    
                    if let json = try? JSONDecoder().decode(Topic.self, from: data){
                        
                        topics.append(json)
                        questionCount += json.questions.count
                    }
                } catch {
                    // handle error
                    print("no json \(error.localizedDescription)")
                }
            }
        } catch {
            print(error.localizedDescription)
        }
        
       // Create object storing the data loaded
        return AllData(topicTotalCount: topics.count, questionTotalCount: questionCount, topics: topics)
    }
    
    // Return a list of question ID's of questions that have been answered
    static func getCompletedQuestions() -> [String]{
        let completedQuestionsObject = UserDefaults.standard.object(forKey: completedQuestionsKey)
        let completedQuestionsFiltered : [String] = completedQuestionsObject != nil ? completedQuestionsObject as! [String] : []
        
        return completedQuestionsFiltered
    }
   
    // Helper function to store ID's of answered questions
    private static func saveCompletedQuestions(questions : [String]){
        UserDefaults.standard.set(questions, forKey: completedQuestionsKey)
    }
    
    // Calls helper function to save question progress
    static func completedQuestion(questionId : String){
        var current = getCompletedQuestions()
        current.append(questionId)
        saveCompletedQuestions(questions: current)
    }
    
    // Reset saved question progress by writing empty array
    static func resetCompletedQuestions(){
        saveCompletedQuestions(questions: [])
    }
    
    // Use topic data to create a TopicInfo class that gives information about each topic
    static func getTopicInfo() -> [TopicInfo] {
        var allTopicInfo : [TopicInfo] = []
        
        for topic in allData.topics {
            let topicInfo = TopicInfo(topicId: topic.topicId, topicName: topic.topicName, topicQuestions: topic.questions.count, questionsComplete: getQuestionsCompleteFromTopic(topic: topic), logoURL: topic.logoURL)
            allTopicInfo.append(topicInfo)
        }
        
        return allTopicInfo
    }
    
    // Get the list of questions that are completed from each topic
    static func getQuestionsCompleteFromTopic(topic : Topic) -> Int{
        let completedQuestions = getCompletedQuestions()
        var totalComplete : Int = 0
        for question in topic.questions {
            if completedQuestions.contains(question.questionId){
                totalComplete += 1
            }
        }
        return totalComplete
        
    }
}
