//
//  ErrorCell.swift
//  PlayFilms
//
//  Created by Henrique Pereira de Lima on 10/12/18.
//  Copyright © 2018 Henrique Pereira de Lima. All rights reserved.
//

import UIKit

protocol ErrorCellProtocol {
    func tryAgain()
}

class ErrorCell: UICollectionViewCell {
    
    @IBOutlet weak var lblMessage : UILabel!
    @IBOutlet weak var btnAgain : UIButton!
    var delegate : ErrorCellProtocol?
    
    @IBAction func doTry(_ sender: Any) {
        
        self.delegate?.tryAgain()
        
    }
    
    
}
