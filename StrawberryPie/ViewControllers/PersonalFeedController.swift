//
//  PersonalFeedController.swift
//  StrawberryPie
//
//  Created by iosdev on 23/11/2019.
//  Copyright © 2019 Team Työkkäri. All rights reserved.
//

import UIKit
import RealmSwift

class PersonalFeedController: UIViewController {
    
    //Outlets
    @IBOutlet weak var feedBtn: UIButton!
    @IBOutlet weak var QABtn: UIButton!
    @IBOutlet weak var PrivMsgBtn: UIButton!
    @IBOutlet weak var personalFeedTableView: UITableView!
    @IBOutlet weak var hostBtn: UIButton!
    
    var notificationToken: NotificationToken?
    
    var realm: Realm?
    var user: User?
    var expert: Bool = false
    
    lazy var personalFeed: Array<QASession> = []
    lazy var personalQA: Array<QA> = []
    
    var personalMessages: List<ChatMessage>?
    var privateMessages: List<ChatMessage>?
    var hostedSessions: Results<QASession>?
    var recommendedSessions: Results<QASession>?
    var answeredQA: Results<QA>?
    
    var selectedTab: String?
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        // Do any additional setup after loading the view.
    }
    func setup(){
        hideButton()
        initialTab()
        realm = RealmDB.sharedInstance.realm
        user = RealmDB.sharedInstance.getUser()
        checkExpert(user: user)
        setupPersonalItems()
        personalFeedTableView.dataSource = self
        personalFeedTableView.delegate = self
        personalFeedTableView.reloadData()
    }
    func setTab(tab: String){
        selectedTab = tab
    }
    func initialTab(){
        selectedTab = "Feed"
    }
    
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
    func hideButton(){
        hostBtn.isHidden = true
    }
    func showButton(){
        hostBtn.isHidden = false
    }
    
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
    
    func setupPersonalItems(){
        switch expert{
        case false: setupPersonalFeed()
        case true: setupHost()
        }
        expertStatus()
        setupPersonalQA()
        setupPrivateMessages()
    }
    // normal user
    func setupPersonalFeed(){
        recommendedSessions = realm?.objects(QASession.self).filter("upcoming = true")
    }
    func setupPersonalQA(){
        if let user = user{
            answeredQA = realm?.objects(QA.self).filter("ANY question.messageUser.userID = %@", user.userID)
            if let answeredQA = answeredQA {
                self.personalQA = Array(answeredQA)
            }
        }
    }
    func setupPrivateMessages(){
        if let user = user{
            personalMessages = user.userPrivateMessages
            if let personalMessages = personalMessages{
                privateMessages = personalMessages
            }
        }
    }
   // EXPERT
    func setupHost(){
        print("setup host")
        print(user?.userID ?? "Dick")
        if let user = user{
            hostedSessions = realm?.objects(QASession.self).filter("ANY host.userID = %@", user.userID)
            print("läpi meni")
        }
    }

    
    
    func updatePersonalFeed(){
        self.notificationToken = realm?.observe {_,_ in
            self.setupPersonalItems()
            self.personalFeedTableView.reloadData()
        }
    }
    
    
    @IBAction func perFeedAction(_ sender: UIButton) {
        setTab(tab: "Feed")
        personalFeedTableView.reloadData()
    }
    @IBAction func QaAction(_ sender: UIButton) {
        setTab(tab: "QA")
        personalFeedTableView.reloadData()
    }
    @IBAction func privMsgAction(_ sender: UIButton) {
        setTab(tab: "privMsg")
        personalFeedTableView.reloadData()
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
            if let privateMessages = privateMessages {
                return privateMessages.count
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
        case "privMsg":
            print("privMsg")
        default:
            print("error")
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        switch selectedTab{
        case "Feed":
            let cell = tableView.dequeueReusableCell(withIdentifier: "ExpertCell", for: indexPath) as! ExpertCellController
            
            //Scaleing the image to fit ImageView
            cell.expertImage?.contentMode = .scaleAspectFit
            var object: QASession
            object = self.personalFeed[indexPath.row] as QASession
            let imageProcessor = UserImagePost()
            imageProcessor.getPic(image: object.host[0].uImage, onCompletion: {(resultImage) in
            if let result = resultImage {
            print("kuva saatu")
            cell.expertImage?.image = result
            }
            })
            cell.expertDesc?.text = object.sessionDescription
            cell.expertName?.text = object.host[0].firstName + " " + object.host[0].lastName
            cell.expertTitle?.text = object.title
            return cell
        case "QA":
            let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "qacell")
            let qa = self.personalQA[indexPath.row] as QA
            cell.textLabel?.text = qa.question[0].messageUser[0].userName
            cell.textLabel?.text = qa.question[0].body
            cell.textLabel?.text = qa.answer[0].messageUser[0].userName
            cell.textLabel?.text = qa.answer[0].body
            return cell
        case "privMsg":
             let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "privMsg")
             let message = self.privateMessages?[indexPath.row] as ChatMessage?
             cell.textLabel?.text = message?.messageUser[0].userName
             cell.textLabel?.text = message?.body
            return cell
            
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ExpertCell", for: indexPath) as! ExpertCellController
            cell.textLabel?.text = "🆘 Nyt levis koodi"
            return cell
        }
    }
}
