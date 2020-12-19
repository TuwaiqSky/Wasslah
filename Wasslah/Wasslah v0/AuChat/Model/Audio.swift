//
//  Audio.swift
//  AuChat
//
//  Created by Hanan on 05/12/2020.
//

import Foundation

class Audio {
    var audioURL: String
    var audioDate: Date
    var senderID: String
    var reciverID: String
    var senderName: String
    
    init(audioURL: String, audioDate: Date, senderID: String, senderName: String ,reciverID: String) {
        self.audioURL = audioURL
        self.audioDate = audioDate
        self.reciverID = reciverID
        self.senderID = senderID
        self.senderID = senderID
        self.senderName = senderName
    }

}
