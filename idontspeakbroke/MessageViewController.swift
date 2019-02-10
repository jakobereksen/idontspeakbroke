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
    
    private let fireBaseAdapter = FirebaseAdapter()
    private let sender = Sender(id: "qweqweuniqueid", displayName: "messageboiilocal")
    private let andotherSender = Sender(id: "qweqweuniqueid2", displayName: "messageboiilocal")
    private var messages: [Message] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self
        messagesCollectionView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        messageInputBar.backgroundView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        messageInputBar.inputTextView.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        if let layout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout {
            layout.setMessageIncomingAvatarSize(.zero)
            layout.setMessageOutgoingAvatarSize(.zero)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fireBaseAdapter.addNewMessageHandler(appendMessage)
    }
    
    private func appendMessage(_ message: Message) {
        messages.append(message)
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
    }
}

extension MessageViewController: MessagesLayoutDelegate, MessagesDisplayDelegate {
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return message.sender == currentSender() ? #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) : #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
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
    
    func messageBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let attributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12.0, weight: .semibold)
        ]
        let text = message.sender.displayName.uppercased()
        return   NSAttributedString(string: text, attributes: attributes)
    }
    
    func messageBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return isLastMessageOfSameSender(message: message, indexPath: indexPath) && message.sender.id != sender.id ? 15.0 : 0.0
    }
}
