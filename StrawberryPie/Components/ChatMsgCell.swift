//
//  ChatMsgCell.swift
//  StrawberryPie
//
//  Created by iosdev on 10/12/2019.
//  Copyright © 2019 Team Työkkäri. All rights reserved.
//
// Reusable cell for chat message cells. Has a .xib file for styling.


import UIKit

class ChatMsgCell: UITableViewCell {
    @IBOutlet weak var msgSender: UILabel!
    @IBOutlet weak var msgBody: UILabel!
    @IBOutlet weak var msgTimestamp: UILabel!
}
