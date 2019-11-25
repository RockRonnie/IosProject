//
//  CategoryViewController.swift
//  StrawberryPie
//
//  Created by Arttu Jokinen on 23/11/2019.
//  Copyright © 2019 Team Työkkäri. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    let category = Category()
    @IBOutlet weak var collectionView: UICollectionView!
    
    let categoryNames = [String]()
    let categoryImages = [UIImage]()
    
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        category.deleteAllData(entity: "Category")
        category.generateData()
        category.getCategoryData(name: "Social sectors")
        // Do any additional setup after loading the view.
        
        //Reminder check for duplicate objects
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
        
        cell.categoryNameLabel.text = categoryNames[indexPath.item]
        cell.categoryImageView.image = categoryImages[indexPath.item]
        
        return cell
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
