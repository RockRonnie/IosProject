//
//  QaTest.swift
//  StrawberryPie/Users/ilias/Documents/Xcode Projects/strawberrypie/StrawberryPie/Storyboards/QaTest.storyboard
//
//  Created by Ilias Doukas on 24/11/2019.
//  Copyright © 2019 Team Työkkäri. All rights reserved.
//

import UIKit

class QaTest: UIViewController {

    override func viewDidLoad() {
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
            
            let testSession = QASession()
            let testChat = Chat()
            let testMessage = ChatMessage()
            testMessage.body = "Tässä viesti"
            testChat.chatMessages.append(testMessage)
            testSession.title = "This is session title"
            testSession.chat.append(testChat)
            // Valitaan kohde viewcontroller
            let destinationVC = segue.destination as? QAController
            
            // viedään seguen mukana tavaraa. dummyTitle ja dumyChat ovat muuttujia QAControllerissa.
            destinationVC?.dummySession = testSession
            
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
