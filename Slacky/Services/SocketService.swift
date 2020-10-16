//
//  SocketService.swift
//  Slacky
//
//  Created by vagelis spirou on 15/10/20.
//  Copyright © 2020 vagelis spirou. All rights reserved.
//

import UIKit
import SocketIO

class SocketService: NSObject {
    
    static let instance = SocketService()
    
    let manager: SocketManager
    let socket: SocketIOClient
    
 // Because we have the NSObject
    override init() {
        
        self.manager = SocketManager(socketURL: URL(string: BASE_URL)!)
        self.socket = manager.defaultSocket
        super.init()
    }
    
    func establishConnection() {
        
        socket.connect()
        
    }
    
    func closeConnection() {
        
        socket.disconnect()
        
    }
    
    func addChannel(channelName: String, channelDescription: String, completion: @escaping CompletionHandler) {
        
        socket.emit("newChannel", channelName, channelDescription)
        completion(true)
        
    }
    
    func getChannel(completion: @escaping CompletionHandler) {
        
        socket.on("channelCreated") { (dataArray, ack) in
            
            guard let channelName = dataArray[0] as? String else { return }
            guard let channelDescription = dataArray[1] as? String else { return }
            guard let channelId = dataArray[2] as? String else { return }
            
            let newChannel = Channel(title: channelName, description: channelDescription, id: channelId)
            MessageService.instance.channels.append(newChannel)
            completion(true)
            
        }
        
        
    }

}
