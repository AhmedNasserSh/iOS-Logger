//
//  CacheProvider.swift
//  LoggerApp
//
//  Created by Ahmed Nasser on 12/19/20.
//  Copyright © 2020 Instabug. All rights reserved.
//

import Foundation
import CoreData

class LogsProvider {
    static let shared = LogsProvider()
    
    private init() {}
    
    func saveLog(message:String, errorLevel:String) {
        let context = CoreDataStack.controller.persistentContainer.newBackgroundContext()
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        context.undoManager = nil
        
        context.performAndWait {
            guard let log = NSEntityDescription.insertNewObject(forEntityName: "Log", into: context) as? LogEntity else{
                return
            }
            
            log.update(message: message, errorLevel: errorLevel)
            
            if context.hasChanges {
                do {
                    try context.save()
                    print("saved \(message)")
                    
                }catch {
                    context.delete(log)
                }
                context.reset()
            }
        }
    }
    
    func fetchLogs(_ completion :@escaping ([LogEntity]) -> Void){
        let privateManagedObjectContext = CoreDataStack.controller.persistentContainer.newBackgroundContext()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Log")
        
        
        let asyncFetchRequest = NSAsynchronousFetchRequest(fetchRequest: fetchRequest) { (asyncFetchResult) in
            guard let result = asyncFetchResult.finalResult as? [LogEntity] else { return }
            
            return DispatchQueue.main.async {
                let mainContext = CoreDataStack.controller.mainContext
                let logs :[LogEntity] = result.lazy
                    .compactMap{$0.objectID}
                    .compactMap{mainContext.object(with: $0) as? LogEntity}
                completion(logs)
            }
        }
        
        do {
            // Executes `asynchronousFetchRequest`
            try privateManagedObjectContext.execute(asyncFetchRequest)
        } catch let error {
            print("NSAsynchronousFetchRequest error: \(error)")
        }
        
    }
    
    func resetLogs() {
        let logs = NSFetchRequest<NSFetchRequestResult>(entityName: "Log")
        
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: logs)
        batchDeleteRequest.resultType = .resultTypeObjectIDs
        
        let context = CoreDataStack.controller.persistentContainer.newBackgroundContext()
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        context.undoManager = nil
        
        
        do {
            let batchDeleteResult = try context.execute(batchDeleteRequest) as? NSBatchDeleteResult
            
            if let deletedObjectIDs = batchDeleteResult?.result as? [NSManagedObjectID] {
                NSManagedObjectContext.mergeChanges(fromRemoteContextSave: [NSDeletedObjectsKey: deletedObjectIDs],
                                                    into: [CoreDataStack.controller.mainContext])
            }
        } catch {
            print("Error: \(error)\nCould not batch delete existing records.")
            return
        }
        
    }
    
    
}
