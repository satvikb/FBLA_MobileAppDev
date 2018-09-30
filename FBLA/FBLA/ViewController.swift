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

var transitionTime : CGFloat = 0.5
var allData : AllData!

class ViewController: UIViewController, MenuViewDelegate, PlayTSVDelegate, QuestionHandlerDelegate {

    

    var currentView : ViewType!
    
    var menuView : MenuView!
    var playTSV : PlayTSV!
    var questionHandler : QuestionHandler!;
    
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
        
        switchBetweenViews(to: .Menu)
        print("SDF")
        
       
    }
    
    func switchBetweenViews(to: ViewType) {
        switch currentView! {
        case .Menu:
            menuView.animateOut(completion: {
                print("menu animate out done")
                self.menuView.removeFromSuperview()

            })
            break
        case .PlayTSV:
            playTSV.animateOut(completion: {
                print("play tsv animate out done")
                self.playTSV.removeFromSuperview()
            })
            break
        case .QuestionHandler:
            questionHandler.animateOut(completion: {
                self.questionHandler.removeFromSuperview()
            })
            break;
        default: break
            
        }
        
        switch to {
        case .Menu:
            self.view.addSubview(menuView)
            menuView.animateIn(completion: {
                print("menu animate in done")
            })
            break;
        case .PlayTSV:
            self.view.addSubview(playTSV)
            playTSV.animateIn(completion: {
                print("play tsv animate in done")
            })
            break;
        case .QuestionHandler:
            self.view.addSubview(questionHandler)
            questionHandler.animateIn(completion: {
                print("question handler animate in")
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

    func playTSVPlayButtonPressed(selectedTopics: [Topic]) {
        questionHandler.topicSet = selectedTopics
        questionHandler.createQuestionView()
        
        switchBetweenViews(to: .QuestionHandler)
    }
}

