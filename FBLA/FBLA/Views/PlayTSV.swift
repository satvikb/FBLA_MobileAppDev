//
//  GameView.swift
//  FBLA
//
//  Created by Satvik Borra on 9/27/18.
//  Copyright © 2018 satvik borra. All rights reserved.
//

import UIKit

protocol PlayTSVDelegate : class {
    func playTSVHomeButtonPressed()
    func playTSVPlayButtonPressed(selectedTopics : [Topic])
}

class PlayTSV : View{
    
    weak var delegate: PlayTSVDelegate?
    var title : Label!
    var infoLabel : Label!
    var playButton : Button!
    var homeButton : Button!
    var topicScrollView : TopicScrollView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        
        infoLabel = Label(outFrame: propToRect(prop: CGRect(x: -0.8, y: 0.1, width: 0.8, height: 0.075), frame: self.frame), inFrame: propToRect(prop: CGRect(x: 0.05, y: 0.1, width: 0.9, height: 0.0375), frame: self.frame), text: "Questions from unselected topics will not be asked", textColor: UIColor.white, valign: .Bottom, _insets: false)
        infoLabel.textAlignment = .center
        infoLabel.font = UIFont(name: "SFProText-Light", size: fontSize(propFontSize: 20))
//                infoLabel.layer.borderWidth = 2
        infoLabel.numberOfLines = 1
        infoLabel.backgroundColor = UIColor.clear
        self.addSubview(infoLabel)
        
        title = Label(outFrame: propToRect(prop: CGRect(x: -0.8, y: 0.03, width: 0.8, height: 0.07), frame: self.frame), inFrame: propToRect(prop: CGRect(x: 0.2, y: 0.005, width: 0.8, height: 0.0925), frame: self.frame), text: "Select Topics", textColor: UIColor.white, valign: .Default, _insets: false)
        title.text = "Select Topics"
        title.textAlignment = .center
        title.font = UIFont(name: "SFProText-Heavy", size: fontSize(propFontSize: 70))
//                title.layer.borderWidth = 2
        self.addSubview(title)
        
        homeButton = Button(outFrame: propToRect(prop: CGRect(x: -1, y: 0.03, width: 0.1, height: 0.1), frame: self.frame), inFrame: propToRect(prop: CGRect(x: 0.025, y: 0.03, width: 0.15, height: 0.08), frame: self.frame), text: "", _insets: false, imageURL: "home.png")
        homeButton.backgroundColor = UIColor.clear
        homeButton.pressed = {
            self.delegate?.playTSVHomeButtonPressed()
        }
        self.addSubview(homeButton)
        
        playButton = Button(outFrame: propToRect(prop: CGRect(x: -1, y: 0.85, width: 1, height: 0.15), frame: self.frame), inFrame: propToRect(prop: CGRect(x: 0, y: 0.85, width: 1, height: 0.15), frame: self.frame), text: "Play")
        playButton.pressed = {
            
            //get selected topics
            var topics : [Topic] = []
            let selectedTopicInfo = self.topicScrollView.getSelectedTopicInfo()
            
            let completedQuestions = DataHandler.getCompletedQuestions()
            
            for info in selectedTopicInfo {
                for topic in allData.topics {
                    if topic.topicId == info.topicId {
                        var filteredTopic = topic
                        //remove completed questions
                        //TODO make this an option
                        for question in filteredTopic.questions {
                            if(completedQuestions.contains(question.questionId)){
                                if let index:Int = filteredTopic.questions.index(where: {$0.questionId == question.questionId}) {
                                    filteredTopic.questions.remove(at: index)
                                }
                            }
                        }
                        
                        topics.append(filteredTopic)
                    }
                }
            }
            
            self.delegate?.playTSVPlayButtonPressed(selectedTopics: topics)
        }
        self.addSubview(playButton)
        
        topicScrollView = TopicScrollView(outFrame: propToRect(prop: CGRect(x: 1, y: 0.15, width: 1, height: 0.7), frame: self.frame), inFrame: propToRect(prop: CGRect(x: 0, y: 0.15, width: 1, height: 0.7), frame: self.frame), topics: DataHandler.getTopicInfo())
        self.addSubview(topicScrollView)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reloadTopicScrollView(){
        //TODO Better way to do this?
        topicScrollView.removeFromSuperview()
        
        topicScrollView = TopicScrollView(outFrame: propToRect(prop: CGRect(x: 1, y: 0.15, width: 1, height: 0.7), frame: self.frame), inFrame: propToRect(prop: CGRect(x: 0, y: 0.15, width: 1, height: 0.7), frame: self.frame), topics: DataHandler.getTopicInfo())
        self.addSubview(topicScrollView)
    }
    
    override func animateIn(completion: @escaping () -> Void) {
        title.animateIn()
        infoLabel.animateIn()
        
        playButton.animateIn()
        homeButton.animateIn()
        
        reloadTopicScrollView()
        topicScrollView.animateIn()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(transitionTime), execute: {
            completion()
        })
    }
    
    override func animateOut(completion: @escaping () -> Void) {
        title.animateOut()
        infoLabel.animateOut()
        
        playButton.animateOut()
        homeButton.animateOut()
        
        topicScrollView.animateOut()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(transitionTime), execute: {
            completion()
        })
        
    }
}
