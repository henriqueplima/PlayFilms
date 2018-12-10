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

typealias CompleteFetchMovies = (_ listMoves:[Movie], _ error:ErrorHandler?) -> Void

class MovieListViewModel: NSObject {
    
    var page : Int = 1
    var section : Int = 1
    var apiService = APIService()
    var synhronizer = Synchronizer()

    func fetchMovies(complete :@escaping CompleteFetchMovies) {
        
        guard CheckNetwork.Connection() else {
            self.fetchMoviesCoreData(complete: complete)
            return
        }
    
            apiService.callApi(url: APIService.EndPoints.moviesList(page: "\(page)",section: "\(section)", sort: .tileAsc).url, httpMethod: .get) { (response :APIServiceResult<MovieListResponse>) in
                
                switch response {
                case .Success(let moviesResponse):
                    complete(moviesResponse.results,nil)
                    //complete(moviesResponse.results)
                    if self.page >= moviesResponse.totalPage {
                        self.section += 1
                        self.page = 1
                    } else {
                        self.page += 1
                    }
                    
                    self.synhronizer.syncCoreData(moviesList: moviesResponse.results)
                case .Failure(let error):
                    self.fetchMoviesCoreData(complete: complete)
                }
            }
        
    }
    
    func fetchMoviesCoreData(complete: @escaping CompleteFetchMovies){
        self.synhronizer.allMovies(complete: { (result:APIServiceResult<[Movie]>) in
            switch result {
            case .Success(let movieList):
                complete(movieList,ErrorHandler.serviceConnection)
            case .Failure(let error):
                complete([],error)
                debugPrint("falha aqui \(error)")
            }
        })
    }
    
    func downloadCoverMovie(path:String, idMovie:Int,complete: @escaping (Data) -> Void){
        
        apiService.downloadImage(path: path) { (response:APIServiceResult<Data>) in
            
            if response.isSuccess, let imgData = response.value {
                complete(imgData)
                self.synhronizer.updateMovie(id: idMovie, imgData: imgData)
            }
        }
        
    }
    
    
}
