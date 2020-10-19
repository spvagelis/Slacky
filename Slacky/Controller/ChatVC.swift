//
//  ChatVC.swift
//  Slacky
//
//  Created by vagelis spirou on 5/10/20.
//  Copyright © 2020 vagelis spirou. All rights reserved.
//

import UIKit

class ChatVC: UIViewController {
    
    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var channelNameLbl: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        
        self.view.addGestureRecognizer((self.revealViewController()?.panGestureRecognizer())!)
        self.view.addGestureRecognizer((self.revealViewController()?.tapGestureRecognizer())!)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.userDataDidChange(_:)), name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.channelSelected(_:)), name: NOTIF_CHANNEL_SELECTED, object: nil)
        
        if AuthService.instance.isLoggedIn {
            
            AuthService.instance.findUserByEmail { (success) in
                
                if success {
                    
                   NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
                    
                }
            }
        }
    }
    
    @objc func userDataDidChange(_ notification: Notification) {
        
        if AuthService.instance.isLoggedIn {
    
            // get channels
            onLoginGetMessages()
            
        } else {
            
            channelNameLbl.text = "Please Log In"
            
        }
    }
    
    @objc func channelSelected(_ notification: Notification) {
        
       updateWithChannel()
        
    }
    
    func updateWithChannel() {
        
        let channelName = MessageService.instance.selectedChannel?.title ?? ""
        channelNameLbl.text = "#\(channelName)"
        getMessages()
    }
    
    func onLoginGetMessages() {
        MessageService.instance.findAllChannel { (success) in
            
            if success {
                // Do stuff with channels
                if MessageService.instance.channels.count > 0 {
                    
                    MessageService.instance.selectedChannel = MessageService.instance.channels[0]
                    self.updateWithChannel()
                } else {
                    self.channelNameLbl.text = "No channels yet!"
                }
            }
        }
    }
    
    func getMessages() {
        
        guard let channelId = MessageService.instance.selectedChannel?.id else { return }
        MessageService.instance.findAllMessagesFromSpecificChannel(channelId: channelId) { (success) in
            
            
            
        }
    }
}
