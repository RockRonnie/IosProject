//
//  PersonalFeedController.swift
//  StrawberryPie
//
//  Created by Roni Jumpponen, Joachim Grotenfelt on 23/11/2019.
//  Copyright © 2019 Team Työkkäri. All rights reserved.
//

import UIKit
import RealmSwift
// Users Hub of actions. Used for showing user his/hers private messages, Questions that experts have answered and a customized feed depending on if you are user / expert. Users see a "recommended" feed based on their selected interests, where as experts see their own sessions and can enter them in "hostmode"
class PersonalFeedController: UIViewController {
    
    //Outlets
    @IBOutlet weak var personalFeedTableView: UITableView!
    @IBOutlet weak var hostBtn: UIButton!
    @IBOutlet weak var personaFeedSegment: UISegmentedControl!
    
    var notificationToken: NotificationToken?
    
    var realm: Realm?
    var user: User?
    var expert: Bool = false
    
    lazy var personalFeed: Array<QASession> = []
    lazy var personalQA: Array<QA> = []
    
    var personalMessages: List<ChatMessage>?
    var privateMessages: List<ChatMessage>?
    
    var privateChats: Array<Chat>?
    var hostedSessions: Results<QASession>?
    var recommendedSessions: Results<QASession>?
    var answeredQA: Results<QA>?
    
    var selectedTab: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        styles()
    }
    
    // setting up personal feed
    func setup(){
        hideButton()
        initialTab()
        realm = RealmDB.sharedInstance.realm
        user = RealmDB.sharedInstance.getUser()
        checkExpert(user: user)
        setupPersonalItems()
        personalFeedTableView.dataSource = self
        personalFeedTableView.delegate = self
        personalFeedTableView.register(UINib(nibName: "PrivateChatCell", bundle: nil), forCellReuseIdentifier: "ChatCell")
        personalFeedTableView.register(UINib(nibName: "QACell", bundle: nil), forCellReuseIdentifier: "QACell")
        personalFeedTableView.register(UINib(nibName: "QASessionCell", bundle: nil), forCellReuseIdentifier: "SessionCell")
        personalFeedTableView.reloadData()
    }
    
    //setting up the styles.
    func styles(){
        self.view.backgroundColor = judasGrey()
        self.personalFeedTableView.backgroundColor = judasGrey()
        personaFeedSegment.tintColor = judasBlue()
        hostBtn.setTitleColor(judasBlue(), for: .normal)
        hostBtn.layer.borderWidth = 2.0
        hostBtn.layer.borderColor = judasBlue().cgColor
        hostBtn.layer.cornerRadius = 5
    }
    //used for setting tab
    func setTab(tab: String){
        selectedTab = tab
    }
    //initial tab when view is loaded
    func initialTab(){
        selectedTab = "Feed"
    }
    //Segmented Control with segments for switching between tabs
    @IBAction func feedTabAction(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex{
        case 0:
            setTab(tab: "Feed")
            personalFeedTableView.reloadData()
        case 1:
            setTab(tab: "QA")
            personalFeedTableView.reloadData()
        case 2:
            setTab(tab: "privMsg")
            personalFeedTableView.reloadData()
        default:
            print("Something went wrong")
        }
    }
    // function used for finding out if the user is an expert or normal user
    func checkExpert(user: User?){
        if let user = user{
            if (user.userExpert ==  true){
                expert = true
                showButton()
            }else{
                print("user is not an expert")
            }
        }else{
            print("user doesn't exist")
        }
    }
    // hides the host button if the user is not expert
    func hideButton(){
        hostBtn.isHidden = true
    }
    // shows the button
    func showButton(){
        hostBtn.isHidden = false
    }
    // function used for showing the right content depending on user being an expert or not
    func expertStatus(){
        switch expert {
        case true:
            if let hostedSessions = self.hostedSessions {
                self.personalFeed = Array(hostedSessions)
            }
        case false:
            if let recommendedSessions = self.recommendedSessions {
                self.personalFeed = Array(recommendedSessions)
            }
        }
    }
    // setting up the items for tableview
    func setupPersonalItems(){
        switch expert{
        case false: setupPersonalFeed()
        case true: setupHost()
        }
        expertStatus()
        setupPersonalQA()
        setupPrivateChats()
        self.personalFeedTableView.reloadData()
    }
    // setting up the normal users feed based on his/hers interests, if he/she has none then just showint upcoming content instead
    func setupPersonalFeed(){
        if let user = user{
            if user.userInterests.isEmpty {
                recommendedSessions = realm?.objects(QASession.self).filter("upcoming = true")
                 self.personalFeedTableView.reloadData()
            }else{
                recommendedSessions = realm?.objects(QASession.self).filter("sessionCategory IN %@", user.userInterests)
                 self.personalFeedTableView.reloadData()
            }
        }else{
            recommendedSessions = realm?.objects(QASession.self).filter("upcoming = true")
             self.personalFeedTableView.reloadData()
        }
     
    }
    //Showing all pinned content related to the user (QA's)
    func setupPersonalQA(){
        if let user = user{
            let answeredQA = realm?.objects(QA.self).filter("ANY question.messageUser.userID == %@", user.userID)
            if let answeredQA = answeredQA {
                self.personalQA = Array(answeredQA)
                 self.personalFeedTableView.reloadData()
            }
        }
    }
    // Users private chats
    func setupPrivateChats(){
        if let user = user{
            let chats = realm?.objects(Chat.self).filter("ANY userList.userID = %@", user.userID)
            if let chats = chats{
                self.privateChats = Array(chats)
                self.personalFeedTableView.reloadData()
            }
        }
    }
    
   // EXPERT
    //showing host content
    func setupHost(){
        print("setup host")
        print(user?.userID ?? "Dick")
        if let user = user{
            hostedSessions = realm?.objects(QASession.self).filter("ANY host.userID = %@", user.userID)
            self.personalFeedTableView.reloadData()
            print("läpi meni")
        }
    }
    // Used for finding the session users QA belongs to for navigation purposes
    func findSessionforQA(qa: QA) -> QASession {
        print("Finding session based on QA")
        let foundSession = realm?.objects(QASession.self).filter("ANY QABoard.QAs.QAID = %@", qa.QAID).first
        if let foundSession = foundSession{
            return foundSession
        }
        else{
            print("Something went wrong")
            return QASession()
        }
    }
    
    //Dynamic notification token for observing the realm
    func updatePersonalFeed(){
        self.notificationToken = realm?.observe {_,_ in
            self.setupPersonalItems()
        }
    }
    //checking the tab status
    func statusCheck(object: QASession) -> String{
        var status = ""
        if (object.live) {
            status = "Live"
        }else if(object.upcoming){
            status = "Upcoming"
        }else if(object.archived){
            status = "Archived"
        }
        return status
    }
}

