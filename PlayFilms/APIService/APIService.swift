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
    case Failure()
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
        var baseURLImage: URL {return URL(string: "https://image.tmdb.org/t/p/w500/")!}
        
        case moviesList
        case movieDetail(idMovie:String)
        
        var url : URL {
            switch self {
            case .moviesList:
                return baseURL.appendingPathComponent("4/list/1")
            case .movieDetail(let idMovie):
                return baseURL.appendingPathComponent("3/movie/\(idMovie)")
            }
        }
    }
    let apiKey = "7846906f24361a713ba2cc4d857acde5"
    let token = "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI3ODQ2OTA2ZjI0MzYxYTcxM2JhMmNjNGQ4NTdhY2RlNSIsInN1YiI6IjVjMGIyZmE3MGUwYTI2MzhiODA2MjVmZSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.faWR0dR6ai4vrnJEK20Tj9oziIUdQfT6O5HqBBbchak"
    let session = URLSession.shared
    
    func callApi<T:Decodable>(url: URL, param: inout[String:String], httpMethod: HTTPMethod, complete: @escaping (APIServiceResult<T>) -> Void) {
        
        var request = URLRequest(url: url)
        param["api_key"] = apiKey
        request.setValue(token, forHTTPHeaderField: "Authorization")
        //request.timeoutInterval = 20
        request.httpMethod = httpMethod.methodString
        request.httpBody =  try! JSONEncoder().encode(param)
        session.dataTask(with: request) { (response, _, error) in
            guard error == nil else {
                complete(.Failure())
                return
            }
            if let data = response {
                
                do{
                    //here dataResponse received from a network request
                    let jsonResponse = try JSONSerialization.jsonObject(with:
                        data, options: [])
                    print(jsonResponse) //Response result
                } catch let parsingError {
                    print("Error", parsingError)
                }
                
                let parse : APIServiceResult<T> = JSONDecoder().decodeResponse(from: data)
                complete(parse)
                return
                
            }
            complete(.Failure())
        }.resume()
        
    }
    
    func downloadImage(url:URL, complete: @escaping (APIServiceResult<Data>) -> Void){
        
        let request = URLRequest(url: url)
        session.dataTask(with: request) { (responseData, _, error) in
            guard error == nil else {
                complete(.Failure())
                return
            }
            if let data = responseData {
                complete(.Success(data))
                return
            }
            complete(.Failure())
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
            return .Failure()
        }
    }
}
