//
//  HomeViewController.swift
//  StrawberryPie
//
//  Created by Markus Saronsalo on 22/11/2019.
//  Copyright © 2019 Team Työkkäri. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class HomeController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    var notificationToken: NotificationToken?

    @IBOutlet weak var HottestStudiesTableView: UITableView!
    var user: SyncUser?
    var realm: Realm!
    
    lazy var experts: Array<QASession> = []
    var sessions: Results<QASession>?
    
    @IBOutlet weak var ExpertTableView: ExpertTableViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(RealmDB.sharedInstance.setup)
        setupRealm("default", "default" , false)
        
        ExpertTableView.dataSource = self
        ExpertTableView.delegate = self
        ExpertTableView.reloadData()
        //print(Realm.Configuration.defaultConfiguration.fileURL)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "QAController") {
            let selectedRow = ExpertTableView.indexPathForSelectedRow?.row
            var realmSession: QASession?
            if let selectedRow = selectedRow {
                realmSession = self.experts[selectedRow]
            }
            let destinationVC = segue.destination as? QAController
            
            // viedään seguen mukana tavaraa. dummyTitle ja dumyChat ovat muuttujia QAControllerissa.
            destinationVC?.dummySession = realmSession
            destinationVC?.sessionID = realmSession?.sessionID
            
        }
    }
    /*
    @IBAction func TestButton(_ sender: Any) {
        
        let feedOne = Feed()
        feedOne.title = "Police"
        feedOne.name = "Dog Boy"
        feedOne.desc = "Skilled dog telling about the job..."
        
        //let feedTwo = Feed()
        //feedTwo.title = "Bus driver"
        //feedTwo.name = "Cheeky Brat"
        //feedTwo.desc = "I'm an old bus driver who will be telling about my work..."
        
        //let feedThree = Feed()
        //feedThree.title = "Drug Lord"
        //feedThree.name = "Madam Mister"
        //feedThree.desc = "I will be telling about my life on the street and how you can turn it around..."
        
        try! realm!.write {
          realm!.add(feedOne)
          //realm.add(feedTwo)
          //realm.add(feedThree)
        }
    }
    */
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return experts.count
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath){
        
       let row = indexPath.row
 
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExpertCell", for: indexPath) as! ExpertCellController
        
        var object: QASession
        object = self.experts[indexPath.row] as QASession
        
        cell.expertDesc?.text = object.sessionDescription
        cell.expertName?.text = object.host[0].userID
        cell.expertTitle?.text = object.title
        //cell.expertImage?
        
        return cell
    }
    func setupExperts(){
        let sessions = realm.objects(QASession.self)
        experts = Array(sessions)
        
    }
    
  
    func updateExpertFeed(){
        self.notificationToken = realm?.observe {_,_ in
            self.setupExperts()
            self.ExpertTableView.reloadData()
        }
    }
    func setupRealm(_ username: String,_ password: String,_ register: Bool) {
        if(RealmDB.sharedInstance.setup == false){
        // Yritä kirjautua sisään --> Vaihda kovakoodatut tunnarit pois
        SyncUser.logIn(with: .usernamePassword(username: username, password: password, register: false), server: Constants.AUTH_URL) { user, error in
            if let user = user {
                // Onnistunut kirjautuminen
                // Lähetetään permission realmille -> read/write oikeudet käytössä olevalle palvelimelle. realmURL: Constants.REALM_URL --> Katso Constants.swift
                let permission = SyncPermission(realmPath: Constants.REALM_URL.absoluteString, username: "default" , accessLevel: .write)
                user.apply(permission, callback: { (error) in
                    if error != nil {
                        print(error?.localizedDescription ?? "No error")
                    } else {
                        print("success")
                    }
                })
                self.user = user
                let admin = user.isAdmin
                print(admin)
                // Leivotaan realmia varten asetukset. realmURL: Constants.REALM_URL --> Katso Constants.swift
                let config = user.configuration(realmURL: Constants.REALM_URL, fullSynchronization: true)
                self.realm = try! Realm(configuration: config)
                print("Realm connection has been setup")
                RealmDB.sharedInstance.realm = self.realm
                RealmDB.sharedInstance.setup = true
                print(RealmDB.sharedInstance.setup = true)
                self.updateExpertFeed()
                self.setupExperts()
                self.ExpertTableView.reloadData()
            } else if let error = error {
                print("Login error: \(error)")
            }
            }
            }else{
                self.realm = RealmDB.sharedInstance.realm
                self.user = RealmDB.sharedInstance.user
                self.updateExpertFeed()
                self.setupExperts()
                self.ExpertTableView.reloadData()
                print(self.user?.identity ?? "No identity")
            }
        
    }
    
}

//ExpertTableView
class ExpertTableViewController: UITableView{
    
}


//Custom Cell
class ExpertCellController: UITableViewCell{
    @IBOutlet weak var expertImage: UIImageView!
    @IBOutlet weak var expertTitle: UILabel!
    @IBOutlet weak var expertName: UILabel!
    @IBOutlet weak var expertDesc: UILabel!
}
