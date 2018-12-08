//
//  MoviesDataModel.swift
//  PlayFilms
//
//  Created by Henrique Pereira de Lima on 08/12/18.
//  Copyright © 2018 Henrique Pereira de Lima. All rights reserved.
//

import UIKit

//class MoviesDataModel: NSObject {

    struct Movie : Codable {
        
        var title : String
        var id : Int
        var overview : String
        var releaseDate : String
        var coverPath : String
        var coverData : Data?
        
        enum CodingKeys : String, CodingKey {
            case title
            case id
            case overview
            case releaseDate = "release_date"
            case coverPath = "poster_path"
            case coverData
        }
        
    }
    
    struct MovieListResponse : Decodable {
        var results : [Movie]
        var name : String
    }

//}
