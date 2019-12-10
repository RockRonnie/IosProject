//
//  HomeViewController.swift
//  StrawberryPie
//
//  Created by Joachim Grotenfelt on 22/11/2019.
//  Copyright © 2019 Team Työkkäri. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class HomeController: UIViewController {
    @IBOutlet weak var segmentBtns: UISegmentedControl!
    @IBOutlet weak var ExpertTableView: ExpertTableViewController!
    @IBOutlet weak var filterButton: UIButton!
    
    let SearchController = UISearchController(searchResultsController: nil)
    
    let transparentView = UIView()
    let filterView = UITableView()
    var selectedButton = UIButton()
    
    var notificationToken: NotificationToken?

    var user: SyncUser?
    var realm: Realm!
    
    lazy var sessions: Array<QASession> = []
    lazy var filteredSessions: Array<QASession> = []
    var upcomingSessions: Results<QASession>?
    var liveSessions: Results<QASession>?
    var archivedSessions: Results<QASession>?
    var expertImage: UIImage?
    
    var selectedState: String?
    var isSearchBarEmpty: Bool {
        return SearchController.searchBar.text?.isEmpty ?? true
    }
    var isFiltering: Bool {
        return SearchController.isActive && !isSearchBarEmpty
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Team Työkkäri ReEdu"
        print(RealmDB.sharedInstance.setup)
        setupRealm("default", "default" , false)
        setupSearchBar()
        setupTables()
        self.view.backgroundColor = judasGrey()

        segmentBtns.setTitle((NSLocalizedString("Live", value: "Live", comment: "Selected segment")), forSegmentAt: 0)
       segmentBtns.setTitle((NSLocalizedString("Upcoming", value: "Upcoming", comment: "Selected segment")), forSegmentAt: 1)
        segmentBtns.setTitle((NSLocalizedString("Archived", value: "Archived", comment: "Selected segment")), forSegmentAt: 2)
    }
    
    
    @IBAction func segmentAction(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
              print("live")
              setState(state: "live")
              getState()
              ExpertTableView.reloadData()
        case 1:
              print("upcoming")
              setState(state: "upcoming")
              getState()
              ExpertTableView.reloadData()
        case 2:
              print("archived")
              setState(state: "archived")
              getState()
              ExpertTableView.reloadData()
        default:
            print("ERROR 404")
        }
    }
    
    
    // prepare for seque to transfer the QASession information to QASession viewcontroller
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
    
    // State for filterbutton
    func setState(state: String){
        selectedState = state
    }
    
    //Initial state of the filterbutton(live)
    func initialState(){
        setState(state: "live")
    }
    
    //function for loading the data that is ran every time home view is selected.
    
    func setupExperts(){
        getSessions()
        getState()
        getPic()
    }
    
    //getting the sessions from realm.
    func getSessions(){
        liveSessions = realm.objects(QASession.self).filter("live = true")
        upcomingSessions = realm.objects(QASession.self).filter("upcoming = true")
        archivedSessions = realm.objects(QASession.self).filter("archived = true")
    }
    
    // updating the sessions array based on selected filter state.
    // also checks if selected state is empty or not. 
    func getState(){
        switch selectedState {
        case "live":
            if let liveSessions = self.liveSessions {
                self.sessions = Array(liveSessions)
                if liveSessions.isEmpty{
                    ExpertTableView.isHidden = true
                    createisEmptyLabel()
                } else {
                    ExpertTableView.isHidden = false
                    removeIsEmptyLabel()
                }
            }
        case "upcoming":
            if let upcomingSessions = self.upcomingSessions {
                self.sessions = Array(upcomingSessions)
                if upcomingSessions.isEmpty{
                    ExpertTableView.isHidden = true
                    createisEmptyLabel()
                } else {
                    ExpertTableView.isHidden = false
                    removeIsEmptyLabel()
                }
            }
        case "archived":
            if let archivedSessions = self.archivedSessions {
                self.sessions = Array(archivedSessions)
                if archivedSessions.isEmpty{
                    ExpertTableView.isHidden = true
                    createisEmptyLabel()
                } else {
                    ExpertTableView.isHidden = false
                    removeIsEmptyLabel()
                }
            }
        default: print("everything went to hell")
        }
    }
    // Creates a subview label that indicates that there are no sessions available
    func createisEmptyLabel(){
        removeIsEmptyLabel()
        let label = UILabel(frame: CGRect(x:0,y:0,width:200, height:21))
        label.center.x = self.view.center.x
        label.center.y = self.view.center.y
        label.textAlignment = .center
        label.text = "There seems to be no \(selectedState!) sessions available"
        label.numberOfLines = 3
        label.sizeToFit()
        label.accessibilityIdentifier = "NoContentLabel"
        label.tag = 69
        self.view.addSubview(label)
    }
    // Removes the label from the view 
    func removeIsEmptyLabel(){
        if let viewWithTag = self.view.viewWithTag(69){
            viewWithTag.removeFromSuperview()
        }
    }
    //setting up the notification token for observing the realm to achieve full synchronization and reactive UI
    func updateExpertFeed(){
        self.notificationToken = realm?.observe {_,_ in
            self.setupExperts()
            self.ExpertTableView.reloadData()
        }
    }
    
    //INITIAL realm setup. logs in with default guest user the first time app is ran.
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
                self.initialState()
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
                self.initialState()
                self.realm = RealmDB.sharedInstance.realm
                self.user = RealmDB.sharedInstance.user
                self.updateExpertFeed()
                self.setupExperts()
                self.ExpertTableView.reloadData()
                print(self.user?.identity ?? "No identity")
            }
    }
    // Setting up tableviews
    func setupTables(){
        ExpertTableView.dataSource = self
        ExpertTableView.delegate = self
        ExpertTableView.reloadData()
        ExpertTableView.backgroundColor = UIColor.clear
        //print(Realm.Configuration.defaultConfiguration.fileURL)
    }
    // Setting up searchbar searchcontroller
    func setupSearchBar(){
        SearchController.searchResultsUpdater = self
        SearchController.obscuresBackgroundDuringPresentation = false
        SearchController.searchBar.placeholder = "Search Sessions"
        navigationItem.searchController = SearchController
        definesPresentationContext = true
    }
    // Filtering function for searchbar
    func filterContentForSearchText(_ searchText: String?) {
        if let searchText = searchText{
            filteredSessions = sessions.filter { (session) -> Bool in
                return session.title.lowercased().contains(searchText.lowercased())
            }
            ExpertTableView.reloadData()
        }
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
            if isFiltering {
                return filteredSessions.count
            }
            return sessions.count
        }else{
            return 0
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        if(tableView == ExpertTableView){
            _ = indexPath.row
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
        
            let cell = tableView.dequeueReusableCell(withIdentifier: "ExpertCell", for: indexPath) as! ExpertCellController
            //Scaleing the image to fit ImageView
            cell.expertImage?.contentMode = .scaleAspectFit
            var object: QASession
            if isFiltering {
                object = filteredSessions[indexPath.row] as QASession
            } else {
                object = sessions[indexPath.row] as QASession
            }
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

extension HomeController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text)
        
    }
}



