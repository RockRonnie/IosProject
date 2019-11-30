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
    
    var dummySession: QASession?
    var sessionID:String?
    var realm: Realm?
    var notificationToken: NotificationToken?
    // Tee kunnolla, hae QASessionista topic --> odotellaan hostipuolen topiccia
    var topicSource = ["Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."]
    // Tee kunnolla, hae QASessionista Q ja A --> odotellaan hostipuolen edistymistä. Alustava koodi tableviewissä
    var answerSource = [] as [ChatMessage]
    var questionSource = [] as [ChatMessage]
    var chatSource: List<ChatMessage>? // Tänne chattiviestit sisään
    // Poista qaSource kun ylläolevat on kunnossa
    var qaSource = ["Q: Mitä huudetaan jos koodi levii?","A: 🆘"]
    // Tabin valinta, oletuksena aihe
    var selectedTab = "topic"

    override func viewDidLoad() {
        super.viewDidLoad()
        realm = RealmDB.sharedInstance.realm
        setupQa() // Tähän joku varmennuslogiikka?
        populateChat() // Lisää logiikka -> tee tämä jos realm ja session ok
        
        qaTable.dataSource = self
        qaTable.delegate = self
        
        //viestin kirjoitus piiloon aluksi
        sendButton.isHidden = true
        messageField.isHidden = true
    }
    
    func setupQa() {
        
        // Laitetaan otsikkotekstipaikalleen
        titleLabel.text = dummySession?.title ?? "No title"
        
        // Kytätään päivityksiä realmissa
        // Jostain syystä updaten yhteydessä edellinen update menee uusiksi läpi = arrayhyn tulee tuplia
        self.notificationToken = realm?.observe { _,_ in
            self.qaTable.reloadData()
        }
    }
    
    
    func populateChat() {
        if let chat = dummySession?.chat[0] {
            chatSource = chat.chatMessages
        }
    }
    
    
    func testiTesti () -> Int {
        return 1
    }
    
    func messageToRealm(data: ChatMessage) {
        try! realm!.write {
            dummySession!.chat[0].chatMessages.append(data)
        }
    }
    
    deinit {
    notificationToken?.invalidate()
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var hostcardTable: UITableView!
    
    @IBAction func chatButton(_ sender: UIButton) {
        // Vaihdetaan cellin pohjaa ja reloadData()
        selectedTab = "chat"
        messageField.isHidden = false
        sendButton.isHidden = false
        qaTable.reloadData()
    }
    
    @IBOutlet weak var messageField: UITextField!
    
    @IBAction func sendButton(_ sender: UIButton) {
        // Luodaan uusi viesti ja lähetetään realmiin nykyisen sessionin chattiobjektiin
        let newMessage = ChatMessage()
        newMessage.body = messageField.text ?? "Tapahtui virhe"
        messageToRealm(data: newMessage)
    }
    
    @IBOutlet weak var sendButton: UIButton!
    
    @IBAction func pinnedButton(_ sender: UIButton) {
        // Vaihdetaan cellin pohjaa ja reloadData()
        selectedTab = "pinned"
        // Chattikilkkeet piiloon
        sendButton.isHidden = true
        messageField.isHidden = true
        qaTable.reloadData()
    }
    @IBAction func topicButton(_ sender: UIButton) {
        // Vaihdetaan cellin pohjaa ja reloadData()
        selectedTab = "topic"
        qaTable.rowHeight = 500.0
        // Chattikilkkeet piiloon
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
            numberOfRows = qaSource.count //answerSource.count
        case "chat":
            numberOfRows = chatSource?.count ?? 0
        default: numberOfRows = 0
        }
        return (numberOfRows)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "qacell")
        
        // Täytetään celli valitan tabin perusteella
        switch selectedTab {
        case "topic":
            cell.textLabel?.text = topicSource[indexPath.row]
            cell.textLabel?.numberOfLines = 0
        case "pinned":
            cell.textLabel?.text = qaSource[indexPath.row] //Line 1" + "\n" + "Line 2"
            cell.textLabel?.numberOfLines = 0
            qaTable.rowHeight = 44.0 // palautetaan default korkeus topicin jäljiltä
        case "chat":
            cell.textLabel?.text = chatSource?[indexPath.row].body
            cell.textLabel?.numberOfLines = 2
            qaTable.rowHeight = 44.0
        default:
            cell.textLabel?.text = "🆘 Nyt levis koodi"
        }
        return cell
    }
}
