//
//  CategoryContentController.swift
//  StrawberryPie
//
//  Created by iosdev on 27/11/2019.
//  Copyright © 2019 Team Työkkäri. All rights reserved.
//  Class for handling Category Content view. Populates the tableview with the picked categorys contents only.

import UIKit
import CoreData
import RealmSwift

class CategoryContentController: UIViewController,UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var CategoryContentTable: ExpertTableViewController!
    var notificationToken: NotificationToken?
    var topText = String()
    var categoryObject = [NSManagedObject]()
    
    var user: SyncUser?
    var realm: Realm!
    
    lazy var experts: Array<QASession> = []
    var sessions: Results<QASession>?

    let button = UIButton()
    //Alert function for the the topbar button. Presents summary for the selected category.
    @objc func press() {
        let summary = categoryObject[0].value(forKey: "categorySummary") as! String
        let alert = UIAlertController(title: "Summary", message: summary, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = categoryObject[0].value(forKey: "categoryName") as? String
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Info", style: .plain, target: self, action: #selector(self.press))
        setupRealm("default", "default" , false)
        
        CategoryContentTable.dataSource = self
        CategoryContentTable.delegate = self
        CategoryContentTable.reloadData()
        CategoryContentTable.backgroundColor = judasGrey()
        self.view.backgroundColor = judasGrey()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "FromCatToQA") {
            let selectedRow = CategoryContentTable.indexPathForSelectedRow?.row
            var realmSession: QASession?
            if let selectedRow = selectedRow {
                realmSession = self.experts[selectedRow]
            }
            let destinationVC = segue.destination as? QAController
            
            // viedään seguen mukana tavaraa. dummyTitle ja dumyChat ovat muuttujia QAControllerissa.
            destinationVC?.currentSession = realmSession
            // destinationVC?.sessionID = realmSession?.sessionID
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return experts.count
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath){
        _ = indexPath.row
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExpertCell", for: indexPath) as! ExpertCellController
        cell.expertImage?.contentMode = .scaleAspectFit
        var object: QASession
        
        object = self.experts[indexPath.row] as QASession
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
        cell.backgroundColor = judasGrey()
        cell.layer.borderColor = CgjudasBlack()
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 10
        return cell
    }
    //Filters the feed to specified category
    func setupExperts(){
        let sessions = realm.objects(QASession.self).filter("sessionCategory = %@", categoryObject[0].value(forKey: "categoryName") as? String ?? "dummyValue")
        
        experts = Array(sessions)
        if experts.count == 0 { // If the array is empty this creates a label to the center of the screen indicating that there is no sessions available for the picked category
            print("No sessions found")
            CategoryContentTable.isHidden = true
            let label = UILabel(frame: CGRect(x:0,y:0,width:200, height:21))
            label.center.x = self.view.center.x
            label.center.y = self.view.center.y
            label.textAlignment = .center
            label.text = "There seems to be no sessions available for \(categoryObject[0].value(forKey: "categoryName")!)"
            label.numberOfLines = 3
            label.sizeToFit()
            label.accessibilityIdentifier = "NoContentLabel"
            self.view.addSubview(label)
        }
    }
    func updateExpertFeed(){
        self.notificationToken = realm?.observe {_,_ in
            self.setupExperts()
            self.CategoryContentTable.reloadData()
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
                    self.CategoryContentTable.reloadData()
                } else if let error = error {
                    print("Login error: \(error)")
                }
            }
        }else{
            self.realm = RealmDB.sharedInstance.realm
            self.user = RealmDB.sharedInstance.user
            self.updateExpertFeed()
            self.setupExperts()
            self.CategoryContentTable.reloadData()
            print(self.user?.identity ?? "No identity")
        }        
    }
}
