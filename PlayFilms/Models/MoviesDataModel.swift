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
        var voteAvarege : Float
        
        var getReleaseDataFormat : String {
            let formatter = DateFormatter()
            formatter.locale = Locale.current
            formatter.dateFormat = "yyyy-MM-dd"
            if let date = formatter.date(from: releaseDate) {
                formatter.dateFormat = "MMMM dd, yyyy"
                return formatter.string(from: date)
            }
            return "-"
        }
        
        enum CodingKeys : String, CodingKey {
            case title
            case id
            case overview
            case releaseDate = "release_date"
            case coverPath = "poster_path"
            case coverData
            case voteAvarege = "vote_average"
        }
        
        init(title : String, id:Int, overview:String, release:String, path:String, avarage:Float, coverData:Data?) {
            self.title = title
            self.id = id
            self.overview = overview
            self.releaseDate = release
            self.coverPath = path
            self.coverData = coverData
            self.voteAvarege = avarage
        }
        
    }
    
    struct MovieListResponse : Decodable {
        var results : [Movie]
        var name : String
        var totalPage : Int
        
        enum CodingKeys : String, CodingKey {
            case results
            case name
            case totalPage = "total_pages"
        }
        
    }

//}
