//
//  MessageViewController.swift
//  idontspeakbroke
//
//  Created by Jakob Sen on 14.01.19.
//  Copyright © 2019 Jakob Sen. All rights reserved.
//

import UIKit
import MessageKit
import MessageInputBar

class MessageViewController: MessagesViewController {
    private let sender: Sender
    private var messages: [Message] = []
    private let titleBar = TitleBarView(title: "spoiled kids 💰")
    
    init(user: Sender) {
        sender = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        setMessageInputBar()
        
        if let layout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout {
            layout.setMessageIncomingAvatarSize(.zero)
            layout.setMessageOutgoingAvatarSize(.zero)
            layout.sectionInset = UIEdgeInsets(top: 2.5, left: 0, bottom: 2.5, right: 0)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setTitleBar()
    }
    
    private func setTitleBar() {
        self.view.addSubview(titleBar)
        titleBar.translatesAutoresizingMaskIntoConstraints = false
        titleBar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        titleBar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        titleBar.heightAnchor.constraint(equalToConstant: view.safeAreaInsets.top + 44).isActive = true
        titleBar.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
    }
    
    private func setMessageInputBar() {
        messageInputBar = MessageInputBar()
        messageInputBar.delegate = self
        messageInputBar.sendButton.tintColor = UIColor(red: 69/255, green: 193/255, blue: 89/255, alpha: 1)
        messageInputBar.isTranslucent = true
        messageInputBar.separatorLine.isHidden = true
        messageInputBar.inputTextView.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
        messageInputBar.inputTextView.placeholderTextColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
        messageInputBar.inputTextView.textContainerInset = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 36)
        messageInputBar.inputTextView.placeholderLabelInsets = UIEdgeInsets(top: 8, left: 20, bottom: 8, right: 36)
        messageInputBar.inputTextView.layer.borderColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1).cgColor
        messageInputBar.inputTextView.layer.borderWidth = 1.0
        messageInputBar.inputTextView.layer.cornerRadius = 16.0
        messageInputBar.inputTextView.layer.masksToBounds = true
        messageInputBar.inputTextView.scrollIndicatorInsets = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        messageInputBar.setRightStackViewWidthConstant(to: 36, animated: false)
        messageInputBar.setStackViewItems([messageInputBar.sendButton], forStack: .right, animated: true)
        messageInputBar.sendButton.imageView?.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
        messageInputBar.sendButton.contentEdgeInsets = UIEdgeInsets(top: 2, left: 2, bottom: 4, right: 2)
        messageInputBar.sendButton.setSize(CGSize(width: 36, height: 36), animated: true)
        messageInputBar.sendButton.image = #imageLiteral(resourceName: "Send")
        messageInputBar.sendButton.title = nil
        messageInputBar.sendButton.imageView?.layer.cornerRadius = 16
        messageInputBar.sendButton.backgroundColor = .clear
        messageInputBar.textViewPadding.right = -38
        messageInputBar.textViewPadding.top = 20
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print(messages)
        fireBaseAdapter.addNewMessageHandler(appendMessage)
    }
    
    private func appendMessage(_ message: Message) {
        messages.append(message)
        print(message.kind)
//        messages.sort { (firstMessage, secondMessage) -> Bool in
//            return firstMessage.sentDate.compare(secondMessage.sentDate) == .orderedAscending
//        }
        self.messagesCollectionView.reloadData()
        if(messages.count > 1) {
            self.messagesCollectionView.reloadItems(at: [IndexPath(row: 0, section: messages.count - 2)])
        }
        self.messagesCollectionView.scrollToBottom(animated: true)
    }
    
    private func isLastMessageOfSameSender(message: MessageType, indexPath: IndexPath) -> Bool {
        if(indexPath.section  == messages.count - 1) {
            return true
        } else if(message.sender.id != messages[indexPath.section + 1].sender.id) {
            return true
        } else {
            return false
        }
    }
    
    private func isFirstMessageOfSameSender(message: MessageType, indexPath: IndexPath) -> Bool {
        if(indexPath.section  == 0) {
            return true
        } else if(message.sender.id != messages[indexPath.section - 1].sender.id) {
            return true
        } else {
            return false
        }
    }
}

extension MessageViewController: MessagesDataSource {
    func currentSender() -> Sender {
        return sender
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return self.messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return self.messages.count
    }
}

extension MessageViewController: MessageInputBarDelegate {
    func messageInputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String) {
        let message = Message(sender: sender, messageId: "", sentDate: Date(timeIntervalSinceNow: 0), content: text)
        fireBaseAdapter.saveMessage(message)
        messageInputBar.inputTextView.text = ""
    }
}

extension MessageViewController: MessagesLayoutDelegate, MessagesDisplayDelegate {
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return message.sender == currentSender() ? #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) : #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if(section == 0) {
             return UIEdgeInsets(top: 44, left: 0, bottom: 0, right: 0)
        } else {
             return UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
        }
    }
    
    func messageLabelInset(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    }
    
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        
        let isCurrentSender = sender == message.sender
        
        let showTail = isLastMessageOfSameSender(message: message, indexPath: indexPath)
        
        if(showTail) {
            let corner: MessageStyle.TailCorner = isCurrentSender ? .bottomRight : .bottomLeft
            return .bubbleTail(corner, .pointedEdge)
        } else {
            return .bubble
        }
    }
    
    func messageTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let attributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 8.0, weight: .semibold),
            NSAttributedString.Key.foregroundColor: UIColor.lightGray
        ]
        let text = message.sender.displayName.uppercased()
        return   NSAttributedString(string: text, attributes: attributes)
    }
    
    func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return isFirstMessageOfSameSender(message: message, indexPath: indexPath) && message.sender.id != sender.id ? 15.0 : 0.0
    }
}
