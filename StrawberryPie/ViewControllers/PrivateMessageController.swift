//
//  PrivateMessageController.swift
//  StrawberryPie
//
//  Created by Roni Jumpponen on 23/11/2019.
//  Copyright © 2019 Team Työkkäri. All rights reserved.
//

import UIKit
import RealmSwift
// Simply put, private chat between 2 users
class PrivateMessageController: UIViewController {
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var messageField: UITextField!
    @IBOutlet weak var sendBtn: UIButton!
    
    @IBOutlet weak var partnerPic: UIImageView!
    var chatInstance: Chat?
    var realm: Realm?
    var user: User?
    var chatPartner: User?
    
    var notificationToken: NotificationToken?
    var messages: List<ChatMessage>?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        sendBtn.layer.borderWidth = 2
        sendBtn.layer.borderColor = judasBlue().cgColor
        sendBtn.setTitleColor(judasBlue(), for: .normal)
        setup()
    }
    // setting up the content
    func setup(){
        print("Private CHAT!")
        realmSetup()
        setPartner()
        setupMessages()
        updateMessages()
        setupTables()
    }
    // setting up the realm
    func realmSetup(){
        realm = RealmDB.sharedInstance.realm
        user = RealmDB.sharedInstance.getUser()
    }
    
    func setupTables(){
        chatTableView.delegate = self
        chatTableView.dataSource = self
        chatTableView.register(UINib(nibName: "PrivMsgCell", bundle: nil), forCellReuseIdentifier: "PrivCell")
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
            self.scrollToBottom()
        }
    }
    
    func setPartner(){
        let chatters = chatInstance?.userList
        if let chatters = chatters {
            for user in chatters{
                if user.userID != self.user?.userID{
                    chatPartner = user
                    usernameLabel.text = chatPartner?.userName ?? "Not chatting with anyone"
                    getPartnerPic(user)
                }
            }
        }
    }
    
    func getPartnerPic(_ user: User) {
        let imageProcessor = UserImagePost()
        imageProcessor.getPic(image: user.uImage, onCompletion: {(resultImage) in
            if let result = resultImage {
                print("kuva saatu")
                self.partnerPic.image = result
            }
        })
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
    
    func scrollToBottom() {
        print("Scrolling")
        if let gotChat = messages {
            print("still scrolling")
            if gotChat.count > 0 {
                print("YesScrolliiiing")
                let indexPath = NSIndexPath(row: gotChat.count - 1, section: 0)
                print(indexPath)
                self.chatTableView.scrollToRow(at: indexPath as IndexPath, at: .bottom, animated: true)
            }
        }
    }
    
    func createMessage (sender: User, body: String ) -> ChatMessage {
        let newMessage = ChatMessage()
        newMessage.messageUser.append(sender)
        newMessage.body = body
        return newMessage
    }
    func dateformat(_ timestamp: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let thisTimestamp = formatter.string(from: timestamp)
        //let thisTimestamp = formatter.date(from: timestamp)
    
        return thisTimestamp
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "PrivCell", for: indexPath) as! PrivMsgCell
        let row = indexPath.row
        if let messages = messages {
            cell.username.text = messages[row].messageUser[0].userName
            cell.messagefield.text = messages[row].body
            let myFormatter = Formatter()
            let timestamp = myFormatter.dateformat(messages[row].timestamp)
            print(timestamp)
            cell.timestamp.text = timestamp
        }
        cell.backgroundColor = judasGrey()
        let border = CALayer()
        border.backgroundColor = CgjudasBlack()
        border.frame = CGRect(x: 0, y:  cell.frame.size.height - 0.5, width: cell.frame.size.width, height: 0.5)
        cell.layer.addSublayer(border)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 175
    }
}

