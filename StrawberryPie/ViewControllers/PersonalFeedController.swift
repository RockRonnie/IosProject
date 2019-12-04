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
    
    var realm: Realm?
    var user: User?
    var expert: Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
            }else{
                print("user is not an expert")
            }
        }else{
            print("user doesn't exist")
        }
    }
    
    
    
    @IBAction func perFeedAction(_ sender: UIButton) {
    }
    @IBAction func QaAction(_ sender: UIButton) {
    }
    @IBAction func privMsgAction(_ sender: UIButton) {
    }
    
    
    


}
