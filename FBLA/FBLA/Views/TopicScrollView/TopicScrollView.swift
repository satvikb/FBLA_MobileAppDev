//
//  TopicScrollView.swift
//  FBLA
//
//  Created by Satvik Borra on 9/27/18.
//  Copyright © 2018 satvik borra. All rights reserved.
//

import UIKit

// The topic scroll view is a subview under PlayTSV which displays the 6 possible topics
class TopicScrollView : UIScrollView {
    
    // Variables to store topic info and UI elements
    var topicInfo : [TopicInfo]!
    var cells : [TopicScrollViewCell]! = []
    
    // Variables to store animation & transition information
    var outFrame : CGRect!
    var inFrame : CGRect!
    
    init(outFrame: CGRect, inFrame : CGRect, topics : [TopicInfo]) {
        self.topicInfo = topics

        self.outFrame = outFrame
        self.inFrame = inFrame
        
        super.init(frame: outFrame)
        
        // Create the topic cells programatically & dynamically using these variables to decide placement
        let topPadding = 0.05
        let leftPadding = 0.025
        let verticalCellPadding = 0.035
        let cellHeight = 0.45
        let cellWidth = 0.45
        var cellIndex : Double = 0
        
        for topic in topicInfo {
            // Create the view for the current topic
            let cell = TopicScrollViewCell(frame: propToRect(prop: CGRect(x: leftPadding+(Double(Int(cellIndex)%2)*(0.5)), y: topPadding + (cellHeight + verticalCellPadding) * floor(cellIndex/2), width: cellWidth, height: cellHeight), frame: self.frame), topicInfo: topic, selected: true)
            
            // Set the color of the cell based on the cellIndex
            switch cellIndex {
            case 0:
                cell.backgroundColor = UIColor(red: 255/255, green: 87/255, blue: 87/255, alpha: 1)
                break;
            case 1:
                cell.backgroundColor = UIColor(red: 0/255, green: 206/255, blue: 209/255, alpha: 1)
                break;
            case 2:
                cell.backgroundColor = UIColor(red: 255/255, green: 136/255, blue: 55/255, alpha: 1)
                break;
            case 3:
                cell.backgroundColor = UIColor(red: 18/255, green: 207/255, blue: 91/255, alpha: 1)
                break;
            case 4:
                cell.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 0/255, alpha: 1)
                break;
            case 5:
                cell.backgroundColor = UIColor(red: 132/255, green: 112/255, blue: 255/255, alpha: 1)
                break;
            default:
                
                break;
            }
            
            // Keep track of the cell and add it to the view
            cells.append(cell)
            self.addSubview(cell)
            cellIndex += 1
        }
        
        // Calculate the size of the scroll veiw
        let propHeight = topPadding + ((cellHeight + verticalCellPadding) * (cellIndex/2))
        let realHeight = propToFloat(prop: CGFloat(propHeight), by: self.frame.height)
        self.contentSize = CGSize(width: self.frame.size.width, height: realHeight)
    }
    
    // Create a list of selected topics
    func getSelectedTopicInfo() -> [TopicInfo]{
        var selectedTopics : [TopicInfo] = []
        for cell in cells {
            if(cell.selectedButton.enabled){
                selectedTopics.append(cell.topicInfo)
            }
        }
        return selectedTopics
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Animation functions
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
