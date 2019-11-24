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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "QAController") {
            let destinationVC = segue.destination as? QAController
            destinationVC?.yourvariable = "Test successful"
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
