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
    var questionHandler : QuestionHandler!;
    var settingsView : SettingsView!;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        allData = DataHandler.readData()

        currentView = .Splash
        
        menuView = MenuView(frame: self.view.frame)
        menuView.delegate = self
        
        playTSV = PlayTSV(frame: self.view.frame)
        playTSV.delegate = self
        
        questionHandler = QuestionHandler(frame: self.view.frame)
        questionHandler.delegate = self
        
        settingsView = SettingsView(frame: self.view.frame)
        settingsView.delegate = self
        
        switchBetweenViews(to: .Menu)
    }
    
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
            break;
        case .Settings:
            settingsView.animateOut(completion: {
                self.questionHandler.removeFromSuperview()
            })
            break;
        default: break
            
        }
        
        switch to {
        case .Menu:
            self.view.addSubview(menuView)
            menuView.animateIn(completion: {

            })
            break;
        case .PlayTSV:
            self.view.addSubview(playTSV)
            self.view.sendSubviewToBack(playTSV)
            playTSV.animateIn(completion: {
                self.view.bringSubviewToFront(self.playTSV) //TODO without this, playTSV becomes unresponsive
            })
            break;
        case .QuestionHandler:
            self.view.addSubview(questionHandler)
            questionHandler.animateIn(completion: {

            })
            break;
        case .Settings:
            self.view.addSubview(settingsView)
            settingsView.animateIn(completion: {
                
            })
            break;
        default:
            break;
        }
        currentView = to
    }

    func menuPlayButtonPressed() {
        switchBetweenViews(to: .PlayTSV)
    }
    
    func menuLearnButtonPressed() {
        switchBetweenViews(to: .PlayTSV)
    }
    
    func menuSettingsButtonPressed() {
        switchBetweenViews(to: .Settings)
    }

    func playTSVPlayButtonPressed(selectedTopics: [Topic]) {
//        questionHandler.topicSet = selectedTopics
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
}

