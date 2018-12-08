//
//  ViewController.swift
//  PlayFilms
//
//  Created by Henrique Pereira de Lima on 08/12/18.
//  Copyright © 2018 Henrique Pereira de Lima. All rights reserved.
//

import UIKit

struct Teste : Decodable {
    var seila : String
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        var param = ["page":"1",
                     "sor_by":"vote_avarage.desc"]
        var api = APIService()
        
        api.callApi(url: APIService.EndPoints.moviesList.url, param: &param, httpMethod: .get) { (response:APIServiceResult<MoveListResponse>) in
            debugPrint("sei la")
        }
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    


}

