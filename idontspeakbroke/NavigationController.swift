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
    private var showingIDontSpeakBrokeScreen = false
    private let iDontSpeakBrokeScreen = IDontSpeakBrokeViewController()
    
    private var hasAirPods2 = false

    override func viewDidLoad() {
        super.viewDidLoad()
         self.isNavigationBarHidden = true;
        try! session.setCategory(.playAndRecord, mode: .default, options: .allowBluetooth)
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: self.handleIntervalBlock)
        Timer.scheduledTimer(withTimeInterval: 4, repeats: false) { (timer) in
            self.hasAirPods2 = true
        }
    }
    
    public func pushMessageViewController(withSender sender: Sender) {
        self.pushViewController(MessageViewController(user: sender), animated: false)
    }
    
    private func handleIntervalBlock(timer: Timer) {
        if(self.hasAirPods()) {
            let screen = EnterUsernameViewController()
            
            iDontSpeakBrokeScreen.startTransition(completion: {_ in
                self.pushViewController(screen, animated: false)
            })
            timer.invalidate()
        } else if(!showingIDontSpeakBrokeScreen) {
            showingIDontSpeakBrokeScreen = true
            self.pushViewController(iDontSpeakBrokeScreen, animated: false)
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
        return false;
    }
}
