//
//  QAController.swift
//  StrawberryPie
//
//  Created by Ilias Doukas on 23/11/2019.
//  Copyright © 2019 Team Työkkäri. All rights reserved.
//

import UIKit

class QAController: UIViewController {
    
    var yourvariable: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupQa()
        

        // Do any additional setup after loading the view.
    }
    
    func setupQa() {
        titleLabel.text = yourvariable
       
        
    }
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var hostcardTable: UITableView!
    
    @IBAction func chatButton(_ sender: UIButton) {
        // Vaihda cellin pohjaa ja reloadData()
        
        let alert = UIAlertController(title: "Chat button pressed", message: "You presed a button", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cool", style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
        
    }
    @IBAction func pinnedButton(_ sender: UIButton) {
        // Vaihda cellin pohjaa ja reloadData()
    }
    @IBAction func topicButton(_ sender: UIButton) {
        // Vaihda cellin pohjaa ja reloadData()
    }
    @IBOutlet weak var qaTable: UITableView!
    

}

//extension QAController: jotainDelegate { }


