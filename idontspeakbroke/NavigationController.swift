//
//  NavigationController.swift
//  idontspeakbroke
//
//  Created by Jakob Sen on 14.01.19.
//  Copyright © 2019 Jakob Sen. All rights reserved.
//

import UIKit
import AVKit
import MessageKit
import Foundation

class NavigationController: UINavigationController {
    private let session = AVAudioSession.sharedInstance()
    private let iDontSpeakBrokeScreen = IDontSpeakBrokeViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.isNavigationBarHidden = true;
        self.interactivePopGestureRecognizer?.isEnabled = false
        try! session.setCategory(.playAndRecord, mode: .default, options: .allowBluetooth)
        
        self.pushViewController(iDontSpeakBrokeScreen, animated: false)
        if(self.hasAirPods()) {
            iDontSpeakBrokeScreen.transitionFromEntryAllowed(completion: pushEnterUserNameScreen)
        } else {
            iDontSpeakBrokeScreen.showInitialLabel()
            Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: self.handleIntervalBlock)
        }
    }
    
    public func pushMessageViewController(withSender sender: Sender) {
        self.pushViewController(MessageViewController(user: sender), animated: false)
    }
    
    private func pushEnterUserNameScreen() {
        let screen = EnterUsernameViewController()
        self.pushViewController(screen, animated: false)
    }
    
    private func handleIntervalBlock(timer: Timer) {
        if(self.hasAirPods()) {
            iDontSpeakBrokeScreen.transitionToEntryAllowed(completion: pushEnterUserNameScreen)
            timer.invalidate()
        }
    }
    
    private func hasAirPods() -> Bool {
        guard let availableInputs = session.availableInputs else {
            return false
        }
        for input in availableInputs {
            if input.portName.contains("AirPods") {
                return true
            }
        }
        return false
    }
}
