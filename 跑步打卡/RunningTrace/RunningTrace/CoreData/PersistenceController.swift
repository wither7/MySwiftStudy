//
//  PersistenceController.swift
//  RunningTrace
//
//  Created by 袁新杰 on 2021/12/12.
//

import Foundation
import CoreData

struct PersistenceController {
    // A singleton for entire app to use
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "RunningTrace")

        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }

        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func save() {
        let context = container.viewContext

        if context.hasChanges {
            do {
                try context.save()
                print("Preferences saved")
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func getAllRunRecords(dateAscending : Bool) -> [RunRecord]{
        let request: NSFetchRequest<RunRecord> = RunRecord.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \RunRecord.runningDate, ascending: dateAscending )]
        do{
            return try self.container.viewContext.fetch(request)
        }catch{
            print("获取跑步记录失败")
            return []
        }
        
    }
    
    // 保存一次跑步记录
    func storeRunRecord( pace : String , distance: String, startDate: Date, time: Double) {
        let context = container.viewContext
        
        let newRun = RunRecord(context: context)
        newRun.runningPace = pace
        newRun.runningDistance = distance
        newRun.runningDate = startDate
        newRun.runningTime = time
        
        do {
            try context.save()
            print("Run Record saved")
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func deleteRunRecords(runRecord : RunRecord){
        let context = container.viewContext
        context.delete(runRecord)
        do{
            try  context.save()
        }
        catch{
            context.rollback()
            print("删除跑步记录失败 \(error)")
        }
    }
    
    
    func deleteAllRunRecords() {
        let context = container.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "RunRecord")
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try context.fetch(fetchRequest)
            for managedObject in results {
                if let managedObjectData: NSManagedObject = managedObject as? NSManagedObject {
                    context.delete(managedObjectData)
                }
            }
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // 保存一次跑步记录
    func storeUserSetting(color : String , usingPace: Bool , deleteEnabled:Bool , BestLocation : Bool) {
        let context = container.viewContext
        
        let newSetting = UserSetting(context: context)
        newSetting.color = color
        newSetting.usingPace = usingPace
        newSetting.deleteEnabed = deleteEnabled
        newSetting.usingBestLocation = BestLocation
        
        do {
            try context.save()
            print("User Setting saved")
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func updateUserSetting(existingSetting : UserSetting , color : String , usingPace: Bool , deleteEnabled:Bool , BestLocation : Bool , drawingMap : Bool = true ) {
        let context = container.viewContext
              
              context.performAndWait {
                existingSetting.color = color
                existingSetting.usingPace = usingPace
                existingSetting.deleteEnabed = deleteEnabled
                existingSetting.usingBestLocation = BestLocation
                existingSetting.drawingMap = drawingMap
                  
                  do {
                      try context.save()
                      print("User Settings updated")
                  } catch {
                      print(error.localizedDescription)
                  }
              }
    }
    
  
    
   
    
   
        
    
}
