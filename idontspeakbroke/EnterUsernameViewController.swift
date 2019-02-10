    //
//  EnterUsernameViewController.swift
//  idontspeakbroke
//
//  Created by Jakob Sen on 10.02.19.
//  Copyright © 2019 Jakob Sen. All rights reserved.
//

import UIKit
import NotificationCenter

class EnterUsernameViewController: UIViewController {
    
    private let keyboardPlaceholderView = UIView(frame: .zero)
    private var keyboardPlaceholderViewHeightConstraint = NSLayoutConstraint()
    
    private let userNameInput: UITextField = {
        let userNameInput = UITextField(frame: .zero)
        userNameInput.translatesAutoresizingMaskIntoConstraints = false
        userNameInput.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        userNameInput.placeholder = "enter username..."
        userNameInput.font = UIFont.systemFont(ofSize: 30.0, weight: .regular)
        userNameInput.textAlignment = .center
        return userNameInput
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeShown), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        layoutUserNameInput()
    }
    
    @objc private func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        userNameInput.resignFirstResponder()
    }
    
    @objc private func keyboardWillBeShown(notification: Notification) {
        if let keyboardSize = notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? CGRect {
            keyboardPlaceholderViewHeightConstraint.constant = keyboardSize.height
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc private func keyboardWillHide(notification: Notification) {
            keyboardPlaceholderViewHeightConstraint.constant = 0
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
    }
    
    private func layoutUserNameInput() {
        keyboardPlaceholderView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(keyboardPlaceholderView)
        
        let inputContainerView = UIView(frame: .zero)
        inputContainerView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(inputContainerView)
        
        inputContainerView.addSubview(userNameInput)
        
        inputContainerView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        inputContainerView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        inputContainerView.bottomAnchor.constraint(equalTo: keyboardPlaceholderView.topAnchor).isActive = true
        
        keyboardPlaceholderView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        keyboardPlaceholderViewHeightConstraint = keyboardPlaceholderView.heightAnchor.constraint(equalToConstant: 0)
        keyboardPlaceholderViewHeightConstraint.isActive = true
        keyboardPlaceholderView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        
        
        
        userNameInput.centerXAnchor.constraint(equalTo: inputContainerView.centerXAnchor).isActive = true
        userNameInput.centerYAnchor.constraint(equalTo: inputContainerView.centerYAnchor).isActive = true
        userNameInput.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor, constant: -30).isActive = true
    }
}
