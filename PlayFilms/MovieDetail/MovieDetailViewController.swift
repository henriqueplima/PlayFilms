//
//  MovieDetailViewController.swift
//  PlayFilms
//
//  Created by Henrique Pereira de Lima on 09/12/18.
//  Copyright © 2018 Henrique Pereira de Lima. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {

    var movie : Movie?
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgCover: UIImageView!
    @IBOutlet weak var lblAvarage: UILabel!
    @IBOutlet weak var lblReleaseDate: UILabel!
    @IBOutlet weak var lblOverview: UILabel!
    var seila : MessageAlert?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let movie = self.movie {
            self.lblTitle.text = movie.title
            self.lblOverview.text = movie.overview
            self.lblReleaseDate.text = "premiere: \(movie.getReleaseDataFormat)"
            self.lblAvarage.text = String(format: "Avarege %.1f", movie.voteAvarege)
            if let imageData = movie.coverData {
                self.imgCover.image = UIImage(data: imageData)
            }
        }
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func toBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
