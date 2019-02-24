//
//  IDontSpeakBrokeViewController.swift
//  idontspeakbroke
//
//  Created by Jakob Sen on 12.02.19.
//  Copyright © 2019 Jakob Sen. All rights reserved.
//

import UIKit

let I_DONT_SPEAK_BROKE_TEXT = "Sorry,\nI don't speak broke."
let WELCOME_TEXT = "Nice headphones!"

class IDontSpeakBrokeViewController: UIViewController {
    
    private let entryDeniedLabel: UILabel = {
        let label = UILabel()
        label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 35, weight: .regular)
        label.numberOfLines = 2
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = I_DONT_SPEAK_BROKE_TEXT
        return label
    }()
    
    private let entryAllowedLabel: UILabel = {
        let label = UILabel()
        label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 35, weight: .regular)
        label.numberOfLines = 1
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = WELCOME_TEXT
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
    
    public func transitionToEntryAllowed(completion: (() -> Void)?) {
        hideEntryDeniedLabel {
            self.showEntryAllowedLabel(completion: completion)
        }
    }
    
    public func transitionFromEntryAllowed(completion: (() -> Void)?) {
        self.showEntryAllowedLabel(completion: completion)
    }
    
    public func showInitialLabel() {
        self.showEntryDeniedLabel(completion: nil)
    }
    
    private func showEntryDeniedLabel(completion: (() -> Void)?) {
        self.view.addSubview(entryDeniedLabel)
        entryDeniedLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        entryDeniedLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        self.entryDeniedLabel.transform = CGAffineTransform(translationX: 0, y: -30)
        self.entryDeniedLabel.layer.opacity = 0
        
        
        UIView.animate(withDuration: 0.3, delay: 0.3, animations: {
            UIView.setAnimationCurve(.easeOut)
            self.entryDeniedLabel.transform = CGAffineTransform(translationX: 0, y: 0)
            self.entryDeniedLabel.layer.opacity = 1
        }, completion: {(successful: Bool) -> Void in completion?()})
    }
    
    private func hideEntryDeniedLabel(completion: (() -> Void)?) {
        UIView.animate(withDuration: 0.3, animations: {
            UIView.setAnimationCurve(.easeOut)
            self.entryDeniedLabel.transform = CGAffineTransform(translationX: 0, y: 30)
            self.entryDeniedLabel.layer.opacity = 0
        }, completion: {(successful: Bool) -> Void in
            self.entryDeniedLabel.removeFromSuperview()
            completion?()
        })
    }
    
    private func showEntryAllowedLabel(completion: (() -> Void)?) {
        self.view.addSubview(entryAllowedLabel)
        entryAllowedLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        entryAllowedLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        self.entryAllowedLabel.transform = CGAffineTransform(translationX: 0, y: -30)
        self.entryAllowedLabel.layer.opacity = 0
        
        UIView.animateKeyframes(withDuration: 3, delay: 0, options: .calculationModeCubic, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.3 / 3, animations: {
                UIView.setAnimationCurve(.easeOut)
                self.entryAllowedLabel.transform = CGAffineTransform(translationX: 0, y: 0)
                self.entryAllowedLabel.layer.opacity = 1
            })
            UIView.addKeyframe(withRelativeStartTime: 2.5 / 3, relativeDuration: 0.3 / 3, animations: {
                UIView.setAnimationCurve(.easeOut)
                self.entryAllowedLabel.transform = CGAffineTransform(translationX: 0, y: 30)
                self.entryAllowedLabel.layer.opacity = 0
            })
        }, completion: {(successful: Bool) -> Void in
            self.entryAllowedLabel.removeFromSuperview()
            completion?()
        })
    }
}
