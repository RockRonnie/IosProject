//
//  PrivateMessageController.swift
//  StrawberryPie
//
//  Created by iosdev on 23/11/2019.
//  Copyright © 2019 Team Työkkäri. All rights reserved.
//

import UIKit
import RealmSwift

class PrivateMessageController: UIViewController {
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var messageField: UITextField!
    @IBOutlet weak var sendBtn: UIButton!
    
    var chatInstance: Chat?
    var realm: Realm?
    var user: User?
    var chatPartner: User?
    
    var notificationToken: NotificationToken?
    var messages: List<ChatMessage>?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup(){
        print("Private CHAT!")
        realmSetup()
        setPartner()
        setupMessages()
        updateMessages()
        setupTables()
    }
    
    func realmSetup(){
        realm = RealmDB.sharedInstance.realm
        user = RealmDB.sharedInstance.getUser()
    }
    
    func setupTables(){
        chatTableView.delegate = self
        chatTableView.dataSource = self
        chatTableView.reloadData()
    }
    
    func setupMessages(){
        let chatMessages = chatInstance?.chatMessages
        if let chatMessages = chatMessages{
            messages = chatMessages
        }
    }
    
    func updateMessages(){
        self.notificationToken = realm?.observe {_,_ in
            self.setupMessages()
            self.chatTableView.reloadData()
        }
    }
    
    func setPartner(){
        let chatters = chatInstance?.userList
        if let chatters = chatters {
            for user in chatters{
                if user.userID != self.user?.userID{
                    chatPartner = user
                    print(chatPartner)
                    usernameLabel.text = chatPartner?.userName ?? "Not chatting with anyone"
                }
            }
        }
    }
    func sendMessage() {
        let body = messageField.text ?? "forgot to send"
        let sender = user ?? User()
        let message = createMessage(sender: sender, body: body)
        try! realm!.write {
             chatInstance?.chatMessages.append(message)
        }
        messageField.text = nil
    }
    
    func createMessage (sender: User, body: String ) -> ChatMessage {
        let newMessage = ChatMessage()
        newMessage.messageUser.append(sender)
        newMessage.body = body
        return newMessage
    }
    
    @IBAction func sendAction(_ sender: UIButton) {
        sendMessage()
    }
}
extension PrivateMessageController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let messages = messages{
             return messages.count
        }else{
        return 1
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let row = indexPath.row
        if let messages = messages {
            cell.textLabel?.text = messages[row].body
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

