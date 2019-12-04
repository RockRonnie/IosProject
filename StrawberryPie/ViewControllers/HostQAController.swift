//
//  QAController.swift
//  StrawberryPie
//
//  Created by Ilias Doukas on 23/11/2019.
//  Copyright © 2019 Team Työkkäri. All rights reserved.
//

import UIKit
import RealmSwift

class HostQAController: UIViewController {
    
    let transparentView = UIView()
    let questionLabel = UILabel()
    let answerField = UITextField()
    var answerButton = UIButton()
    var cancelButton = UIButton()

    
    var currentSession: QASession?
    var realm: Realm?
    var notificationToken: NotificationToken?
    
    var questionText: String?
    var selectedMessage: ChatMessage?
    
    var hostImage: UIImage?
    var hostName: String?
    var hostProfession: String?
    var hostEducation: String?
    var topicSource: String?
    //kopsaa tämä QA puolelle myös
    var qaSource: QAMessageBoard?
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
            if self.qaSource == nil {
                self.populateSources()
            }
            self.qaTable.reloadData()
            //self.scrollToBottom()
            
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
            qaSource = qaBoard
            }
        }
        // Käyttäjä
        userSource = RealmDB.sharedInstance.getUser()
        // print (userSource)
        if let gotUser = userSource {
            print("USERNAME", gotUser.userName)
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
                    print("VITTU JES")
                    self.hostImage = result
                    self.hostCardCV.reloadData()
                }
            })
        //getPic()
        print ("Ajettu onnistuneesti")
        }
    }
    
    func testiTesti() -> Int {
        return 1
    }
    
    func messageToRealm(data: ChatMessage) {
        try! realm!.write {
            currentSession!.chat[0].chatMessages.append(data)
        }
    }
    
    func messageToQA(question: ChatMessage, answer: ChatMessage) {
        let defaultAnswer = ChatMessage()
        defaultAnswer.body = "Tässä vastaus"
        let qaSet = QA()
        print("QAID", qaSet.QAID)
        qaSet.question.append(question)
        qaSet.answer.append(answer)
        try! realm!.write {
            //currentSession!.chat[0].chatMessages.append(data)
            currentSession!.QABoard[0].QAs.append(qaSet)
            //currentSession!.QABoard[0].QAs.last!.question.append(selectedQuestion)
            //currentSession!.QABoard[0].QAs.last!.answer.append(defaultAnswer)
        }
        sendButton.isHidden = true
        messageField.isHidden = true
    }
    
    func getPic() {
        let imageProcessor = UserImagePost()
        imageProcessor.getPic(image: "53bf7ebb568d8b78f51a8bbcf295a8b8", onCompletion: { (resultImage) in
            print ("kuvaa hakemassa")
            if let result = resultImage {
                print("VITTU JES")
                self.hostImage = result
                self.hostCardCV.reloadData()
                }
            }
        )}
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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
        //messageField.isHidden = false
        //sendButton.isHidden = false
        }
        qaTable.reloadData()
        //scrollToBottom()
    }
    
    func addTransparentView(frames: CGRect) {
        let window = UIApplication.shared.keyWindow
        transparentView.frame = window?.frame ?? self.view.frame
        self.view.addSubview(transparentView)
        
        answerField.frame = CGRect(x: 200, y: 200, width: 200, height: 150)
        self.view.addSubview(answerField)
        
        transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        //let tapgesture = UITapGestureRecognizer(target: self, action: #selector(removeTransparentView))
        //transparentView.addGestureRecognizer(tapgesture)
        transparentView.alpha = 0
    }

    // function for removing the transparent view (making the tableview for selecting the category invisible)
    @objc func removeTransparentView() {
        let frames = answerButton.frame
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.transparentView.alpha = 0
            self.answerField.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width, height: 0)
        }, completion: nil)
    }
    
    @IBOutlet weak var messageField: UITextField!
    
    @IBAction func sendButton(_ sender: UIButton) {
        // Luodaan uusi viesti ja lähetetään realmiin nykyisen sessionin chattiobjektiin. Leivotaan viestin eteen username
        let message = selectedMessage
        let answer = ChatMessage()
        if let question = message {
            answer.body = "Vastaus: " + (messageField.text ?? "Tapahtui virhe")
            messageToQA(question: question, answer: answer)
        }
    }
    
    @IBOutlet weak var sendButton: UIButton!
    
    @IBAction func pinnedButton(_ sender: UIButton) {
        // Vaihdetaan cellin pohjaa ja reloadData()
        selectedTab = "pinned"
        // Chattikilkkeet piiloon
        sendButton.isHidden = true
        messageField.isHidden = true
        qaTable.rowHeight = 100.0
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

extension HostQAController:  UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
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
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "qacell")
        
        // Täytetään celli valitan tabin perusteella
        switch selectedTab {
        case "topic":
            cell.textLabel?.text = topicSource
            cell.textLabel?.numberOfLines = 0
        case "pinned":
            if let gotQA = qaSource {
                if gotQA.QAs.count > 0 {
                    cell.textLabel?.text = (gotQA.QAs[indexPath.row].question[0].body) + "\n" + (gotQA.QAs[indexPath.row].answer[0].body)
                    cell.textLabel?.numberOfLines = 0
                    //qaTable.rowHeight = 44.0 // palautetaan default korkeus topicin jäljiltä
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        if selectedTab == "chat" {
            let selectedCell = qaTable.cellForRow(at: indexPath)
            let cellText = selectedCell?.textLabel?.text
            if let gotText = cellText {
                selectedMessage = ChatMessage()
                selectedMessage?.body = "Kysymys: " + gotText
                messageField.isHidden = false
                sendButton.isHidden = false
                
                //messageToQA(data: selectedMessage)
                //addTransparentView(frames: titleLabel.frame)
            }
        }
        
        
    }
}
