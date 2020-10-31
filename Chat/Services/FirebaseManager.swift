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
    
    func fetchChannels(completion: @escaping ([Channel]) -> Void) {
        var channels = [Channel]()
        channelRef.order(by: "lastActivity").getDocuments { (snapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in snapshot!.documents {
                    var date = Date()
                    let data = document.data()
                    let identifier = document.documentID
                    guard let name = data["name"] as? String else { return }
                    let lastMessage = data["lastMessage"] as? String? ?? "Сообщений еще не было"
                    if let lastActivity = data["lastActivity"] as? Timestamp {
                        date = Date(timeIntervalSince1970: TimeInterval(lastActivity.seconds))
                    }
                    
                    channels.append(Channel(identifier: identifier,
                                            name: name,
                                            lastMessage: lastMessage,
                                            lastActivity: date))
                    completion(channels)
                }
            }
        }
    }
    
    func fetchMessages(channel id: String, completion: @escaping ([Message]) -> Void) {
        var messages = [Message]()
        
        channelRef.document(id).collection("messages").order(by: "created").getDocuments { (snapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in snapshot!.documents {
                    let data = document.data()
                    
                    guard let content = data["content"] as? String else { return }
                    guard let created = data["created"] as? Timestamp else { return }
                    guard let senderId = data["senderId"] as? String else { return }
                    guard let senderName = data["senderName"] as? String else { return }
                    
                    messages.append(Message(content: content,
                                            created: Date(timeIntervalSince1970: TimeInterval(created.seconds)),
                                            senderId: senderId,
                                            senderName: senderName))
                    completion(messages)
                }
            }
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
}
