//
//  MenuView.swift
//  FBLA
//
//  Created by Satvik Borra on 9/27/18.
//  Copyright © 2018 satvik borra. All rights reserved.
//

import UIKit

protocol MenuViewDelegate : class {
    func menuPlayButtonPressed()
    func menuSettingsButtonPressed()
    func menuLearnButtonPressed()
}

class MenuView : View{
    
    weak var delegate: MenuViewDelegate?
    var title : Label!
    var playButton : Button!
    var learnButton : Button!
    var settingsButton : Button!

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        title = Label(outFrame: propToRect(prop: CGRect(x: -0.5, y: 0.2, width: 0.5, height: 0.2), frame: self.frame), inFrame: propToRect(prop: CGRect(x: 0.1, y: 0.1, width: 0.8, height: 0.3), frame: self.frame))
        title.text = "Biz\n     Quiz";
        title.numberOfLines = 2
        title.font = UIFont(name: "Helvetica", size: fontSize(propFontSize: 60))
        title.layer.borderWidth = 5
        self.addSubview(title)
        
        playButton = Button(outFrame: propToRect(prop: CGRect(x: -0.5, y: 0.45, width: 0.5, height: 0.2), frame: self.frame), inFrame: propToRect(prop: CGRect(x: 0.25, y: 0.45, width: 0.5, height: 0.2), frame: self.frame), text: "play")
        playButton.pressed = {
            self.delegate?.menuPlayButtonPressed()
        }
        self.addSubview(playButton)
        
        learnButton = Button(outFrame: propToRect(prop: CGRect(x: -0.5, y: 0.45, width: 0.5, height: 0.2), frame: self.frame), inFrame: propToRect(prop: CGRect(x: 0.25, y: 0.45, width: 0.5, height: 0.2), frame: self.frame), text: "play")
        learnButton.pressed = {
            self.delegate?.menuLearnButtonPressed()
        }
        self.addSubview(learnButton)
        
        settingsButton = Button(outFrame: propToRect(prop: CGRect(x: -0.5, y: 0.85, width: 0.5, height: 0.2), frame: self.frame), inFrame: propToRect(prop: CGRect(x: 0, y: 0.8, width: 0.4, height: 0.2), frame: self.frame), text: "settings")
        settingsButton.pressed = {
            self.delegate?.menuSettingsButtonPressed()
        }
        self.addSubview(settingsButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func animateIn(completion: @escaping () -> Void) {
        title.animateIn()
        playButton.animateIn()
        learnButton.animateIn()
        settingsButton.animateIn()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(transitionTime), execute: {
            completion()
        })
    }
    
    override func animateOut(completion: @escaping () -> Void) {
        title.animateOut()
        playButton.animateOut()
        learnButton.animateOut()
        settingsButton.animateOut()
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(transitionTime), execute: {
            completion()
        })
    }
}
