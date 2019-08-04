//
//  TitleBarViewController.swift
//  idontspeakbroke
//
//  Created by Jakob Sen on 03.03.19.
//  Copyright © 2019 Jakob Sen. All rights reserved.
//

import UIKit

class TitleBarView: UIView {
    
    let titleView: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        return label
    }()
    
    let blurView: UIVisualEffectView = {
        let blur = UIBlurEffect(style: UIBlurEffect.Style.light)
        let blurView = UIVisualEffectView(effect: blur)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        return blurView
    }()
    
    let titleContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    init(title: String?) {
        super.init(frame: .zero)
        
        if let title = title {
            titleView.text = title
        }
        
        self.addSubview(blurView)
        blurView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        blurView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        self.addSubview(titleContainer)
        titleContainer.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        titleContainer.heightAnchor.constraint(equalToConstant: 44).isActive = true
        titleContainer.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        titleContainer.addSubview(titleView)
        titleView.centerXAnchor.constraint(equalTo: titleContainer.centerXAnchor).isActive = true
        titleView.centerYAnchor.constraint(equalTo: titleContainer.centerYAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setTitle(title: String) {
        titleView.text = title
    }
}
