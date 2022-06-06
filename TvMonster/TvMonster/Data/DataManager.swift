//
//  DataManager.swift
//  TvMonster
//
//  Created by Obed Garcia on 5/6/22.
//

import Foundation
import CoreData

class DataManager: ObservableObject {
    var persistentContainer: NSPersistentContainer
    static let containerName = "TvMonster"
    
    // Get data model file instance
    public static let model: NSManagedObjectModel = {
        let modelURL = Bundle.main.url(forResource: containerName, withExtension: "momd")!
      return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    static let shared = DataManager()
    
    init() {
        persistentContainer = NSPersistentContainer(name: DataManager.containerName)
        persistentContainer.loadPersistentStores { description, error in
            
            if let error = error {
                fatalError("Failed to initialize Core Data \(error)")
            }
        }
    }
}
