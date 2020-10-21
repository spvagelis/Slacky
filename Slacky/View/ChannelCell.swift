//
//  ChannelCell.swift
//  Slacky
//
//  Created by vagelis spirou on 15/10/20.
//  Copyright © 2020 vagelis spirou. All rights reserved.
//

import UIKit

class ChannelCell: UITableViewCell {

    @IBOutlet weak var channelName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        
        if selected {
            self.layer.backgroundColor = UIColor(white: 1, alpha: 0.2).cgColor
        } else {
            self.layer.backgroundColor = UIColor.clear.cgColor
        }
    }
    
    func configureCell(channel: Channel) {
        
        let title = channel.title ?? ""
        
        channelName.text = "#\(String(describing: channel.title))"
        channelName.font = UIFont(name: "AvenirNext-Regular", size: 17)
        
        for id in MessageService.instance.unreadChannels {
            
            if id == channel.id {
                
                channelName.font = UIFont(name: "AvenirNext-Regular", size: 22)
                
            }
        }
    }
}
