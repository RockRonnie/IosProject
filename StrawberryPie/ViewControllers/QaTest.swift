//
//  QaTest.swift
//  StrawberryPie/Users/ilias/Documents/Xcode Projects/strawberrypie/StrawberryPie/Storyboards/QaTest.storyboard
//
//  Created by Ilias Doukas on 24/11/2019.
//  Copyright © 2019 Team Työkkäri. All rights reserved.
//

import UIKit
import RealmSwift

class QaTest: UIViewController {
    var realm: Realm!
   
    override func viewDidLoad() {
        setupRealm()
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func enterButton(_ sender: UIButton) {
        performSegue(withIdentifier: "QAController", sender:sender)
    }
    @IBAction func hostButton(_ sender: UIButton) {
        print("Hosting")
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "QAController") {
            
            let realmSession = realm.objects(QASession.self)
            //let subscription = realmSession.subscribe()
            //print(realm.configuration)

            let testSession = QASession()
            let testChat = Chat()
            let testMessage = ChatMessage()
            let testMessage2 = ChatMessage()
            testMessage.body = "Tässä viesti"
            testMessage2.body = "Tässä toinen ehkä hieman pidempi, mutta silti riemukas, viesti digitaalisessa muodossa"
            testChat.chatMessages.append(testMessage)
            testChat.chatMessages.append(testMessage2)
            testSession.title = "This is session title"
            testSession.chat.append(testChat)
            // Valitaan kohde viewcontroller
            let destinationVC = segue.destination as? QAController
            
            // viedään seguen mukana tavaraa. dummyTitle ja dumyChat ovat muuttujia QAControllerissa.
            destinationVC?.dummySession = realmSession.last
            destinationVC?.realm = realm
            destinationVC?.sessionID = realmSession.last?.sessionID
            
        }
    }
    
    func setupRealm() {
        // Yritä kirjautua sisään --> Vaihda kovakoodatut tunnarit pois
        SyncUser.logIn(with: .usernamePassword(username: "test1", password: "test", register: false), server: Constants.AUTH_URL) { user, error in
            if let user = user {
                // Onnistunut kirjautuminen
                // Lähetetään permission realmille -> read/write oikeudet käytössä olevalle palvelimelle. realmURL: Constants.REALM_URL --> Katso Constants.swift
                let permission = SyncPermission(realmPath: Constants.REALM_URL.absoluteString, username: "*", accessLevel: .write)
                user.apply(permission, callback: { (error) in
                    if error != nil {
                        print(error?.localizedDescription ?? "No error")
                    } else {
                        print("success")
                    }
                })
                //self.user = user
                let admin = user.isAdmin
                print(admin)
                // Leivotaan realmia varten asetukset. realmURL: Constants.REALM_URL --> Katso Constants.swift
                let config = user.configuration(realmURL: Constants.REALM_URL, fullSynchronization: true)
                self.realm = try! Realm(configuration: config)
                print("Realm connection has been setup")
            }
        }
    }
    
    
    // Otetaan seuranta notifikaatio pois koska ... ???
   

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
