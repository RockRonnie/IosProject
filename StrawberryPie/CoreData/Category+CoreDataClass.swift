//
//  Category+CoreDataClass.swift
//  
//
//  Created by Arttu Jokinen on 22/11/2019.
//
//  Used as the model for CategoryViewConroller. Provides CoreData operations.

import Foundation
import CoreData
import UIKit


public class Category: NSManagedObject {
    //This method is used to create data for a category
    func createCategoryData(name: String, summary: String, imageName: String, id: Int){
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
                category.setValue(id, forKey: "id")
                try managedContext.save()
                print("Succesfully saved data for category \(name)")
            } else {
                print("Object found. Didn't set")
            }
        }catch let error as NSError{
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    //Fetches all data in category entity and sorts them by the ID
    func getAllCategoryData(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Category")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        do {
            let result = try managedContext.fetch(fetchRequest)
            print("Results: \(result)")
            for data in result as! [NSManagedObject]{
                print("Name of category: \(data.value(forKey: "categoryName")as! String)")
                print("Summary: \(data.value(forKey: "categorySummary")as! String)")
                print("URI: \(data.value(forKey: "categoryImageUrl") as! URL)")
                print("ID: \(data.value(forKey: "id") as! Int)")
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
            print("ID: \(result[0].value(forKey: "id") as! Int)")
        } catch let error as NSError {
            print("There was an error processing your request: \(error)")
        }
    }
    //Returns the category names in an array of strings
    func getNames() -> Array<String>{
        var names = [String]()
        guard let appDel = UIApplication.shared.delegate as? AppDelegate else {return [""]}
        let managedContext = appDel.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Category")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        do {
            let result = try managedContext.fetch(fetchRequest)
            for data in result as! [NSManagedObject]{
                names.append(data.value(forKey: "categoryName")as! String)
            }
        }catch let error as NSError {
            print(error)
        }
        return names
    }
    //Returns category images in an array of UIImages
    func getImages() ->Array<UIImage>{
        var urls = [UIImage]()
        guard let appDel = UIApplication.shared.delegate as? AppDelegate else {return urls}
        let managedContext = appDel.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Category")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        do {
            let result = try managedContext.fetch(fetchRequest)
            for data in result as! [NSManagedObject]{
                //Converts URLs to UIImages.
                guard let data = try? Data(contentsOf: data.value(forKey: "categoryImageUrl") as! URL)else{return urls}
                let image: UIImage = UIImage(data: data)!
                urls.append(image)
            }
        } catch let error as NSError {
            print(error)
        }
        return urls
    }
    //This Should return the object
    func getEntity(name: String) -> [NSManagedObject] {
        var test = [NSManagedObject]()
        guard let appDel = UIApplication.shared.delegate as? AppDelegate else {return test}
        let managedContext = appDel.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Category")
        fetchRequest.predicate = NSPredicate(format: "categoryName == %@", name)
        do {
            let result = try managedContext.fetch(fetchRequest) as! [NSManagedObject]
            test = result
            
        } catch let error as NSError {
            print(error)
        }
        return test
    }
    //Deletes all data in a given entity. Good for wiping CoreData clean if need be.
    func deleteAllData(entity: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false
        do {
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
        createCategoryData(name: "ICT", summary: "Computers and stuff you know", imageName: "ICTImage",id: 0)
        createCategoryData(name: "Humanities and Arts", summary: "punch of hippies",imageName: "ArtImage",id: 1)
        createCategoryData(name: "Social sectors", summary: "Studies and work related to society",imageName: "SocietyImage",id: 2)
        createCategoryData(name: "Education Sciences", summary: "",imageName: "EducationImage",id: 3)
        createCategoryData(name: "Trade, Adminstration and Law", summary: "",imageName: "lawImage", id: 4)
        createCategoryData(name: "Natural Sciences", summary: "",imageName: "NaturalImage", id: 5)
        createCategoryData(name: "Technical Fields", summary: "", imageName: "TechImage", id: 6)
        createCategoryData(name: "Agriculture and Forestry", summary: "",imageName: "AgricultureImage",id:7)
        createCategoryData(name: "Health and Wellbeing", summary: "", imageName: "HealthcareImage",id:8)
        createCategoryData(name: "Service Industry", summary: "", imageName: "ServicesImage", id:9)
        createCategoryData(name: "General Education", summary: "", imageName: "GeneralEduImage",id:10)
        createCategoryData(name: "Misc & Unkown", summary: "", imageName: "MiscImage", id:11)
    }
}
