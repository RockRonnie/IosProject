//
//  Work+CoreDataClass.swift
//  
//
//  Created by iosdev on 22/11/2019.
//
//  Methods for handling coredata related to Work entity. Basic CRUD funcionality

import Foundation
import CoreData
import UIKit

public class Work: NSManagedObject {
    //Used to create a work position
    func createWorkPosition(name: String){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Work")
        fetchRequest.predicate = NSPredicate(format: "workPositionName == %@", name)
        do {
            let result = try managedContext.fetch(fetchRequest)
            if result.count < 1 { //Chekcs if there are any results. If not, allows to greate new entity
                let workEntity = NSEntityDescription.entity(forEntityName: "Work", in: managedContext)!
                let work = NSManagedObject(entity: workEntity, insertInto: managedContext)
                work.setValue(name, forKey: "workPositionName")
                try managedContext.save()
                print("Succesfully saved data for work \(name)")
            } else {
                print("Object found. Didn't set")
            }
        }catch let error as NSError{
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    //Fetches the work position for the given name.
    func getWorkPositionWithName(name:String) -> [NSManagedObject]{
        guard let appDel = UIApplication.shared.delegate as? AppDelegate else {return []}
        let managedContext = appDel.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Work")
        fetchRequest.predicate = NSPredicate(format: "workPositionName == %@", name)
        var returnResult = [NSManagedObject]()
        do {
            let result = try managedContext.fetch(fetchRequest) as! [NSManagedObject]
            returnResult = result
        } catch let error as NSError {
            print("There was an error processing your request: \(error)")
        }
        return returnResult
    }
    //Deletes desired position from coredata
    func deleteWorkWithName(name: String){
        guard let appDel = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = appDel.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Work")
        fetchRequest.predicate = NSPredicate(format: "workPositionName == %@", name)
        do {
            let result = try managedContext.fetch(fetchRequest) as! [NSManagedObject]
            managedContext.delete(result[0])
            try managedContext.save()
            print("Succesful in deleting position \(name)")
        } catch let error as NSError {
            print("There was an error processing your request: \(error)")
        }
    }
    //Update an existing work object inside core data
    func updateWorkWithName(oldName: String,newName: String, summary: String??){
        guard let appDel = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = appDel.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Work")
        fetchRequest.predicate = NSPredicate(format: "workPositionName == %@", oldName)
        do {
            let result = try managedContext.fetch(fetchRequest) as! [NSManagedObject]
            if (result.count > 0){
                let manage = result[0]
                manage.setValue(newName, forKey: "workPositionName")
                if let newSummary = summary {
                    manage.setValue(newSummary, forKey: "workSummary")
                }
                try managedContext.save()
                print("Succesfully Updated object to \(newName)")
            } else {
                print("Object not found. Didn't update.")
            }
        } catch let error as NSError {
            print("There was an error processing your request: \(error)")
        }
    }
}
