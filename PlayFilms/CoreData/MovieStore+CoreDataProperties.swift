//
//  MovieStore+CoreDataProperties.swift
//  PlayFilms
//
//  Created by Henrique Pereira de Lima on 09/12/18.
//  Copyright © 2018 Henrique Pereira de Lima. All rights reserved.
//
//

import Foundation
import CoreData


extension MovieStore {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MovieStore> {
        return NSFetchRequest<MovieStore>(entityName: "MovieStore")
    }

    @NSManaged public var coverData: NSData?
    @NSManaged public var coverPath: String
    @NSManaged public var id: Int64
    @NSManaged public var overview: String
    @NSManaged public var releaseDate: String
    @NSManaged public var title: String
    @NSManaged public var voteCoverage: Float

}
