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
    @IBOutlet weak var HottestTopicsLabel: UITableViewCell!
    
    @IBOutlet weak var ExpertTableView: ExpertTableViewController!
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
        
        try! realm.write {
          realm.add(feedOne)
          //realm.add(feedTwo)
          //realm.add(feedThree)
        }
    }
    
    let realm = try! Realm()
    lazy var experts = realm.objects(Feed.self)
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return experts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExpertCell", for: indexPath) as! ExpertCellController
        
        var object: Feed
        object = self.experts[indexPath.row] as Feed
        
        cell.expertDesc?.text = object.desc
        cell.expertName?.text = object.name
        cell.expertTitle?.text = object.title
        //cell.expertImage?
        
        return cell
    }
    
  override func viewDidLoad() {
    super.viewDidLoad()
    
    
    ExpertTableView.dataSource = self
    ExpertTableView.delegate = self
    ExpertTableView.reloadData()
    //print(Realm.Configuration.defaultConfiguration.fileURL)
    updateExpertFeed()
    
  }
    func updateExpertFeed(){
        self.notificationToken = realm.observe {_,_ in
            self.ExpertTableView.reloadData()
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
