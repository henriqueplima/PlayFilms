//
//  Synchronizer.swift
//  PlayFilms
//
//  Created by Henrique Pereira de Lima on 09/12/18.
//  Copyright © 2018 Henrique Pereira de Lima. All rights reserved.
//

import UIKit
import CoreData

class Synchronizer: NSObject {
    var managedContext:NSManagedObjectContext
    
    override init() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.managedContext = appDelegate.persistentContainer.viewContext
    }
    
    func syncCoreData(moviesList:[Movie]) {
        for movie in moviesList {
            MovieStore(context: self.managedContext, movie: movie)
        }
        do {
            try self.managedContext.save()
        } catch(let error) {
            debugPrint("error save: \(error)")
        }
        
    }
    
    func allMovies(complete:@escaping (APIServiceResult<[Movie]>)-> Void) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: MovieStore.identifier)
        
        do {
            let result = try managedContext.fetch(fetchRequest) as! [MovieStore]
            if result.count > 0 {
                let movieList = convertMovieStore(storeList: result)
                complete(.Success(movieList))
            }
        } catch {
            complete(.Failure(ErrorHandler.fetchCoreData))
        }        
        
    }
    
    func convertMovieStore(storeList: [MovieStore]) -> [Movie] {
        var movieList : [Movie] = []
        for movieStore in storeList {
            let movie = Movie(title: movieStore.title, id: Int(movieStore.id), overview: movieStore.overview, release: movieStore.releaseDate, path: movieStore.coverPath, avarage: movieStore.voteCoverage, coverData: movieStore.coverData as Data?)
            movieList.append(movie)
        }
        return movieList
    }

}
