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
    var qaSource: QAMessageBoard?
    
    var hostImage: UIImage?
    var hostName: String?
    var hostProfession: String?
    var hostEducation: String?
    var topicSource: String?
    var chatSource: List<ChatMessage>?
    var userSource: User?
    
    let feed = UIStoryboard(name: "HostQA", bundle: nil)
    
    // Tabin valinta, oletuksena aihe
    var selectedTab = "topic"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        qaTable.register(UINib(nibName: "ChatMsgCell", bundle: nil), forCellReuseIdentifier: "chatcell")
        qaTable.register(UINib(nibName: "QACell", bundle: nil), forCellReuseIdentifier: "pinnedcell")
        realm = RealmDB.sharedInstance.realm
        setupNotification()
        populateSources()
        
        qaTable.dataSource = self
        qaTable.delegate = self
        
        hostCardCV.dataSource = self
        hostCardCV.delegate = self
        
        if RealmDB.sharedInstance.getUser()?.userID != currentSession?.host[0].userID {
            hostButton.isHidden = true
        }
        
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
            if self.qaSource == nil {
                self.populateSources()
            }
            self.qaTable.reloadData()
            if self.selectedTab == "chat" {
                self.scrollToBottom()
            }
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
        // Segment palkki
        scSegment?.setTitle((NSLocalizedString("Topic", value: "Topic", comment: "Selected segment")), forSegmentAt: 0)
        scSegment?.setTitle((NSLocalizedString("Pinned", value: "Pinned", comment: "Selected segment")), forSegmentAt: 1)
        scSegment?.setTitle((NSLocalizedString("Chat", value: "Chat", comment: "Selected segment")), forSegmentAt: 2)
        // Chatviestit
        if let chat = currentSession?.chat[0] {
            chatSource = chat.chatMessages
        }
        // Kysymykset ja vastaukset
        if let qaBoard = currentSession?.QABoard[0] {
        qaSource = qaBoard
            }
        // Käyttäjä
        userSource = RealmDB.sharedInstance.getUser()
        // print (userSource)
        if let gotUser = userSource {
        }
        // Host name, profile
        if let gotHost = currentSession?.host[0] {
            hostName = gotHost.firstName + " " + gotHost.lastName
            hostProfession = currentSession?.profession
            hostEducation = currentSession?.education
        }
        // Host avatar
        if hostImage == nil {
            let imgProcessor = UserImagePost()
            imgProcessor.getPic(image: (currentSession?.host[0].uImage)!, onCompletion: {(resultImage) in
                if let result = resultImage{
                    self.hostImage = result
                    self.hostCardCV.reloadData()
                }
            })
        }
    }
    
    func messageToRealm(data: ChatMessage) {
        try! realm!.write {
            currentSession!.chat[0].chatMessages.append(data)
        }
        messageField.text = nil
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "HostQAController") {
            let destinationVC = segue.destination as? HostQAController
            // viedään seguen mukana tavaraa. dummyTitle ja dumyChat ovat muuttujia QAControllerissa.
            destinationVC?.currentSession = currentSession
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    deinit {
    notificationToken?.invalidate()
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBAction func toHostSession(_ sender: Any) {
    }
    @IBOutlet weak var hostCardCV: UICollectionView!
    
    @IBOutlet weak var scSegment: UISegmentedControl!
    
    @IBAction func scSegmentPressed(_ sender: Any) {
        let getIndex = scSegment.selectedSegmentIndex
        
        switch (getIndex) {
        case 0:
            // Vaihdetaan cellin pohjaa ja reloadData()
            selectedTab = "topic"
            qaTable.rowHeight = 500.0
            // Chattikilkkeet piiloon
            sendButton.isHidden = true
            messageField.isHidden = true
            qaTable.reloadData()
        case 1:
            // Vaihdetaan cellin pohjaa ja reloadData()
            selectedTab = "pinned"
            // Chattikilkkeet piiloon
            sendButton.isHidden = true
            messageField.isHidden = true
            qaTable.rowHeight = 100.0
            qaTable.reloadData()
        case 2:
            // Vaihdetaan cellin pohjaa ja reloadData()
            selectedTab = "chat"
            if userSource?.userName != "default" && userSource?.userName != nil && currentSession?.live == true {
                messageField.isHidden = false
                sendButton.isHidden = false
            }
            qaTable.reloadData()
        default:
            print("non selected")
        }
    }
    
    @IBOutlet weak var hostButton: UIButton!
    @IBOutlet weak var messageField: UITextField!
    @IBAction func sendButton(_ sender: UIButton) {
        // Luodaan uusi viesti ja lähetetään realmiin nykyisen sessionin chattiobjektiin. Leivotaan viestin eteen username
        if let gotMessage = messageField.text {
            if gotMessage.count <= 200 {
                let newMessage = ChatMessage()
                newMessage.body = messageField.text ?? "Tapahtui virhe"
                if let gotUser = RealmDB.sharedInstance.getUser() {
                    newMessage.messageUser.append(gotUser)
                    newMessage.messageSender = gotUser.userName
                    messageToRealm(data: newMessage)
                }
            }
            else {
                let alert = UIAlertController(title: "Message too long", message: "Please limit your message to 200 characters", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel))
                self.present(alert, animated: true)
            }
        }
    }
    @IBOutlet weak var sendButton: UIButton!

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
            let pic = UIImageView(frame: CGRect(x: 0, y: 0, width: cell.bounds.size.width, height: cell.bounds.size.height))
            pic.image = hostImage
            cell.contentView.addSubview(pic)
        }
        else {
            let titleFont = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight(500))
            let title = UILabel(frame: CGRect(x: 0, y: 25, width: cell.bounds.size.width, height: 20))
            title.textColor = UIColor.black
            title.text = hostProfession
            title.font = titleFont
            title.textAlignment = .center
            cell.contentView.addSubview(title)
            
            let name = UILabel(frame: CGRect(x: 0, y: 50, width: cell.bounds.size.width, height: 20))
            name.textColor = UIColor.black
            name.text = hostName
            name.textAlignment = .center
            cell.contentView.addSubview(name)
            
            let company = UILabel(frame: CGRect(x: 0, y: 65, width: cell.bounds.size.width, height: 60))
            company.textColor = UIColor.black
            company.text = hostEducation
            company.textAlignment = .center
            company.numberOfLines = 0
            company.lineBreakMode = .byTruncatingTail
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
            numberOfRows = currentSession?.QABoard[0].QAs.count ?? 0
        case "chat":
            numberOfRows = chatSource?.count ?? 0
        default: numberOfRows = 0
        }
        return (numberOfRows)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //var cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell")
        // Täytetään celli valitan tabin perusteella
        switch selectedTab {
        case "topic":
            let cell = tableView.dequeueReusableCell(withIdentifier: "qacell", for: indexPath)
            cell.textLabel?.text = topicSource
            cell.textLabel?.numberOfLines = 0
            return cell
        case "pinned":
            let cell = tableView.dequeueReusableCell(withIdentifier: "pinnedcell", for: indexPath) as! QACell
            if let gotQA = qaSource {
                if gotQA.QAs.count > 0 {
                    
                    cell.QuestionUser.text = gotQA.QAs[indexPath.row].question[0].messageUser[0].userName
                    cell.QuestionField.text = gotQA.QAs[indexPath.row].question[0].body
                    cell.AnswerField.text = gotQA.QAs[indexPath.row].answer[0].body
                    cell.AnswerUser.text = gotQA.QAs[indexPath.row].question[0].messageUser[0].userName
                    //cell.msgTimestamp
                    
//                    cell.textLabel?.text = ((NSLocalizedString("Question", value: "Question", comment: "QA Question")) + ": " + gotQA.QAs[indexPath.row].question[0].body) + "\n" + (NSLocalizedString("Answer", value: "Answer", comment: "QA Answer")) + ": " + (gotQA.QAs[indexPath.row].answer[0].body)
                    qaTable.rowHeight = 175.0
                }
            }
            return cell
        case "chat":
            let cell = tableView.dequeueReusableCell(withIdentifier: "chatcell", for: indexPath) as! ChatMsgCell
            cell.msgBody.text = chatSource?[indexPath.row].body
            cell.msgSender.text = chatSource?[indexPath.row].messageUser[0].userName
            qaTable.rowHeight = 200.0
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "qacell", for: indexPath)
            cell.textLabel?.text = "🆘 Nyt levis koodi"
            return cell
        }
    }
}