extension PersonalFeedController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        switch selectedTab{
        case "Feed":
            return personalFeed.count
        
        case "QA":
                return personalQA.count
        case "privMsg":
            if let privateChats = privateChats {
                return privateChats.count
            }else{
                return 0
            }
        default:
            return 1
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
            return 1
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        switch selectedTab{
        case "Feed":
            if expert == true{
                let hostsession = UIStoryboard(name: "HostQA", bundle: nil)
                let session = hostsession.instantiateViewController(withIdentifier: "HostQAController") as? HostQAController
                var realmSession: QASession?
                realmSession = self.personalFeed[indexPath.row] as QASession
                session?.currentSession = realmSession
                if let session = session{
                    self.navigationController?.pushViewController(session, animated: true)
                }
            }else{
                let normalsession = UIStoryboard(name: "QA", bundle: nil)
                let session = normalsession.instantiateViewController(withIdentifier: "QAController") as? QAController
                var realmSession: QASession?
                realmSession = self.personalFeed[indexPath.row] as QASession
                session?.currentSession = realmSession
                if let session = session{
                    self.navigationController?.pushViewController(session, animated: true)
                }
            }
        case "QA":
            print("QA")
            let normalsession = UIStoryboard(name: "QA", bundle: nil)
            let session = normalsession.instantiateViewController(withIdentifier: "QAController") as? QAController
            var realmSession: QASession?
            let qa = self.personalQA[indexPath.row] as QA
            realmSession = findSessionforQA(qa: qa)
            session?.currentSession = realmSession
            if let session = session{
                self.navigationController?.pushViewController(session, animated: true)
            }
        case "privMsg":
            print("privMsg")
            let privChat = UIStoryboard(name: "PrivateChat", bundle: nil)
            let chatNav = privChat.instantiateViewController(withIdentifier: "PrivateMessageController") as? PrivateMessageController
            let chat = self.privateChats?[indexPath.row] as Chat?
            chatNav?.chatInstance = chat
            if let chatNav = chatNav{
                self.navigationController?.pushViewController(chatNav, animated: true)
            }else{
                print("something went wrong")
            }
        default:
            print("error")
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        switch selectedTab{
        case "Feed":
            let cell = tableView.dequeueReusableCell(withIdentifier: "SessionCell", for: indexPath) as! QASessionCell
            
            //Scaleing the image to fit ImageView
            cell.profilePic.contentMode = .scaleAspectFit
            cell.backgroundColor = judasGrey()
            let border = CALayer()
            border.backgroundColor = CgjudasBlack()
            border.frame = CGRect(x: 0, y:  cell.frame.size.height - 0.5, width: cell.frame.size.width, height: 0.5)
            cell.layer.addSublayer(border)
          
            var object: QASession
            object = self.personalFeed[indexPath.row] as QASession
            let imageProcessor = UserImagePost()
            imageProcessor.getPic(image: object.host[0].uImage, onCompletion: {(resultImage) in
            if let result = resultImage {
            print("kuva saatu")
            cell.profilePic.image = result
            }
            })
            cell.sessionDesc?.text = object.sessionDescription
            cell.host?.text = object.host[0].firstName + " " + object.host[0].lastName
            cell.title?.text = object.title
            cell.category.text = NSLocalizedString(object.sessionCategory, value: object.sessionCategory, comment: "Category name")
            cell.status.text = NSLocalizedString(statusCheck(object: object), value: statusCheck(object: object), comment: "Status")
            return cell
        case "QA":
            let cell = tableView.dequeueReusableCell(withIdentifier: "QACell", for: indexPath) as? QACell
            let qa = self.personalQA[indexPath.row] as QA?
            if let cell = cell {
                if let qa = qa {
                    cell.QuestionUser.text = qa.question[0].messageUser[0].userName
                    cell.QuestionField.text = qa.question[0].body
                    cell.AnswerUser.text = qa.answer[0].messageUser[0].userName
                    cell.AnswerField.text = qa.answer[0].body
                    cell.backgroundColor = judasGrey()
                    let border = CALayer()
                    border.backgroundColor = CgjudasBlack()
                    border.frame = CGRect(x: 0, y:  cell.frame.size.height - 0.5, width: cell.frame.size.width, height: 0.5)
                    cell.layer.addSublayer(border)
                    return cell
                }else{
                    cell.textLabel?.text = "nothing here"
                }
            }else{
                let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "QACell")
                cell.textLabel?.text = "Nothing here"
                return cell
            }
        case "privMsg":
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath) as? PrivateChatCell
            let chat = self.privateChats?[indexPath.row] as Chat?
             if let cell = cell {
                print("Cell found")
                let chatters = chat?.userList
                var partner: User?
                if let chatters = chatters {
                    for user in chatters{
                        if user.userID != self.user?.userID{
                            partner = user
                            cell.chatPartner.text = partner?.userName ?? "Not chatting with anyone"
                        }
                    }
                }
                let lastMessage = chat?.chatMessages.last
                cell.lastUser.text = lastMessage?.messageUser[0].userName
                cell.lastMessage.text = lastMessage?.body
                let myFormatter = Formatter()
                let timestamp = lastMessage?.timestamp
                if let timestamp = timestamp {
                    let myStamp = myFormatter.dateformat(timestamp)
                    cell.lastTimestamp.text = myStamp
                }
                cell.backgroundColor = judasGrey()
                let border = CALayer()
                border.backgroundColor = CgjudasBlack()
                border.frame = CGRect(x: 0, y:  cell.frame.size.height - 0.5, width: cell.frame.size.width, height: 0.5)
                cell.layer.addSublayer(border)
                return cell
                
             }else{
                let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "ChatShell")
                cell.textLabel?.text = "Nothing here"
                return cell
             }
            
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ExpertCell", for: indexPath) as! ExpertCellController
            cell.textLabel?.text = "🆘 Nyt levis koodi"
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch selectedTab{
        case "Feed":
            return 200
        case "QA":
            return 175
        case "privMsg":
            return 200
        default:
            return 100
        }
    }
}
