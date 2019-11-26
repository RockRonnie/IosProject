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
    
    @IBOutlet weak var ExpertTableView: ExpertTableViewController!
    
    let realm = try! Realm()
    lazy var experts = realm.objects(Feed.self)
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        if indexPath.section == 0{
            return UITableView.automaticDimension
        } else {
            return 128
        }
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return UITableView.automaticDimension
        } else {
            return 128
        }
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
    
    let feedOne = Feed()
    feedOne.title = "Manager"
    feedOne.name = "Bulba dog"
    feedOne.desc = "Skilled manager telling about her work..."
    
    let feedTwo = Feed()
    feedTwo.title = "Bus driver"
    feedTwo.name = "Cheeky Brat"
    feedTwo.desc = "I'm an old bus driver who will be telling about my work..."
    
    let feedThree = Feed()
    feedThree.title = "Drug Lord"
    feedThree.name = "Madam Mister"
    feedThree.desc = "I will be telling about my life on the street and how you can turn it around..."
    
    //try! realm.write {
      //  realm.add(feedOne)
       // realm.add(feedTwo)
       // realm.add(feedThree)
    //}
    ExpertTableView.dataSource = self
    ExpertTableView.delegate = self
    ExpertTableView.reloadData()
    print(experts)
    
    ExpertTableView.rowHeight = UITableView.automaticDimension
    ExpertTableView.estimatedRowHeight = 128
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
