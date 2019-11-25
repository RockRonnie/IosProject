//
//  Category+CoreDataClass.swift
//  
//
//  Created by iosdev on 22/11/2019.
//
//

import Foundation
import CoreData
import UIKit

public class Category: NSManagedObject {

    //This method is used to create data for a category
    func createCategoryData(name: String, summary: String, imageName: String){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Category")
        fetchRequest.predicate = NSPredicate(format: "categoryName == %@", name)
        do {
            let result = try managedContext.fetch(fetchRequest)
            if result.count < 1 {
                
                guard let imageUrl = Bundle.main.url(forResource: imageName, withExtension: "jpg", subdirectory: "Images") else {return}
                
                let categoryEntity = NSEntityDescription.entity(forEntityName: "Category", in: managedContext)!
                let category = NSManagedObject(entity: categoryEntity, insertInto: managedContext)
                category.setValue(name, forKeyPath: "categoryName")
                category.setValue(summary, forKey: "categorySummary")
                category.setValue(imageUrl, forKey: "categoryImageUrl")
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
                print("URI: \(data.value(forKey: "categoryImageUrl") as! URL)")
            }
        } catch {
            print(error)
        }
    }
    
    //Fetches data from the given gategory
    func getCategoryData(name: String){
        guard let appDel = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = appDel.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Category")
        fetchRequest.predicate = NSPredicate(format: "categoryName == %@", name)
        
        do {
            let result = try managedContext.fetch(fetchRequest) as! [NSManagedObject]
            print("Name: \(result[0].value(forKey: "categoryName") as! String)")
            print("Summary: \(result[0].value(forKey: "categorySummary") as! String)")
            print("File URL: \(result[0].value(forKey: "categoryImageUrl") as! URL)")
            
            
        } catch let error as NSError {
            print("There was an error processing your request: \(error)")
        }
        
    }
    
    //Deletes all data in a given entity. Good for wiping CoreData clean if need be.
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
    
    //Generates all the categories. Do not touch. Will break app
    func generateData(){
        createCategoryData(name: "ICT", summary: "Computers and stuff you know", imageName: "ICTImage")
        createCategoryData(name: "Humanities and Arts", summary: "punch of hippies",imageName: "ArtImage")
        createCategoryData(name: "Social sectors", summary: "Studies and work related to society",imageName: "SocietyImage")
        createCategoryData(name: "Education Sciences", summary: "",imageName: "EducationImage")
        createCategoryData(name: "Trade, Adminstration and Law", summary: "",imageName: "lawImage")
        createCategoryData(name: "Natural Sciences", summary: "",imageName: "NaturualImage")
        createCategoryData(name: "Technical Fields", summary: "", imageName: "TechImage")
        createCategoryData(name: "Agriculture and Forestry", summary: "",imageName: "AgricultureImage")
        createCategoryData(name: "Health and Wellbeing", summary: "", imageName: "HealthcareImage")
        createCategoryData(name: "Service Industry", summary: "", imageName: "ServicesImage")
        createCategoryData(name: "General Education", summary: "", imageName: "GeneralEduImage")
        createCategoryData(name: "Misc & Unkown", summary: "", imageName: "MiscImage")
    }
    
    
    
}
