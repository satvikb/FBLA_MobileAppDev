//
//  GameView.swift
//  FBLA
//
//  Created by Satvik Borra on 9/27/18.
//  Copyright © 2018 satvik borra. All rights reserved.
//

import UIKit

protocol PlayTSVDelegate : class {
    func playTSVPlayButtonPressed(selectedTopics : [Topic])
}

class PlayTSV : View{
    
    weak var delegate: PlayTSVDelegate?
    var title : Label!
    var button : Button!
    var topicScrollView : TopicScrollView!;
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        title = Label(outFrame: propToRect(prop: CGRect(x: -0.7, y: 0, width: 0.7, height: 0.15), frame: self.frame), inFrame: propToRect(prop: CGRect(x: 0.05, y: 0, width: 0.7, height: 0.15), frame: self.frame), text: "Select Topics", textColor: UIColor.black, valign: .Bottom, _insets: false)
        title.text = "Select Topics";
        title.textAlignment = .left
        title.font = UIFont(name: "SFProText-Heavy", size: fontSize(propFontSize: 70))
        title.layer.borderWidth = 2
        self.addSubview(title)
        
        button = Button(outFrame: propToRect(prop: CGRect(x: -1, y: 0.85, width: 1, height: 0.15), frame: self.frame), inFrame: propToRect(prop: CGRect(x: 0, y: 0.85, width: 1, height: 0.15), frame: self.frame), text: "play")
        button.pressed = {
            
            //get selected topics
            var topics : [Topic] = []
            let selectedTopicInfo = self.topicScrollView.getSelectedTopicInfo()
            for info in selectedTopicInfo {
                for topic in allData.topics {
                    if topic.topicId == info.topicId {
                        topics.append(topic)
                    }
                }
            }
            
            self.delegate?.playTSVPlayButtonPressed(selectedTopics: topics)
        }
        self.addSubview(button)
        
        topicScrollView = TopicScrollView(outFrame: propToRect(prop: CGRect(x: 1, y: 0.15, width: 1, height: 0.7), frame: self.frame), inFrame: propToRect(prop: CGRect(x: 0, y: 0.15, width: 1, height: 0.7), frame: self.frame), topics: DataHandler.getTopicInfo())
        self.addSubview(topicScrollView)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func animateIn(completion: @escaping () -> Void) {
        title.animateIn()
        button.animateIn()
        topicScrollView.animateIn()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(transitionTime), execute: {
            completion()
        })
    }
    
    override func animateOut(completion: @escaping () -> Void) {
        title.animateOut()
        button.animateOut()
        topicScrollView.animateOut()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(transitionTime), execute: {
            completion()
        })
        
    }
}
