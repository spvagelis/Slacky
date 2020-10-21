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
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var typingUserLbl: UILabel!
    
    var isTyping = false
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableView.automaticDimension
        
        sendBtn.isHidden = true
        
        menuBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        
        self.view.addGestureRecognizer((self.revealViewController()?.panGestureRecognizer())!)
        self.view.addGestureRecognizer((self.revealViewController()?.tapGestureRecognizer())!)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.userDataDidChange(_:)), name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.channelSelected(_:)), name: NOTIF_CHANNEL_SELECTED, object: nil)
        
        SocketService.instance.getChatMessage { (newMessage) in
            
            if newMessage.channelId == MessageService.instance.selectedChannel?.id && AuthService.instance.isLoggedIn {
                
                MessageService.instance.messages.append(newMessage)
                self.tableView.reloadData()
                
                if MessageService.instance.messages.count > 0 {
                    
                    let endIndex = IndexPath(row: MessageService.instance.messages.count - 1, section: 0)
                    self.tableView.scrollToRow(at: endIndex, at: .bottom, animated: false)
                    
                }
            }
        }
//        SocketService.instance.getChatMessage { (success) in
//            if success {
//                self.tableView.reloadData()
//
//                if MessageService.instance.messages.count > 0 {
//
//                    let endIndex = IndexPath(row: MessageService.instance.messages.count - 1, section: 0)
//                    self.tableView.scrollToRow(at: endIndex, at: .bottom, animated: false)
//                }
//            }
//        }
        
        SocketService.instance.getTypingUsers { (typingUsers) in
            guard let channelId = MessageService.instance.selectedChannel?.id else { return }
            var names = ""
            var numberOfTypers = 0
            
            for (typingUser, channel) in typingUsers {
                
                if typingUser != UserDataService.instance.name && channel == channelId {
                    
                    if names == "" {
                        
                        names = typingUser
                        
                    } else {
                        names = "\(names), \(typingUser)"
                    }
                    numberOfTypers += 1
                }
            }
            
            if numberOfTypers > 0 && AuthService.instance.isLoggedIn {
                
                var verb = "is"
                
                if numberOfTypers > 1 {
                    
                    verb = "are"
                    
                }
                
                self.typingUserLbl.text = "\(names) \(verb) typing a message"
                
            } else {
                
                self.typingUserLbl.text = ""
                
            }
        }
        
        if AuthService.instance.isLoggedIn {
            
            AuthService.instance.findUserByEmail { (success) in
                
                if success {
                    
                   NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
                    
                }
            }
        }
    }
    
    @objc func handleTap() {
        
        view.endEditing(true)
        
    }
    
    deinit {
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
    }
    
    @objc func keyboardWillChange(notification: Notification) {
        
        guard let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        if notification.name == UIResponder.keyboardWillShowNotification || notification.name == UIResponder.keyboardWillChangeFrameNotification {
            
            view.frame.origin.y = -keyboardRect.height
            
        } else {
            
            view.frame.origin.y = 0
            
        }
        
    }
    
    @objc func userDataDidChange(_ notification: Notification) {
        
        if AuthService.instance.isLoggedIn {
    
            // get channels
            onLoginGetMessages()
            
        } else {
            
            channelNameLbl.text = "Please Log In"
            tableView.reloadData()
            
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
    
    @IBAction func messageBoxEditing(_ sender: UITextField) {
        
        guard let channelId = MessageService.instance.selectedChannel?.id else { return }
        let userName = UserDataService.instance.name
        
        if messageTextField.text == "" {
            isTyping = false
            sendBtn.isHidden = true
            
            SocketService.instance.socket.emit("stopType", userName, channelId)
            
        } else {
            if isTyping == false {
                sendBtn.isHidden = false
                
                SocketService.instance.socket.emit("startType", userName, channelId)
                
            }
            isTyping = true
        }
    }
    
    @IBAction func sendMessagePressed(_ sender: UIButton) {
        
        if AuthService.instance.isLoggedIn {
            
            guard let channelId = MessageService.instance.selectedChannel?.id else { return }
            guard let message = messageTextField.text else { return }
            let userName = UserDataService.instance.name
            
            SocketService.instance.addMessage(messageBody: message, userId: UserDataService.instance.id, channelId: channelId) { (success) in
                
                if success {
                    self.messageTextField.text = ""
                    self.messageTextField.resignFirstResponder()
                    SocketService.instance.socket.emit("stopType", userName, channelId)
                }
            }
        }
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
           
            if success {
                self.tableView.reloadData()
            }
        }
    }
}

extension ChatVC: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return MessageService.instance.messages.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as? MessageCell else { return UITableViewCell() }
        
        let message = MessageService.instance.messages[indexPath.row]
        cell.configureCell(message: message)
        
        return cell
    }
}
