//
//  MovieCoverCell.swift
//  PlayFilms
//
//  Created by Henrique Pereira de Lima on 08/12/18.
//  Copyright © 2018 Henrique Pereira de Lima. All rights reserved.
//

import UIKit

class MovieCoverCell: UICollectionViewCell {
    
    static let reuseIdentifier = "MovieCoverCell"
    
    @IBOutlet weak var imgCover : UIImageView!
    @IBOutlet weak var lblTitle : UILabel!
    
    func setMovie(_ movie:Movie){
        self.lblTitle.text = movie.title
        if let imageData = movie.coverData {
            self.imgCover.image = UIImage(data: imageData)
        }
    }
    
    func setImageCover(imageCover : UIImage) {
        self.imgCover.image = imageCover
    }
    
    static func size(for widthView: CGFloat) -> CGSize {
        let numberOfCells = CGFloat(3)
        let width = widthView / numberOfCells
        return CGSize(width: width, height: width + 30)
    }
    
    
    
}
