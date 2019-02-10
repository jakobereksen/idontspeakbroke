//
//  NavigationController.swift
//  idontspeakbroke
//
//  Created by Jakob Sen on 14.01.19.
//  Copyright © 2019 Jakob Sen. All rights reserved.
//

import UIKit
import AVKit

class NavigationController: UINavigationController {
    
    private let session = AVAudioSession.sharedInstance()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        try! session.setCategory(.playAndRecord, mode: .default, options: .allowBluetooth)
        
        if(hasAirPods() || true) {
            //let welcomeScreen = MessageViewController()
            let welcomeScreen = EnterUsernameViewController()
            self.pushViewController(welcomeScreen, animated: false)
            self.isNavigationBarHidden = true;
            
        } else {
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
