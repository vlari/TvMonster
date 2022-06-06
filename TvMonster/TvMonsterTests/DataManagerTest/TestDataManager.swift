//
//  TestDataManager.swift
//  TvMonsterTests
//
//  Created by Obed Garcia on 5/6/22.
//

import Foundation
import CoreData
@testable import TvMonster

class TestDataManager: DataManager {
    
    override init() {
        super.init()
        
        let persistentStoreDescription = NSPersistentStoreDescription()
        persistentStoreDescription.type = NSInMemoryStoreType
        
        let container = NSPersistentContainer(name: DataManager.containerName,
                                              managedObjectModel: DataManager.model)
            
        container.persistentStoreDescriptions = [persistentStoreDescription]
        
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("error \(error)")
            }
        }
        
        // Overrirde the persistence container
        persistentContainer = container
    }
    
}
