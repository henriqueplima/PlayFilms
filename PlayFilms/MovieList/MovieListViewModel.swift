//
//  MovieListViewModel.swift
//  PlayFilms
//
//  Created by Henrique Pereira de Lima on 08/12/18.
//  Copyright © 2018 Henrique Pereira de Lima. All rights reserved.
//

import UIKit

class MovieListViewModel: NSObject {
    
    var page : Int = 1
    var apiService = APIService()

    func fetchMovies(complete :@escaping (MovieListResponse) -> Void) {
        
        var param = ["page":"\(page)",
                     "sort_by":"title.asc"]
        
        apiService.callApi(url: APIService.EndPoints.moviesList.url, param: &param, httpMethod: .get) { (response : APIServiceResult<MovieListResponse>) in
            
            switch response {
                case .Success(let moviesResponse):
                    complete(moviesResponse)
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
                    debugPrint("sucess image")
                    complete(imageData)
                case .Failure():
                    debugPrint("falaha image")
            }
        }
        
    }
    
}
