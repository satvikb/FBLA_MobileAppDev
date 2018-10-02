//
//  TopicScrollView.swift
//  FBLA
//
//  Created by Satvik Borra on 9/27/18.
//  Copyright © 2018 satvik borra. All rights reserved.
//

import UIKit

class TopicScrollView : UIScrollView {
    
    var topicInfo : [TopicInfo]!
    var cells : [TopicScrollViewCell]! = []
    
    var outFrame : CGRect!
    var inFrame : CGRect!
    
    init(outFrame: CGRect, inFrame : CGRect, topics : [TopicInfo]) {
        self.topicInfo = topics

        self.outFrame = outFrame
        self.inFrame = inFrame
        
        super.init(frame: outFrame)
        
        let topPadding = 0.05
        let verticalCellPadding = 0.02
        let cellHeight = 0.15
        let cellWidth = 0.95
        var cellIndex : Double = 0
        
        //TODO updateTopicInfo() function to update cell data
        for topic in topicInfo {
            let cell = TopicScrollViewCell(frame: propToRect(prop: CGRect(x: (1-cellWidth)/2, y: topPadding + (cellHeight + verticalCellPadding) * cellIndex, width: cellWidth, height: cellHeight), frame: self.frame), topicInfo: topic, selected: true)
            cells.append(cell)
            self.addSubview(cell)
            cellIndex += 1
        }
        
        let propHeight = topPadding + ((cellHeight + verticalCellPadding) * (cellIndex+1)) // + cellHeight
        let realHeight = propToFloat(prop: CGFloat(propHeight), by: self.frame.height)
        self.contentSize = CGSize(width: self.frame.size.width, height: realHeight)
        
//        self.layer.borderWidth = 2
    }
    
    func getSelectedTopicInfo() -> [TopicInfo]{
        var selectedTopics : [TopicInfo] = []
        for cell in cells {
            if(cell.selectedButton.enabled){
                selectedTopics.append(cell.topicInfo)
            }
        }
        return selectedTopics
    }
    
    func selectAllEvents(){
        
    }
    
    func deselectAllEvents(){
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func animateIn(time: CGFloat = transitionTime) {
        UIView.animate(withDuration: TimeInterval(time), animations: {
            self.frame = self.inFrame
        })
    }
    
    func animateOut(time: CGFloat = transitionTime){
        UIView.animate(withDuration: TimeInterval(time), animations: {
            self.frame = self.outFrame
        })
    }
    
}
