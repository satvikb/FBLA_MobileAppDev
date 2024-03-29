//
//  ViewController.swift
//  FBLA
//
//  Created by Satvik Borra on 9/27/18.
//  Copyright © 2018 satvik borra. All rights reserved.
//

import UIKit

enum ViewType{
    case Splash
    case Menu
    case PlayTSV
    case QuestionHandler
    case Question
    case Settings
    case ResetTSV
}

var transitionTime : CGFloat = 0.3
var allData : AllData!

class ViewController: UIViewController, MenuViewDelegate, PlayTSVDelegate, QuestionHandlerDelegate, SettingsViewDelegate {
    
    var currentView : ViewType!
    
    var menuView : MenuView!
    var playTSV : PlayTSV!
    var questionHandler : QuestionHandler!
    var settingsView : SettingsView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        // Set background color
        view.backgroundColor = UIColor(red: 43/255, green: 43/255, blue: 43/255, alpha: 1)

        // Read all the data from files
        allData = DataHandler.readData()

        // Initialize the current view as the splash screen
        currentView = .Splash
        
        //Initialize all of the views and set the delegate to this ViewController
        menuView = MenuView(frame: self.view.frame)
        menuView.delegate = self
        
        playTSV = PlayTSV(frame: self.view.frame)
        playTSV.delegate = self
        
        questionHandler = QuestionHandler(frame: self.view.frame)
        questionHandler.delegate = self
        
        settingsView = SettingsView(frame: self.view.frame)
        settingsView.delegate = self
        
        // Start the app by switching to the Main Menu
        switchBetweenViews(to: .Menu)
    }
    
    // Set light status bar to fit dark theme
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    // Function to switch between views. Animates out and removes the current view, then adds the next view to the ViewController's view and animates in the view.
    func switchBetweenViews(to: ViewType) {
        switch currentView! {
        case .Menu:
            menuView.animateOut(completion: {
                self.menuView.removeFromSuperview()
            })
            break
        case .PlayTSV:
            playTSV.animateOut(completion: {
                self.playTSV.removeFromSuperview()
            })
            break
        case .QuestionHandler:
            questionHandler.animateOut(completion: {
                self.questionHandler.removeFromSuperview()
            })
            break
        case .Settings:
            settingsView.animateOut(completion: {
                self.questionHandler.removeFromSuperview()
            })
            break
        default: break
            
        }
        
        switch to {
        case .Menu:
            self.view.addSubview(menuView)
            menuView.animateIn(completion: {

            })
            break
        case .PlayTSV:
            self.view.addSubview(playTSV)
            self.view.sendSubviewToBack(playTSV)
            playTSV.animateIn(completion: {
                self.view.bringSubviewToFront(self.playTSV)
            })
            break
        case .QuestionHandler:
            self.view.addSubview(questionHandler)
            questionHandler.animateIn(completion: {

            })
            break
        case .Settings:
            self.view.addSubview(settingsView)
            settingsView.animateIn(completion: {
                
            })
            break
        default:
            break
        }
        // Update the new view
        currentView = to
    }

    // Delegate functions to switch views
    func menuPlayButtonPressed() {
        switchBetweenViews(to: .PlayTSV)
    }
    
    func menuSettingsButtonPressed() {
        switchBetweenViews(to: .Settings)
    }

    func playTSVHomeButtonPressed() {
        switchBetweenViews(to: .Menu)
    }

    func playTSVPlayButtonPressed(selectedTopics: [Topic]) {
        questionHandler.setTopicSet(topics: selectedTopics)
        questionHandler.createQuestionView()
        
        switchBetweenViews(to: .QuestionHandler)
    }
    
    func questionHandlerHomeButtonPressed() {
        switchBetweenViews(to: .PlayTSV)
    }
    
    func settingsMenuButtonPressed(){
        switchBetweenViews(to: .Menu)
    }
    
    // Show the share sheet when pressed. This is called through delegate functions as it requires a ViewController
    func shareButton(text: String){
        let textShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textShare , applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
}

