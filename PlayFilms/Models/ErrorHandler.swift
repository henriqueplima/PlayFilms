//
//  ErrorHandler.swift
//  PlayFilms
//
//  Created by Henrique Pereira de Lima on 09/12/18.
//  Copyright © 2018 Henrique Pereira de Lima. All rights reserved.
//

import UIKit

enum ErrorHandler : Error {
    case serviceConnection
    case parseResponse
    case fetchCoreData
    
    var localizedDescription: String {
        switch self {
            case .serviceConnection:
                return "We could not fetch the data. Check your connection"
            case .parseResponse:
                return "error in parse of response object"
            case .fetchCoreData:
                return "Erro fetching data"
        }
       
        
    }
    
}
