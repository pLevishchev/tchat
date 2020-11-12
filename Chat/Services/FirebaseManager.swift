//
//  FirebaseManager.swift
//  Chat
//
//  Created by Павел Левищев on 29.10.2020.
//  Copyright © 2020 p.levishchev. All rights reserved.
//

import Foundation
import Firebase

class FirebaseManager {
    
    lazy var db = Firestore.firestore()
    lazy var channelRef = db.collection("channels")
    
    func fetchChannels(completion: @escaping (Error?) -> Void) {
        channelRef.order(by: "lastActivity").addSnapshotListener { snapshot, error in
            if let error = error {
                completion(error)
                return
            }
            CoreDataManager.shared.removeChannels()
            guard let snapshot = snapshot else { return }
            let channels = snapshot.documents.compactMap { document -> Channel? in

                let channel = Channel(data: document.data(), documentID: document.documentID)
                return channel
            }
            CoreDataManager.shared.saveChannelsToDB(channels: channels)
            completion(nil)
        }
    }
    
    func fetchMessages(channel id: String, completion: @escaping (Error?) -> Void) {
        let messagesReference = channelRef.document(id).collection("messages")
        
        messagesReference.order(by: "created").addSnapshotListener { snapshot, error in
            
            if let error = error {
                completion(error)
                return
            }
            CoreDataManager.shared.removeMessages()
            guard let snapshot = snapshot else { return }
            let messages = snapshot.documents.compactMap { document -> Message? in
                let message = Message(data: document.data(), documentID: document.documentID)
                return message
            }
            
            CoreDataManager.shared.saveMessagesToDB(channelID: id, messages: messages)
            completion(nil)
        }
    }
    
    func generateChannelId() -> String {
        return channelRef.document().documentID
    }
    
    func writeChannel(channel: Channel) {        
        channelRef.document(channel.identifier).setData([
            "identifier": channel.identifier,
            "name": channel.name,
            "lastMessage": "",
            "lastActivity": FieldValue.serverTimestamp()
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print(channel)
            }
        }
    }
    
    func writeMessage(in channel: String, message: Message) {
        channelRef.document(channel).collection("messages").document().setData([
            "content": message.content,
            "created": FieldValue.serverTimestamp(),
            "senderId": message.senderId,
            "senderName": message.senderName
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print(channel)
            }
        }
    }
    
    func deleteChannel(id channel: String, complition: @escaping (Error?) -> Void) {
        channelRef.document(channel).delete { (error) in
            if let error = error {
                complition(error)
            } else {
                complition(nil)
            }
        }
    }
}
