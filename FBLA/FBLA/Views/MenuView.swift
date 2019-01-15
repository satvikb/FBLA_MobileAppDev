//
//  MenuView.swift
//  FBLA
//
//  Created by Satvik Borra on 9/27/18.
//  Copyright © 2018 satvik borra. All rights reserved.
//

import UIKit

// Delegate functions to change views
protocol MenuViewDelegate : class {
    func menuPlayButtonPressed()
    func menuSettingsButtonPressed()
}

// This view is the main menu
class MenuView : View, PopupViewDelegate{
    
    weak var delegate: MenuViewDelegate?
    
    // UI variables
    var titleView : UIImageView!
    var titleInFrame : CGRect!
    var titleOutFrame : CGRect!
    
    var playButton : Button!
    var instructionsButton : Button!
    var settingsButton : Button!

    var instructionsPopupView : PopupView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Create the title image view
        titleOutFrame = propToRect(prop: CGRect(x: -0.5, y: 0.2, width: 0.5, height: 0.2), frame: self.frame)
        titleInFrame = propToRect(prop: CGRect(x: 0.1, y: 0.1, width: 0.8, height: 0.3), frame: self.frame)
        titleView = UIImageView(frame: titleOutFrame)
        titleView.image = UIImage(named: "titleLogo.png")
        titleView.contentMode = .scaleAspectFit
        self.addSubview(titleView)
        
        // Create buttons with appropriate functions
        playButton = Button(outFrame: propToRect(prop: CGRect(x: -1, y: 0.45, width: 0.8, height: 0.12), frame: self.frame), inFrame: propToRect(prop: CGRect(x: 0.1, y: 0.45, width: 0.8, height: 0.12), frame: self.frame), text: "Play")
        playButton.pressed = {
            self.delegate?.menuPlayButtonPressed()
        }
        self.addSubview(playButton)
        
        instructionsButton = Button(outFrame: propToRect(prop: CGRect(x: -1, y: 0.62, width: 0.8, height: 0.12), frame: self.frame), inFrame: propToRect(prop: CGRect(x: 0.1, y: 0.62, width: 0.8, height: 0.12), frame: self.frame), text: "Instructions")
        instructionsButton.pressed = {
            self.showInstructionsView()
        }
        self.addSubview(instructionsButton)
        
        settingsButton = Button(outFrame: propToRect(prop: CGRect(x: -1, y: 0.85, width: 0.5, height: 0.2), frame: self.frame), inFrame: propToRect(prop: CGRect(x: 0.05, y: 0.9, width: 0.1, height: 0.1), frame: self.frame), text: "", _insets: false, imageURL: "gear.png")
        settingsButton.backgroundColor = UIColor.clear
        settingsButton.pressed = {
            self.delegate?.menuSettingsButtonPressed()
        }
        self.addSubview(settingsButton)
        
        
        
        // Show the instructions view if the app is opened for the first time
        if UserDefaults.standard.object(forKey: "appOpenedBefore") == nil {
            // Never opened app previously
            
            showInstructionsView()
        }
        
    }
    
    // Function to show the instructions view
    func showInstructionsView(){
        let instructionsText = "Welcome to BizQuiz! Here you will be able to test your knowledge of FBLA topics. Start by clicking play and choosing the topics you would like to be tested on. Once you answer each question, you will be shown whether or not you got it right. Then you can either go to the main menu or continue on to the next question. Each question has a time limit, so be quick! The faster you answer, the more points you will receive. If you would like to share your score, press the “Share” button at the bottom of the screen after each question. Have fun!"
        
        // Create and show the instructions view
        instructionsPopupView = PopupView(outFrame: propToRect(prop: CGRect(x: -0.85, y: 0.075, width: 0.85, height: 0.85), frame: self.frame), inFrame: propToRect(prop: CGRect(x: 0.075, y: 0.075, width: 0.85, height: 0.85), frame: self.frame), title: "Instructions", text: instructionsText)
        // Set the delegate to dismiss the view
        instructionsPopupView.delegate = self
        self.addSubview(instructionsPopupView)
        instructionsPopupView.animateIn {
            
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Animation functions
    override func animateIn(completion: @escaping () -> Void) {
        UIView.animate(withDuration: TimeInterval(transitionTime), animations: {
            self.titleView.frame = self.titleInFrame
        })
        
        playButton.animateIn()
        instructionsButton.animateIn()
        settingsButton.animateIn()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(transitionTime), execute: {
            completion()
        })
    }
    
    override func animateOut(completion: @escaping () -> Void) {
        UIView.animate(withDuration: TimeInterval(transitionTime), animations: {
            self.titleView.frame = self.titleOutFrame
        })
        playButton.animateOut()
        instructionsButton.animateOut()
        settingsButton.animateOut()
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(transitionTime), execute: {
            completion()
        })
    }
    
    // Dismiss function for PopupView
    func dismiss() {
        // Keep track of opening app so the view automatically only shows once
        UserDefaults.standard.set(true, forKey: "appOpenedBefore")
        instructionsPopupView.animateOut {
            
        }
    }
}
