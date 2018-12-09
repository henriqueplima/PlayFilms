//
//  MovieListViewModel.swift
//  PlayFilms
//
//  Created by Henrique Pereira de Lima on 08/12/18.
//  Copyright © 2018 Henrique Pereira de Lima. All rights reserved.
//

import UIKit
import CoreData

enum SortMovie : String {
    case tileAsc = "title.asc"
    
    var valueString : String {
        switch self {
        case .tileAsc:
            return self.rawValue
        }
    }
    
}

class MovieListViewModel: NSObject {
    
    var page : Int = 1
    var apiService = APIService()

    func fetchMovies(complete :@escaping ([Movie]) -> Void) {
        
        apiService.callApi(url: APIService.EndPoints.moviesList(page: "\(page)", sort: .tileAsc).url, httpMethod: .get) { (response :APIServiceResult<MovieListResponse>) in
            
            switch response {
            case .Success(let moviesResponse):
                complete(moviesResponse.results)
                self.page += 1
            case .Failure():
                debugPrint("falha aqui")
            }

            
        }
        
    }
    
    func downloadCoverMovie(path:String, complete: @escaping (Data) -> Void){
        
        apiService.downloadImage(path: path) { (response:APIServiceResult<Data>) in
            switch response {
                case .Success(let imageData):
                    complete(imageData)
                case .Failure():
                    debugPrint("falaha image")
            }
        }
        
    }
    
//    func storeMovies(movie:Movie) {
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        let context = appDelegate.persistentContainer.viewContext
//        let entity = NSEntityDescription.entity(forEntityName: "Movie", in: context)
//        let newMovie = NSManageObject()
//    }
    
}
