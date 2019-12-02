//
//  CategoryContentController.swift
//  StrawberryPie
//
//  Created by iosdev on 27/11/2019.
//  Copyright © 2019 Team Työkkäri. All rights reserved.
//

import UIKit
import CoreData

class CategoryContentController: UIViewController {

    
    var topText = String()
    var categoryObject = [NSManagedObject]()
    
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
        print(topText)
        
        // Do any additional setup after loading the view.
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
