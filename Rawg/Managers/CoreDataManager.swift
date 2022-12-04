//
//  CoreDataManager.swift
//  Rawg
//
//  Created by Enrico Irawan on 26/11/22.
//

import CoreData
import UIKit

class CoreDataManager {
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Rawg")
        
        container.loadPersistentStores { _, error in
            guard error == nil else {
                fatalError("Unresolved error \(error!)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = false
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.shouldDeleteInaccessibleFaults = true
        container.viewContext.undoManager = nil
        
        return container
    }()
    
    private func newTaskContext() -> NSManagedObjectContext {
        let taskContext = persistentContainer.newBackgroundContext()
        taskContext.undoManager = nil
        
        taskContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return taskContext
    }
    
    func getAllGames(completion: @escaping(_ games: [GameModel]) -> Void) {
        let taskContext = newTaskContext()
        taskContext.perform {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "GameEntity")
            do {
                let results = try taskContext.fetch(fetchRequest)
                var games: [GameModel] = []
                for result in results {
                    let game = GameModel(
                        id: result.value(forKeyPath: "id") as! Int,
                        name: result.value(forKeyPath: "name") as! String,
                        released: result.value(forKeyPath: "released") as? String,
                        backgroundImage: result.value(forKeyPath: "backgroundImage") as? String,
                        rating: result.value(forKeyPath: "rating") as! Double
                    );
                    games.append(game)
                }
                completion(games)
            } catch let error as NSError {
                fatalError("Could not save. \(error), \(error.userInfo)")
            }
        }
    }
    
    func insertGame(
        _ id: Int,
        _ name: String,
        _ released: String,
        _ backgroundImage: String,
        _ rating: Double,
        completion: @escaping() -> Void
    ) {
        let taskContext = newTaskContext()
        taskContext.performAndWait {
            if let entity = NSEntityDescription.entity(forEntityName: "GameEntity", in: taskContext) {
                let game = NSManagedObject(entity: entity, insertInto: taskContext)
                game.setValue(id, forKeyPath: "id")
                game.setValue(name, forKeyPath: "name")
                game.setValue(released, forKeyPath: "released")
                game.setValue(backgroundImage, forKeyPath: "backgroundImage")
                game.setValue(rating, forKeyPath: "rating")
                    
                do {
                    try taskContext.save()
                    completion()
                } catch let error as NSError {
                    fatalError("Could not save. \(error), \(error.userInfo)")
                }
            }
        }
    }
    
    func deleteGame(_ id: Int, completion: @escaping() -> Void) {
      let taskContext = newTaskContext()
      taskContext.perform {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "GameEntity")
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "id == \(id)")
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        batchDeleteRequest.resultType = .resultTypeCount
        if let batchDeleteResult = try? taskContext.execute(batchDeleteRequest) as? NSBatchDeleteResult {
          if batchDeleteResult.result != nil {
            completion()
          }
        }
      }
    }
    
    func checkIsFavorite(_ id: Int, completion: @escaping(_ isFavorite: Bool) -> Void) {
        let taskContext = newTaskContext()
        taskContext.perform {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "GameEntity")
            fetchRequest.fetchLimit = 1
            fetchRequest.predicate = NSPredicate(format: "id == \(id)")
            
            do {
                let result = try taskContext.fetch(fetchRequest).count
                
                if result > 0 {
                    completion(true)
                } else {
                    completion(false)
                }
            } catch let error as NSError {
                fatalError(error.localizedDescription)
            }
        }
    }
}
