//
//  QAController.swift
//  StrawberryPie
//
//  Created by Ilias Doukas on 23/11/2019.
//  Copyright © 2019 Team Työkkäri. All rights reserved.
//

import UIKit
import RealmSwift

class QAController: UIViewController {
    
    var dummyTitle: String?
    var dummySession: QASession?
    var realm: Realm?
    var topicSource = ["Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."]
    var chatSource = [] as [ChatMessage] // Tänne chattiviestit sisään
    var qaSource = ["Q: Mitä huudetaan jos koodi levii?","A: 🆘"]
    var selectedTab = "topic"

    override func viewDidLoad() {
        super.viewDidLoad()
        setupQa() // Tähän joku varmennuslogiikka?
        populateChat() // Lisää logiikka -> tee tämä jos realm ja session ok
        
        qaTable.dataSource = self
        qaTable.delegate = self
        
        sendButton.isHidden = true
        messageField.isHidden = true

        // Do any additional setup after loading the view.
    }
    
    func setupQa() {
        
        titleLabel.text = dummySession?.title ?? "No title"
        print(dummySession?.title ?? "Not working Session")
        //print(dummySession?.chat[0].chatMessages[0] ?? "Not working chatmessages")
        
    }
    
    
    func populateChat() {
        let chat = dummySession?.chat[0]
        // Huutomerkki pois. Ärsyttävän karkee tapa leipoa ChatMessage() objektit Arrayn sisään. Hyh
        chatSource = Array((chat?.chatMessages)!) // Siivoo !!!!! tämä sotku
        //print ("Eka viesti on", chatSource[0].body)
         //print ("Toka viesti on", chatSource[1].body)
        print ("Viestejä yhteensä ", chatSource.count)
    }
    
    // Tänne päivitysfunktio func updateChat() -> hae uusin viesti -> appendaa tableSourceen -> self.qaTable.reloadData()
    
    //Tässä notificationToken -> self.notificationToken = self.realm.observe { _,_ in updateChat()
    
    // deinit {
    // notificationToken?.invalidate()
    // }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var hostcardTable: UITableView!
    
    @IBAction func chatButton(_ sender: UIButton) {
        // Vaihda cellin pohjaa ja reloadData()
        selectedTab = "chat"
        messageField.isHidden = false
        sendButton.isHidden = false
        qaTable.reloadData()

    }
    
    @IBOutlet weak var messageField: UITextField!
    
    @IBAction func sendButton(_ sender: UIButton) {
        let newMessage = ChatMessage()
        newMessage.body = messageField.text ?? "Tapahtui virhe"
        try! realm!.write {
            dummySession!.chat[0].chatMessages.append(newMessage)
            
        }

    }
    @IBOutlet weak var sendButton: UIButton!
    @IBAction func pinnedButton(_ sender: UIButton) {
        // Vaihda cellin pohjaa ja reloadData()       
      
        selectedTab = "pinned"
        sendButton.isHidden = true
        messageField.isHidden = true
        qaTable.reloadData()
    }
    @IBAction func topicButton(_ sender: UIButton) {
        // Vaihda cellin pohjaa ja reloadData()
        selectedTab = "topic"
        qaTable.rowHeight = 500.0
        sendButton.isHidden = true
        messageField.isHidden = true
        qaTable.reloadData()

    }
    
    @IBOutlet weak var qaTable: UITableView!
    
}

extension QAController:  UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    // Päivitetään tableviewiin tavarat sisälle
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var numberOfRows: Int
        
        switch selectedTab {
        case "topic":
            numberOfRows = topicSource.count
        case "pinned":
            numberOfRows = qaSource.count
        case "chat":
            numberOfRows = chatSource.count
        default: numberOfRows = 0
        }
        
        
        return (numberOfRows)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "qacell")
        
        switch selectedTab {
        case "topic":
            cell.textLabel?.text = topicSource[indexPath.row]
            cell.textLabel?.numberOfLines = 0
        case "pinned":
            cell.textLabel?.text = qaSource[indexPath.row]
            cell.textLabel?.numberOfLines = 2
            qaTable.rowHeight = 44.0 // palautetaan default korkeus topicin jäljiltä
        case "chat":
            cell.textLabel?.text = chatSource[indexPath.row].body
            cell.textLabel?.numberOfLines = 2
            qaTable.rowHeight = 44.0
        default:
            cell.textLabel?.text = " 🆘 Nyt levis koodi"
        }
        return cell
    }
    
    
    
    
    
}


