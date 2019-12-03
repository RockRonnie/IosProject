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
    
    var currentSession: QASession?
    var realm: Realm?
    var notificationToken: NotificationToken?
    
    var topicSource: String?
    var answerSource: List<ChatMessage>?
    var questionSource: List<ChatMessage>?
    var chatSource: List<ChatMessage>?
    var userSource: User?
    
    // Tabin valinta, oletuksena aihe
    var selectedTab = "topic"

    override func viewDidLoad() {
        super.viewDidLoad()
        realm = RealmDB.sharedInstance.realm
        setupNotification()
        populateSources()
        
        qaTable.dataSource = self
        qaTable.delegate = self
        
        hostCardCV.dataSource = self
        hostCardCV.delegate = self
        
        //viestin kirjoitus piiloon aluksi
        sendButton.isHidden = true
        messageField.isHidden = true
        
        let layout = hostCardCV.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        layout.minimumInteritemSpacing = 5
        layout.itemSize = CGSize(width: (hostCardCV.frame.size.width - 20)/2, height: hostCardCV.frame.size.height)
    }
    
    func setupNotification() {
        self.notificationToken = realm?.observe { _,_ in
            // Ajetaan populateSources joka päivityksellä kunnes sessiossa on vähintään yksi QA objekti ja "pinned" tableviewiin saadaan cellejä. Sen jälkeen realm hoitaa kaiken.
            if self.answerSource == nil {
                self.populateSources()
            }
            self.qaTable.reloadData()
            self.scrollToBottom()
            
            }
        }
    
    func scrollToBottom() {
        if let gotChat = self.chatSource {
            if gotChat.count > 0 {
                let indexPath = NSIndexPath(row: gotChat.count - 1, section: 0)
                self.qaTable.scrollToRow(at: indexPath as IndexPath, at: .bottom, animated: true)
            }
        }
    }
    
    
    func populateSources() {
        print ("Source data")
        // Title
        titleLabel.text = currentSession?.title ?? "No title"
        // Aihe
        topicSource = currentSession?.intro[0].body ?? "Topic text missing"
        // Chatviestit
        if let chat = currentSession?.chat[0] {
            chatSource = chat.chatMessages
        }
        // Kysymykset ja vastaukset
        if let qaBoard = currentSession?.QABoard[0] {
        if qaBoard.QAs.count > 0 {
            questionSource = qaBoard.QAs[0].question
            answerSource = qaBoard.QAs[0].answer
            }
        }
        // Käyttäjä
        userSource = RealmDB.sharedInstance.getUser()
        print (userSource)
        if let gotUser = userSource {
            print("USERNAME", gotUser.userName)
        }
        print ("Ajettu onnistuneesti")
    }
    
    func testiTesti() -> Int {
        return 1
    }
    
    func messageToRealm(data: ChatMessage) {
        try! realm!.write {
            currentSession!.chat[0].chatMessages.append(data)
        }
    }
    
    func messageToQA(data: ChatMessage) {
        let defaultAnswer = ChatMessage()
        defaultAnswer.body = "Tässä vastaus"
        let selectedQuestion = data
        let qaSet = QA()
        print("QAID", qaSet.QAID)
        try! realm!.write {
            currentSession!.chat[0].chatMessages.append(data)
            currentSession!.QABoard[0].QAs.append(qaSet)
            currentSession!.QABoard[0].QAs.last!.question.append(selectedQuestion)
            currentSession!.QABoard[0].QAs.last!.answer.append(defaultAnswer)
        }
    }
    
    deinit {
    notificationToken?.invalidate()
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var hostCardCV: UICollectionView!
    
    
    @IBAction func chatButton(_ sender: UIButton) {
        // Vaihdetaan cellin pohjaa ja reloadData()
        selectedTab = "chat"
        if userSource?.userName != "default" && userSource?.userName != nil {
        messageField.isHidden = false
        sendButton.isHidden = false
        }
        qaTable.reloadData()
        scrollToBottom()
    }
    
    @IBOutlet weak var messageField: UITextField!
    
    @IBAction func sendButton(_ sender: UIButton) {
        // Luodaan uusi viesti ja lähetetään realmiin nykyisen sessionin chattiobjektiin. Leivotaan viestin eteen username
        let newMessage = ChatMessage()
        newMessage.body = ((userSource?.userName ?? " ") + ": " + (messageField.text ?? "Tapahtui virhe"))
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

extension QAController:  UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "hostcardcell", for: indexPath)
        
        if indexPath.row == 0  {
            let title = UILabel(frame: CGRect(x: 0, y: 0, width: cell.bounds.size.width, height: 40))
            title.textColor = UIColor.black
            title.text = "Kuva"
            title.textAlignment = .left
            cell.contentView.addSubview(title)
        }
        else {
            let titleFont = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight(500))
            let title = UILabel(frame: CGRect(x: 0, y: 25, width: cell.bounds.size.width, height: 20))
            title.textColor = UIColor.black
            title.text = "Nurse"
            title.font = titleFont
            title.textAlignment = .center
            cell.contentView.addSubview(title)
            
            let name = UILabel(frame: CGRect(x: 0, y: 50, width: cell.bounds.size.width, height: 20))
            name.textColor = UIColor.black
            name.text = "Gertrud Schmitz"
            name.textAlignment = .center
            cell.contentView.addSubview(name)
            
            let company = UILabel(frame: CGRect(x: 0, y: 75, width: cell.bounds.size.width, height: 20))
            company.textColor = UIColor.black
            company.text = "Oy Hospital Ab"
            company.textAlignment = .center
            cell.contentView.addSubview(company)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.item + 1)
    }

    // Päivitetään tableviewiin tavarat sisälle
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfRows: Int
        
        switch selectedTab {
        case "topic":
            numberOfRows = 1
        case "pinned":
            numberOfRows = answerSource?.count ?? 0
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
            cell.textLabel?.text = topicSource
            cell.textLabel?.numberOfLines = 0
        case "pinned":
            if let answerRowsExist = answerSource {
                if answerRowsExist.count > 0 {
                    cell.textLabel?.text = (questionSource?[indexPath.row].body ?? "Question missing") + "\n" + (answerSource?[indexPath.row].body ?? "Answer missing")
                    cell.textLabel?.numberOfLines = 0
                    qaTable.rowHeight = 44.0 // palautetaan default korkeus topicin jäljiltä
                }
            }
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
