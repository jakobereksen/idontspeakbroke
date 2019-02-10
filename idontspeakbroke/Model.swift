//
//  Model.swift
//  idontspeakbroke
//
//  Created by Jakob Sen on 10.02.19.
//  Copyright © 2019 Jakob Sen. All rights reserved.
//

import Foundation
import MessageKit

class Message: MessageType {
    var sender: Sender
    var messageId: String
    var sentDate: Date
    var kind: MessageKind
    
    init(sender: Sender, messageId: String, sentDate: Date, content: String) {
        self.sender = sender
        self.messageId = messageId
        self.sentDate = sentDate
        self.kind = MessageKind.text(content)
    }
}
