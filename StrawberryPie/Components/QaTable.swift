//
//  FeedTable.swift
//  StrawberryPie
//
//  Created by Ilias Doukas on 22/11/2019.
//  Copyright © 2019 Team Työkkäri. All rights reserved.
//
// Reusable custom tableviewcontroller

import UIKit

class QaTable: UITableViewController {
    
    let tableSource = ["Rivi tavaraa"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (tableSource.count)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "qacell")
        cell.textLabel?.text = tableSource[indexPath.row]
        return(cell)
        
    }
    
}
