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
    
    @IBOutlet weak var testOutlet: UILabel!
    
    func createCategoryData(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Category")
        do {
            let result = try managedContext.fetch(fetchRequest)
            if result.count < 1 {
                let categoryEntity = NSEntityDescription.entity(forEntityName: "Category", in: managedContext)!
                let category = NSManagedObject(entity: categoryEntity, insertInto: managedContext)
                category.setValue("ICT", forKeyPath: "categoryName")
                category.setValue("Computers and stuff", forKey: "categorySummary")
                try managedContext.save()
                print("Succesfully saved data!!!")
            } else {
                print("Object found. Didn't set")
            }
        }catch let error as NSError{
            print("Could not save. \(error), \(error.userInfo)")
        }
        
    }
    
    func getCategoryData(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Category")
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            print("Results: \(result)")
            for data in result as! [NSManagedObject]{
                print(data.value(forKey: "categoryName")as! Any)
                print(data.value(forKey: "categorySummary")as! Any)
            }
        } catch {
            print(error)
        }
    }

    
    func deleteAllData(entity: String)
    {
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

    func clearCoreData(){
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        
        for i in 0...delegate.persistentContainer.managedObjectModel.entities.count-1{
            let entity = delegate.persistentContainer.managedObjectModel.entities[i]
            
            do {
                let query = NSFetchRequest<NSFetchRequestResult>(entityName: entity.name!)
                let deleteRequest = NSBatchDeleteRequest(fetchRequest: query)
                try context.execute(deleteRequest)
                try context.save()
            }catch let error as NSError{
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        deleteAllData(entity: "Category")
        createCategoryData()
        getCategoryData()
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
