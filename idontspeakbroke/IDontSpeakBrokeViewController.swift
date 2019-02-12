//
//  IDontSpeakBrokeViewController.swift
//  idontspeakbroke
//
//  Created by Jakob Sen on 12.02.19.
//  Copyright © 2019 Jakob Sen. All rights reserved.
//

import UIKit

let I_DONT_SPEAK_BROKE_TEXT = "Sorry,\nI don't speak broke."

class IDontSpeakBrokeViewController: UIViewController {

    private let label: UILabel = {
        let label = UILabel()
        label.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        label.font = UIFont.systemFont(ofSize: 30, weight: .regular)
        label.numberOfLines = 2
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(label)
        self.view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        label.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        label.animate(newText: I_DONT_SPEAK_BROKE_TEXT, characterDelay: 0.1)
    }
    
    public func startTransition(completion: @escaping (Bool) -> Void) {
        UIView.animate(withDuration: 0.6, animations: {
            UIView.setAnimationCurve(.easeInOut)
            self.label.transform = CGAffineTransform(translationX: 0, y: -30)
            self.label.layer.opacity = 0
            self.view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }, completion: completion)
    }
}

extension UILabel {
    func animate(newText: String, characterDelay: TimeInterval) {
        DispatchQueue.main.async {
            self.text = ""
            for (index, character) in newText.enumerated() {
                DispatchQueue.main.asyncAfter(deadline: .now() + characterDelay * Double(index)) {
                    self.text?.append(character)
                }
            }
        }
    }
}
