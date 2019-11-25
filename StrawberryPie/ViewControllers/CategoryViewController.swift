//
//  CategoryViewController.swift
//  StrawberryPie
//
//  Created by Arttu Jokinen on 23/11/2019.
//  Copyright © 2019 Team Työkkäri. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UIViewController {
    
    //This method is used to create data for a category
    func createCategoryData(name: String, summary: String){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Category")
        fetchRequest.predicate = NSPredicate(format: "categoryName == %@", name)
        do {
            let result = try managedContext.fetch(fetchRequest)
            if result.count < 1 {
                let categoryEntity = NSEntityDescription.entity(forEntityName: "Category", in: managedContext)!
                let category = NSManagedObject(entity: categoryEntity, insertInto: managedContext)
                category.setValue(name, forKeyPath: "categoryName")
                category.setValue(summary, forKey: "categorySummary")
                try managedContext.save()
                print("Succesfully saved data for category \(name)")
            } else {
                print("Object found. Didn't set")
            }
        }catch let error as NSError{
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    //Fetches all data in category entity
    func getAllCategoryData(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Category")
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            print("Results: \(result)")
            for data in result as! [NSManagedObject]{
                print("Name of category: \(data.value(forKey: "categoryName")as! String)")
                print("Summary: \(data.value(forKey: "categorySummary")as! String)")
            }
        } catch {
            print(error)
        }
    }
    
    //Fetches data for a certain given category
    func getCategoryData(name: String){
        guard let appDel = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = appDel.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Category")
        fetchRequest.predicate = NSPredicate(format: "categoryName == %@", name)
        
        do {
            let result = try managedContext.fetch(fetchRequest) as! [NSManagedObject]
            print(result[0].value(forKey: "categoryName") as! String)
            print(result[0].value(forKey: "categorySummary") as! String)
            
            
        } catch let error as NSError {
            print("There was an error processing your request: \(error)")
        }
        
    }

    //Deletes all data in a given entity
    func deleteAllData(entity: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false
        
        do
        {
            let results = try managedContext.fetch(fetchRequest)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                managedContext.delete(managedObjectData)
            }
            try managedContext.save()
        } catch let error as NSError {
            print("Detele all data in \(entity) error : \(error) \(error.userInfo)")
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        deleteAllData(entity: "Category")
        createCategoryData(name: "ICT", summary: "Computers and stuff you know")
        createCategoryData(name: "Humanities and Arts", summary: "punch of hippies")
        createCategoryData(name: "Social sectors", summary: "Studies and work related to society")
        createCategoryData(name: "Education Sciences", summary: "")
        createCategoryData(name: "Trade, Adminstration and Law", summary: "")
        createCategoryData(name: "Natural Sciences", summary: "")
        createCategoryData(name: "Technical Fields", summary: "")
        createCategoryData(name: "Agriculture and Forestry", summary: "")
        createCategoryData(name: "Health and Wellbeing", summary: "")
        createCategoryData(name: "Service Industry", summary: "")
        createCategoryData(name: "General Education", summary: "")
        createCategoryData(name: "Misc & Unkown", summary: "")
        getCategoryData(name: "Social sectors")
        // Do any additional setup after loading the view.
        
        //Reminder check for duplicate objects
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
