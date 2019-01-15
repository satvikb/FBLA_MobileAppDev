//
//  Label.swift
//  FBLA
//
//  Created by Satvik Borra on 9/27/18.
//  Copyright © 2018 satvik borra. All rights reserved.
//

import UIKit

enum VAlign {
    case Top
    case Default
    case Bottom
}

class Label: UILabel{
    
//    static let Null = Label(frame: CGRect.zero, text: "")
    
    var outFrame: CGRect!
    var inFrame: CGRect!
    
    var vAlign: VAlign = .Default
    var insets: Bool = false
    
    //TODO for Label and Button, _outPos: take into account withinFrame
    init(outFrame: CGRect, inFrame: CGRect, text: String = "", textColor: UIColor = UIColor.black, valign : VAlign = .Default, _insets: Bool = true){
        self.outFrame = outFrame
        self.inFrame = inFrame
        vAlign = valign
        insets = _insets
        
        super.init(frame: outFrame)
        
        adjustsFontSizeToFitWidth = true
        
        //        self.layer.borderColor = UIColor.black.cgColor
        //        self.layer.borderWidth = 3
        
        
//        self.font = UIFont(name: "Helvetica", size: 20)
//        self.textAlignment = .center
        
        changeTextColor(color: textColor)
        self.text = text
    }
    
    func changeTextColor(color: UIColor){
        textColor = color
    }
    
    
    override func drawText(in r: CGRect) {
        //        CGFloat height = [self sizeThatFits:rect.size].height
        var rect = r
        
        if(vAlign == .Top){
            rect.size.height = self.sizeThatFits(rect.size).height
        }else if(vAlign == .Bottom){
            let height = self.sizeThatFits(rect.size).height
            rect.origin.y += rect.size.height - height
            rect.size.height = height
        }
        
        var theInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        if(insets == true){
            theInsets = UIEdgeInsets(top: 0, left: r.width*0.1, bottom: 0, right: r.width*0.1)
        }
//        super.drawText(in: UIEdgeInsetsInsetRect(rect, theInsets))
        super.drawText(in: rect.inset(by: theInsets))
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func animateIn(time: CGFloat = transitionTime){
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
