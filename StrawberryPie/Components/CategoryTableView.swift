//
//  CategoryTableView.swift
//  StrawberryPie
//
//  Created by iosdev on 02/12/2019.
//  Copyright © 2019 Team Työkkäri. All rights reserved.
//

import UIKit

class CategoryTableView: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    var array = Array<String>()
    var selectedButton = UIButton()
    var trasnparentView = UIView()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = array[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedButton.setTitle(array[indexPath.row], for: .normal)
        //removeTransparentView()
    }
}
