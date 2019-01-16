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

// This view is the settings view
class SettingsView : View, PopupViewDelegate, UITextViewDelegate{
    
    weak var delegate: SettingsViewDelegate?
    
    // Create UI
    var title : Label!
    var menuButton : Button!
    var resetProgressButton : Button!
    var reportBugButton : Button!
    var creditsButton : Button!
    
    // Create View variables
    var resetProgressPopupView : PopupView!
    var creditsPopupView : PopupView!
    var reportBugPopupView : PopupView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        // Create UI and buttons
        title = Label(outFrame: propToRect(prop: CGRect(x: -0.7, y: 0, width: 0.6, height: 0.15), frame: self.frame), inFrame: propToRect(prop: CGRect(x: 0.1, y: 0, width: 0.6, height: 0.15), frame: self.frame), text: "Settings", textColor: UIColor.white, valign: .Bottom, _insets: false)
        title.textAlignment = .left
        title.font = UIFont(name: "SFProText-Heavy", size: fontSize(propFontSize: 70))
        self.addSubview(title)
        
        menuButton = Button(outFrame: propToRect(prop: CGRect(x: -0.5, y: 0, width: 0.5, height: 0.2), frame: self.frame), inFrame: propToRect(prop: CGRect(x: 0.75, y: 0.05, width: 0.25, height: 0.1), frame: self.frame), text: "", _insets: false, imageURL: "home.png")
        menuButton.backgroundColor = UIColor.clear
        menuButton.pressed = {
            self.delegate?.settingsMenuButtonPressed()
        }
        self.addSubview(menuButton)
        
        resetProgressButton = Button(outFrame: propToRect(prop: CGRect(x: -1, y: 0.15, width: 0.5, height: 0.1), frame: self.frame), inFrame: propToRect(prop: CGRect(x: 0.05, y: 0.25, width: 0.9, height: 0.1), frame: self.frame), text: "Reset All Progress")
        resetProgressButton.pressed = {
            // Reset data and show a popup
            DataHandler.resetCompletedQuestions()
            
            self.resetProgressPopupView = PopupView(outFrame: propToRect(prop: CGRect(x: -0.85, y: 0.075, width: 0.85, height: 0.85), frame: self.frame), inFrame: propToRect(prop: CGRect(x: 0.075, y: 0.075, width: 0.85, height: 0.85), frame: self.frame), title: "Progress Reset", text: "All question progress has been reset.")
            self.resetProgressPopupView.delegate = self
            self.resetProgressPopupView.textLabel.delegate = self
            self.addSubview(self.resetProgressPopupView)
            self.resetProgressPopupView.animateIn {
                
            }
        }
        self.addSubview(resetProgressButton)
        
        reportBugButton = Button(outFrame: propToRect(prop: CGRect(x: -1, y: 0.3, width: 0.5, height: 0.1), frame: self.frame), inFrame: propToRect(prop: CGRect(x: 0.05, y: 0.4, width: 0.9, height: 0.1), frame: self.frame), text: "Report Bug")
        reportBugButton.pressed = {
            // Show a popup to report bug
            self.reportBugPopupView = PopupView(outFrame: propToRect(prop: CGRect(x: -0.85, y: 0.075, width: 0.85, height: 0.85), frame: self.frame), inFrame: propToRect(prop: CGRect(x: 0.075, y: 0.075, width: 0.85, height: 0.85), frame: self.frame), title: "Report Bug", text: "")
            self.reportBugPopupView.textLabel.isEditable = true
            self.reportBugPopupView.delegate = self
            self.reportBugPopupView.textLabel.delegate = self
            self.addSubview(self.reportBugPopupView)
            self.reportBugPopupView.animateIn {
                
            }
        }
        self.addSubview(reportBugButton)
        
        creditsButton = Button(outFrame: propToRect(prop: CGRect(x: -1, y: 0.45, width: 0.5, height: 0.1), frame: self.frame), inFrame: propToRect(prop: CGRect(x: 0.05, y: 0.55, width: 0.9, height: 0.1), frame: self.frame), text: "Credits")
        creditsButton.pressed = {
            
            // Create a popup to show credits
            let creditText = """
            Software development: Satvik Borra
            Images: Jessica Cao, Michael Valenti
            Additional Text Editing: Jessica Cao, Michael Valenti

            Question Content: fbla-pbl.org
            Program Used: Xcode

            All images and designs seen in this app were created specifically for this app.
            All fonts used are licenced under use only for Apple applications.
            """
            
            self.creditsPopupView = PopupView(outFrame: propToRect(prop: CGRect(x: -0.85, y: 0.075, width: 0.85, height: 0.85), frame: self.frame), inFrame: propToRect(prop: CGRect(x: 0.075, y: 0.075, width: 0.85, height: 0.85), frame: self.frame), title: "Credits", text: creditText)
            self.creditsPopupView.delegate = self
            self.creditsPopupView.textLabel.delegate = self
            self.addSubview(self.creditsPopupView)
            self.creditsPopupView.animateIn {
                
            }
        }
        self.addSubview(creditsButton)
    }
    
    // Dismiss any possible open popups
    func dismiss() {
        if creditsPopupView != nil {
            creditsPopupView.animateOut {
                
            }
        }
        
        if reportBugPopupView != nil {
            reportBugPopupView.animateOut {
                
            }
        }
        
        if resetProgressPopupView != nil {
            resetProgressPopupView.animateOut {
                
            }
        }
    }
    
    // For bug reporting, clicking done hides the keyboard instead of creating a new line
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // Animation functions
    override func animateIn(completion: @escaping () -> Void) {
        title.animateIn()
        menuButton.animateIn()
        resetProgressButton.animateIn()
        reportBugButton.animateIn()
        creditsButton.animateIn()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(transitionTime), execute: {
            completion()
        })
    }
    
    override func animateOut(completion: @escaping () -> Void) {
        title.animateOut()
        menuButton.animateOut()
        resetProgressButton.animateOut()
        reportBugButton.animateOut()
        creditsButton.animateOut()
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(transitionTime), execute: {
            completion()
        })
    }
}
