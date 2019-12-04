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

class HomeController: UIViewController {
    
    @IBOutlet weak var ExpertTableView: ExpertTableViewController!
    @IBOutlet weak var filterButton: UIButton!
    
    let transparentView = UIView()
    let filterView = UITableView()
    var selectedButton = UIButton()
    
    var notificationToken: NotificationToken?

    var user: SyncUser?
    var realm: Realm!
    
    lazy var sessions: Array<QASession> = []
    var upcomingSessions: Results<QASession>?
    var liveSessions: Results<QASession>?
    var archivedSessions: Results<QASession>?
    var expertImage: UIImage?
    
    var states: Array<String> = ["live","upcoming","archived"]
    var selectedState: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        filterButton.layer.cornerRadius = 10
        filterButton.layer.borderWidth = 1
        
        print(RealmDB.sharedInstance.setup)
        setupRealm("default", "default" , false)
        initialState()
        
        ExpertTableView.dataSource = self
        ExpertTableView.delegate = self
        ExpertTableView.reloadData()
        
        filterView.delegate = self
        filterView.dataSource = self
        filterView.register(PickCategoryCell.self, forCellReuseIdentifier: "Cell")
        //print(Realm.Configuration.defaultConfiguration.fileURL)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "QAController") {
            let selectedRow = ExpertTableView.indexPathForSelectedRow?.row
            var realmSession: QASession?
            if let selectedRow = selectedRow {
                realmSession = self.sessions[selectedRow]
            }
            let destinationVC = segue.destination as? QAController
            
            // viedään seguen mukana tavaraa. dummyTitle ja dumyChat ovat muuttujia QAControllerissa.
            destinationVC?.currentSession = realmSession
            // destinationVC?.sessionID = realmSession?.sessionID
            
        }
    }
    
    @IBAction func filterAction(_ sender: UIButton) {
        selectedButton = filterButton
        addTransparentView(frames: filterButton.frame)
    }
    func setState(state: String){
        selectedState = state
    }
    func initialState(){
        setState(state: "live")
        filterButton.setTitle(selectedState, for: .normal)
    }
 
    func setupExperts(){
        getSessions()
        getState()
        getPic()
    }
    func getSessions(){
        liveSessions = realm.objects(QASession.self).filter("live = true")
        upcomingSessions = realm.objects(QASession.self).filter("upcoming = true")
        archivedSessions = realm.objects(QASession.self).filter("archived = true")
    }
    func getState(){
        switch selectedState {
        case "live":
            if let liveSessions = self.liveSessions {
                self.sessions = Array(liveSessions)
            }
        case "upcoming":
            if let upcomingSessions = self.upcomingSessions {
                self.sessions = Array(upcomingSessions)
            }
        case "archived":
            if let archivedSessions = self.archivedSessions {
                self.sessions = Array(archivedSessions)
            }
        default: print("everything went to hell")
        }
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
    
    // function for making the filter filterView visible
    func addTransparentView(frames: CGRect) {
        let window = UIApplication.shared.keyWindow
        transparentView.frame = window?.frame ?? self.view.frame
        self.view.addSubview(transparentView)
        
        filterView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width, height: 0)
        self.view.addSubview(filterView)
        filterView.layer.cornerRadius = 5
        
        transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        filterView.reloadData()
        let tapgesture = UITapGestureRecognizer(target: self, action: #selector(removeTransparentView))
        transparentView.addGestureRecognizer(tapgesture)
        transparentView.alpha = 0
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.transparentView.alpha = 0.5
            self.filterView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height + 5, width: frames.width, height: CGFloat(self.states.count * 50))
        }, completion: nil)
    }
    
    @objc func removeTransparentView() {
        let frames = selectedButton.frame
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.transparentView.alpha = 0
            self.filterView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width, height: 0)
        }, completion: nil)
    }
    
    
}

//ExpertTableView

class ExpertTableViewController: UITableView{
    
}
extension HomeController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
          if(tableView == ExpertTableView){
            return 1
            
          }else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if(tableView == ExpertTableView){
            return sessions.count
        }else if(tableView == filterView){
            return states.count
        }else{
            return 0
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        if(tableView == ExpertTableView){
            let row = indexPath.row
        }
        else if (tableView == filterView){
            print("Setting the state for filter")
            setState(state: states[indexPath.row])
            print(states[indexPath.row])
            selectedButton.setTitle(states[indexPath.row], for: .normal)
            setupExperts()
            removeTransparentView()
            self.ExpertTableView.reloadData()
        }
    }
    
    func getPic() {
        let imageProcessor = UserImagePost()
        imageProcessor.getPic(image: "53bf7ebb568d8b78f51a8bbcf295a8b8", onCompletion: { (resultImage) in
            if let result = resultImage {
                print("kuva saatu")
                self.expertImage = result
                self.ExpertTableView.reloadData()
            }
        }
        )}
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          if(tableView == ExpertTableView){
            let cell = tableView.dequeueReusableCell(withIdentifier: "ExpertCell", for: indexPath) as! ExpertCellController
        
            //Scaleing the image to fit ImageView
            cell.expertImage?.contentMode = .scaleAspectFit
            var object: QASession
            object = self.sessions[indexPath.row] as QASession
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
          }else if (tableView == filterView){
                let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
                cell.textLabel?.text = states[indexPath.row]
                return cell
          }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            cell.textLabel?.text = states[indexPath.row]
            return cell
        }
        
    }
    /*
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(tableView == filterView){
            return 50
        }else{
            return 200
        }
    }
 */
}


