//
//  APIService.swift
//  PlayFilms
//
//  Created by Henrique Pereira de Lima on 08/12/18.
//  Copyright © 2018 Henrique Pereira de Lima. All rights reserved.
//

import UIKit

enum APIServiceResult<T>{
    case Success(T)
    case Failure(_ error:ErrorHandler)
    
    var isSuccess : Bool {
        switch self {
        case .Success:
            return true
        case .Failure:
            return false
        }
    }
    
    var value : T? {
        switch self {
        case .Success(let value):
            return value
        case .Failure:
            return nil
        }
    }
    
    var error : ErrorHandler? {
        switch self {
        case .Success:
            return nil
        case .Failure(let error):
            return error
        }
    }
}

class APIService: NSObject {
    
    enum HTTPMethod : Int {
        case post
        case get
        var methodString : String {
            switch self {
            case .post:
                return "POST"
            case .get:
                return "GET"
            }
        }
    }
    
    enum EndPoints {
        
        var baseURL: URL { return URL(string: "https://api.themoviedb.org/")! }
        var baseURLImage: URL {return URL(string: "https://image.tmdb.org/t/p/w500")!}
        
        case moviesList(page:String, section:String,sort:SortMovie)
        case movieDetail(idMovie:String)
        case movieImage(path:String)
        
        var url : URL {
            switch self {
            case .moviesList(let page, let section,let sort):
                var urlComponent = URLComponents(url: baseURL.appendingPathComponent("4/list/\(section)"), resolvingAgainstBaseURL: false)
                urlComponent?.queryItems = APIParameters.movieList(page: page, sortBy: sort).parameters
                return urlComponent?.url ?? baseURL.appendingPathComponent("4/list/\(section)")
            case .movieDetail(let idMovie):
                return baseURL.appendingPathComponent("3/movie/\(idMovie)")
            case .movieImage(let path):
                return baseURLImage.appendingPathComponent(path)
            }
        }
        
        
    }
    
    enum APIParameters {
        var apiKey : String { return "7846906f24361a713ba2cc4d857acde5"}
        var apiKeyLabel : String {return "api_key"}
        
        case movieList(page:String,sortBy:SortMovie)
        
        var parameters : [URLQueryItem] {
            
            switch self {
            case .movieList(let page, let sort):
                return [
                    URLQueryItem(name: apiKeyLabel, value: apiKey),
                    URLQueryItem(name: "sort_by", value: sort.valueString),
                    URLQueryItem(name: "page", value: page),
                ]
            
            }
            
        }
        
        
    }
    
    let token = "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI3ODQ2OTA2ZjI0MzYxYTcxM2JhMmNjNGQ4NTdhY2RlNSIsInN1YiI6IjVjMGIyZmE3MGUwYTI2MzhiODA2MjVmZSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.faWR0dR6ai4vrnJEK20Tj9oziIUdQfT6O5HqBBbchak"
    let session = URLSession.shared
    
     func callApi<T:Decodable>(url: URL, httpMethod: HTTPMethod, complete: @escaping (APIServiceResult<T>) -> Void) {
        var request = URLRequest(url: url)
        request.setValue(token, forHTTPHeaderField: "Authorization")
        request.timeoutInterval = 20
        request.httpMethod = httpMethod.methodString
        session.dataTask(with: request) { (response, _, error) in
            guard error == nil else {
                complete(.Failure(ErrorHandler.serviceConnection))
                return
            }
            if let data = response {
                let parse : APIServiceResult<T> = JSONDecoder().decodeResponse(from: data)
                complete(parse)
                return
                
            }
            complete(.Failure(ErrorHandler.serviceConnection))
        }.resume()
        
    }
    
    func downloadImage(path:String, complete: @escaping (APIServiceResult<Data>) -> Void){
        let url = APIService.EndPoints.movieImage(path: path).url
        let request = URLRequest(url: url)
        session.dataTask(with: request) { (responseData, _, error) in
            guard error == nil else {
                complete(.Failure(ErrorHandler.serviceConnection))
                return
            }
            if let data = responseData {
                complete(.Success(data))
                return
            }
            complete(.Failure(ErrorHandler.serviceConnection))
        }.resume()
        
    }

}

extension JSONDecoder {
    func decodeResponse<T: Decodable>(from response: Data) -> APIServiceResult<T> {
        
        do {
            let item = try decode(T.self, from: response)
            return .Success(item)
        } catch {
            print(error)
            return .Failure(ErrorHandler.parseResponse)
        }
    }
}
