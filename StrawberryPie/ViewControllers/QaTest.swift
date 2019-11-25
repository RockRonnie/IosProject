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
        super.viewDidLoad()
        RealmDB.sharedInstance.setupRealm()
        realm = RealmDB.sharedInstance.realm
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
            destinationVC?.dummySession = testSession
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
