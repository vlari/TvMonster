//
//  TvDataService.swift
//  TvMonster
//
//  Created by Obed Garcia on 5/6/22.
//

import Foundation
import CoreData

protocol DataPersistable {
    func isFavorite(objectId: String) -> Bool
    func deleteFavorite(objectId: String)
    
    func getFavoriteShows(with name: String) -> [Show]
    func saveShow(show: Show, completion: @escaping (Result<Bool, Error>) -> ())
}

class TvDataService: NSObject, DataPersistable {
    private var dataManager: DataManager
    @Published var showEntities: [ShowEntity] = [ShowEntity]()
    private lazy var fetchedResultsController: NSFetchedResultsController<ShowEntity> = getFetchResultsController()
    
    init(dataManager: DataManager) {
        self.dataManager = dataManager
    }
    
    func isFavorite(objectId: String) -> Bool {
        let fetchRequest: NSFetchRequest<ShowEntity>
        fetchRequest = ShowEntity.fetchRequest()
        
        fetchRequest.predicate = NSPredicate(format: "id LIKE %@", objectId)
        
        do {
            _ = try dataManager.persistentContainer.viewContext.fetch(fetchRequest)
            return true
        } catch {
            return false
        }
    }
    
    // MARK: - Public Methods
    func getFavoriteShows(with name: String = "") -> [Show] {
        fetchedResultsController = getFetchResultsController(withQuery: name)
        
        let entities = fetchShows()
        
        let savedShows: [Show] = entities.compactMap({ showEntity in
            let genres: [String]? = showEntity.genres?.components(separatedBy: ",")
            
            return Show(id: Int(showEntity.showid),
                        name: showEntity.name,
                        genres: genres,
                        schedule: ShowSchedule(time: showEntity.time ?? "", days: showEntity.days?.components(separatedBy: ",") ?? [String]() ),
                        summary: showEntity.summary,
                        rating:  ShowRating(average: ( (showEntity.rating ?? "") as NSString ).doubleValue),
                        image: MediaImage(medium: showEntity.mediumimage, original: showEntity.originalimage),
                        premiered: showEntity.date,
                        savedId: showEntity.id)
        })
        
        return savedShows
    }
    
    func saveShow(show: Show, completion: @escaping (Result<Bool, Error>) -> ()) {
        dataManager.persistentContainer.performBackgroundTask { (context) in
            let showEntity = ShowEntity(context: context)

            showEntity.id = UUID().uuidString
            showEntity.showid = Int64(show.id)
            showEntity.name = show.name
            showEntity.summary = show.summary
            showEntity.time = show.schedule?.time
            showEntity.days = show.schedule?.days.joined(separator: ",")
            showEntity.date = show.premiered
            showEntity.genres = show.genres?.joined(separator: ",")
            showEntity.mediumimage = show.image?.medium
            showEntity.originalimage = show.image?.original
            let ratingValue: Double = show.rating?.average ?? 0
            showEntity.rating = "\(ratingValue)"

            do {
                try context.save()
                DispatchQueue.main.async {
                    completion(.success(true))
                }
            } catch let error as NSError {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    func deleteFavorite(objectId: String) {
        let savedShowEntity = showEntities.first { $0.id == objectId }
        guard let show = savedShowEntity else { return }
        
        delete(entity: show)
    }
    
    func delete(entity: ShowEntity) {
        dataManager.persistentContainer.viewContext.delete(entity)
        applyChanges()
    }

    // MARK: - Private Methods
    private func save() {
        do {
            try dataManager.persistentContainer.viewContext.save()
        } catch {
            
            // MARK: - This two lines are for debugging only
            //let nsError = error as NSError
            //fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    private func fetchShows() -> [ShowEntity] {
        do {
            try fetchedResultsController.performFetch()
            self.showEntities = fetchedResultsController.fetchedObjects ?? []
            return showEntities
        } catch let error as NSError {
            print("\(error)")
            return []
        }
    }
    
    private func getFetchResultsController(withQuery: String = "") -> NSFetchedResultsController<ShowEntity> {
        let fetchRequest: NSFetchRequest<ShowEntity> = ShowEntity.fetchRequest()
        let nameSort = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [nameSort]
        fetchRequest.fetchBatchSize = 20
        
        if !withQuery.isEmpty {
            fetchRequest.predicate = NSPredicate(format: "name CONTAINS[c] %@", withQuery)
        }
        
         
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataManager.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }
    
    private func applyChanges() {
        save()
    }
    
}

// MARK: - NSFetched Results Delegate
extension TvDataService: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let showList = controller.fetchedObjects as? [ShowEntity] else { return }
        self.showEntities = showList
    }
}
