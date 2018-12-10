//
//  LoadingCell.swift
//  PlayFilms
//
//  Created by Henrique Pereira de Lima on 10/12/18.
//  Copyright © 2018 Henrique Pereira de Lima. All rights reserved.
//

import UIKit

class LoadingCell: UICollectionViewCell {
    
    @IBOutlet weak var indicator : UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.indicator.startAnimating()
    }
    
}
