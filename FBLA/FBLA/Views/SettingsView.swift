//
//  SettingsView.swift
//  FBLA
//
//  Created by Satvik Borra on 1/6/19.
//  Copyright © 2019 satvik borra. All rights reserved.
//

import UIKit

protocol SettingsViewDelegate : class {
    func settingsMenuButtonPressed()
}

class SettingsView : View{
    
    weak var delegate: SettingsViewDelegate?
    var title : Label!
    var menuButton : Button!
    var resetProgressButton : Button!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        title = Label(outFrame: propToRect(prop: CGRect(x: -0.7, y: 0, width: 0.6, height: 0.15), frame: self.frame), inFrame: propToRect(prop: CGRect(x: 0.1, y: 0, width: 0.6, height: 0.15), frame: self.frame), text: "Settings", textColor: UIColor.black, valign: .Bottom, _insets: false)
//        title.text = "Select Topics";
        title.textAlignment = .left
        title.font = UIFont(name: "SFProText-Heavy", size: fontSize(propFontSize: 70))
        //        title.layer.borderWidth = 2
        self.addSubview(title)
        
        menuButton = Button(outFrame: propToRect(prop: CGRect(x: -0.5, y: 0, width: 0.5, height: 0.2), frame: self.frame), inFrame: propToRect(prop: CGRect(x: 0.75, y: 0, width: 0.25, height: 0.15), frame: self.frame), text: "menu")
        menuButton.pressed = {
            self.delegate?.settingsMenuButtonPressed()
        }
        self.addSubview(menuButton)
        
        resetProgressButton = Button(outFrame: propToRect(prop: CGRect(x: -1, y: 0.15, width: 0.5, height: 0.2), frame: self.frame), inFrame: propToRect(prop: CGRect(x: 0.05, y: 0.2, width: 0.9, height: 0.15), frame: self.frame), text: "Reset All Progress")
        resetProgressButton.pressed = {
            DataHandler.resetCompletedQuestions()
        }
        self.addSubview(resetProgressButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func animateIn(completion: @escaping () -> Void) {
        title.animateIn()
        menuButton.animateIn()
        resetProgressButton.animateIn()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(transitionTime), execute: {
            completion()
        })
    }
    
    override func animateOut(completion: @escaping () -> Void) {
        title.animateOut()
        menuButton.animateOut()
        resetProgressButton.animateOut()
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(transitionTime), execute: {
            completion()
        })
    }
}
