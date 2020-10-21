//
//  ChannelVC.swift
//  Slacky
//
//  Created by vagelis spirou on 5/10/20.
//  Copyright © 2020 vagelis spirou. All rights reserved.
//

import UIKit

class ChannelVC: UIViewController {
    
    @IBOutlet weak var profileImageView: CircleImage!
    @IBOutlet weak var logInBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue){
        
        profileImageView.image = UIImage(named: UserDataService.instance.avatarName)
        profileImageView.backgroundColor = UserDataService.instance.returnUIColor(components: UserDataService.instance.avatarColor)
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self

        profileImageView.image = UIImage(named: "profileDefault")
        self.revealViewController()?.rearViewRevealWidth = self.view.frame.size.width - 60
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChannelVC.userDataDidChange(_:)), name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChannelVC.channelsLoaded(_:)), name: NOTIF_CHANNELS_LOADED, object: nil)
        
        SocketService.instance.getChannel { (success) in
            
            if success {
                
                self.tableView.reloadData()
                
            }
        }
        
        SocketService.instance.getChatMessage { (newMessage) in
            
            if newMessage.channelId != MessageService.instance.selectedChannel?.id && AuthService.instance.isLoggedIn {
                
                MessageService.instance.unreadChannels.append(newMessage.channelId)
                self.tableView.reloadData()
                
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setupUserInfo()
    }
    
    @objc func userDataDidChange(_ notification: Notification) {
        
        setupUserInfo()
        
    }
    
    @IBAction func addChannelPressed(_ sender: UIButton) {
        
        if AuthService.instance.isLoggedIn {
           
            let addChannel = AddChannelVC()
            addChannel.modalPresentationStyle = .custom
            present(addChannel, animated: true, completion: nil)
            
        }
    }
    

    @IBAction func logInBtnPressed(_ sender: UIButton) {
        
        if AuthService.instance.isLoggedIn {
            // Show profile page
            let profile = ProfileVC()
            profile.modalPresentationStyle = .custom
            present(profile, animated: true, completion: nil)
            
        } else {
            
            performSegue(withIdentifier: TO_LOGIN, sender: nil)
            
        }
    }
    
    func setupUserInfo() {
        
        if AuthService.instance.isLoggedIn {
            
            logInBtn.setTitle(UserDataService.instance.name, for: .normal)
            profileImageView.image = UIImage(named: UserDataService.instance.avatarName)
            profileImageView.backgroundColor = UserDataService.instance.returnUIColor(components: UserDataService.instance.avatarColor)
            
        } else {
            
            logInBtn.setTitle("Login", for: .normal)
            profileImageView.image = UIImage(named: "menuProfileIcon")
            profileImageView.backgroundColor = UIColor.clear
            tableView.reloadData()
            
        }
        
    }
    
    @objc func channelsLoaded(_ notification: Notification) {
        
        tableView.reloadData()
        
    }
    
}

extension ChannelVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return MessageService.instance.channels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        print("The channels are: \(MessageService.instance.channels)")
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "channelCell", for: indexPath) as? ChannelCell else { return ChannelCell() }
        let channel = MessageService.instance.channels[indexPath.row]
        cell.configureCell(channel: channel)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let channel = MessageService.instance.channels[indexPath.row]
        MessageService.instance.selectedChannel = channel
        
        if MessageService.instance.unreadChannels.count > 0 {
            
            MessageService.instance.unreadChannels = MessageService.instance.unreadChannels.filter{ $0 != channel.id }
        }
        
        let index = IndexPath(row: indexPath.row, section: 0)
        tableView.reloadRows(at: [index], with: .none)
        tableView.selectRow(at: index, animated: false, scrollPosition: .none)
        
        NotificationCenter.default.post(name: NOTIF_CHANNEL_SELECTED, object: nil)
        
        self.revealViewController()?.revealToggle(animated: true)
    }
}
