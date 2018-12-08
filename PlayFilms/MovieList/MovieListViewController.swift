//
//  MovieListViewController.swift
//  PlayFilms
//
//  Created by Henrique Pereira de Lima on 08/12/18.
//  Copyright © 2018 Henrique Pereira de Lima. All rights reserved.
//

import UIKit

class MovieListViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    
    @IBOutlet weak var collectionView : UICollectionView!
    let viewModel = MovieListViewModel()
    var moviesList : [MovieListResponse] = [] {
        didSet{
            self.collectionView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        self.viewModel.fetchMovies { (response) in
            DispatchQueue.main.async { self.moviesList.append(response) }
        }
        

        // Do any additional setup after loading the view.
    }
    

    
    // MARK - CollectionView DataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.moviesList.count > 0 {
            return self.moviesList[section].results.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCoverCell.reuseIdentifier, for: indexPath) as! MovieCoverCell
        var movie = self.moviesList[indexPath.section].results[indexPath.row]
        cell.setMovie(movie)
        if movie.coverData == nil {
            self.viewModel.downloadCoverMovie(path: movie.coverPath) { (data) in
                DispatchQueue.main.async {
                    movie.coverData = data
                    cell.setMovie(movie)
                }
            }
        }
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.size.width - 30
        return MovieCoverCell.size(for: width)
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
