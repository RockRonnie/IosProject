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
    var hostedSessions: Results<QASession>?
    var recommendedSessions: Results<QASession>?
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideButton()
        setup()
        // Do any additional setup after loading the view.
    }
    func setup(){
        realm = RealmDB.sharedInstance.realm
        user = RealmDB.sharedInstance.getUser()
        checkExpert(user: user)
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
        hostedSessions = self.realm?.objects(QASession.self).filter("host[0].userID = %@", user?.userID ?? "default")
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
