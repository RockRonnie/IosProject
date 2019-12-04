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
    lazy var personalMessage: Array<ChatMessage> = []
    lazy var personalQA: Array<QA> = []
    
    var hostedSessions: Results<QASession>?
    var recommendedSessions: Results<QASession>?
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        // Do any additional setup after loading the view.
    }
    func setup(){
        hideButton()
        realm = RealmDB.sharedInstance.realm
        user = RealmDB.sharedInstance.getUser()
        checkExpert(user: user)
        setupPersonalItems()
        personalFeedTableView.dataSource = self
        personalFeedTableView.delegate = self
        personalFeedTableView.reloadData()
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
    }
    // normal user
    func setupPersonalFeed(){
        recommendedSessions = realm?.objects(QASession.self).filter("live = true")
    }
    func setupPersonalQA(){}
    func setupPrivateMessages(){}
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
    }
    @IBAction func QaAction(_ sender: UIButton) {
    }
    @IBAction func privMsgAction(_ sender: UIButton) {
    }
    
    
    


}

extension PersonalFeedController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
            return personalFeed.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
            return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
    }
    
    
}
