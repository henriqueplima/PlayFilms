//
//  MovieStore+CoreDataClass.swift
//  PlayFilms
//
//  Created by Henrique Pereira de Lima on 09/12/18.
//  Copyright © 2018 Henrique Pereira de Lima. All rights reserved.
//
//

import Foundation
import CoreData

@objc(MovieStore)
public class MovieStore: NSManagedObject {
    static let identifier = "MovieStore"
    convenience init(context: NSManagedObjectContext) {
        let entityDescription = NSEntityDescription.entity(forEntityName: MovieStore.identifier, in: context)!
        self.init(entity: entityDescription, insertInto: context)
        
    }
    
    convenience init(context: NSManagedObjectContext, movie:Movie) {
        let entityDescription = NSEntityDescription.entity(forEntityName: MovieStore.identifier, in: context)!
        self.init(entity: entityDescription, insertInto: context)
        
        self.title = movie.title
        self.coverPath = movie.coverPath
        //self.coverData = movie.coverData as! NSData
        self.voteCoverage = movie.voteAvarege
        self.releaseDate = movie.releaseDate
        self.overview = movie.overview
        self.id = Int64(movie.id)
        
    }

}
