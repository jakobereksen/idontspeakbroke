//
//  FirebaseAdapter.swift
//  idontspeakbroke
//
//  Created by Jakob Sen on 10.02.19.
//  Copyright © 2019 Jakob Sen. All rights reserved.
//

import Firebase
import MessageKit

struct FirebaseAdapter {
    private let messageCollectionReference: CollectionReference
    private let userCollectionReference: CollectionReference
    
    func createNewSender(forDisplayName displayName: String) -> Sender {
        let data = ["displayName": displayName]
        let documentReference = userCollectionReference.addDocument(data: data)
        let sender = Sender(id: documentReference.documentID, displayName: displayName)
        return sender
    }
    
    func saveMessage(_ message: MessageType) {
        let content: String
        
        switch message.kind {
        case let .text(value):
            content = value
            break
        default:
            return
        }
        
        messageCollectionReference.addDocument(data: [
                "content": content,
                "created": message.sentDate.timeIntervalSince1970,
                "senderId": message.sender.id,
                "senderName": message.sender.displayName
            ])
    }
    
    func addNewMessageHandler(_ changeHandler: @escaping (_ message: Message) -> Void) {
        messageCollectionReference.addSnapshotListener { querySnapshot, error in
            guard let snapshot = querySnapshot else {
                print("Error listening for message updates: \(error?.localizedDescription ?? "No error")")
                return
            }
            
            snapshot.documentChanges.forEach { change in
                
                if(change.type != DocumentChangeType.added) {
                    return
                }
                
                let data = change.document.data()
                
                guard let senderId = data["senderId"] as? String else { return }
                guard let displayName = data["senderName"] as? String else { return }
                guard let content = data["content"] as? String else { return }
                guard let sentDateUnix = data["created"] as? Double else { return }
               
                let message = Message(sender: Sender(id: senderId, displayName: displayName), messageId: change.document.documentID, sentDate: Date(timeIntervalSince1970: sentDateUnix), content: content)
                changeHandler(message)
            }
        }
    }
    
    init() {
        FirebaseApp.configure()
        let db = Firestore.firestore()
        messageCollectionReference = db.collection("/messages")
        userCollectionReference = db.collection("/user")
        db.settings.areTimestampsInSnapshotsEnabled = true
    }
}
