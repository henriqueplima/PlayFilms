//
//  MovieListViewController.swift
//  PlayFilms
//
//  Created by Henrique Pereira de Lima on 08/12/18.
//  Copyright © 2018 Henrique Pereira de Lima. All rights reserved.
//

import UIKit

class MovieListViewController: UIViewController  {
    
    @IBOutlet weak var collectionView : UICollectionView!
    let viewModel = MovieListViewModel()
    var isLoading = true
    var refreshFooter : RefreshControlCustom?
    let footerViewReuseIdentifier = "RefreshControlCustom"
    
    @IBOutlet weak var viewError: UIView!
    
    var moviesList : [Movie] = [] {
        didSet{
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.refreshControl.endRefreshing()
            }
            
        }
    }
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(handleRefresh(_:)),
                                 for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor.red
        var attribute =  [NSAttributedString.Key.foregroundColor : UIColor.red]
        var attributedString = NSAttributedString(string: "Pull to refresh", attributes: attribute) //NSMutableAttributedString(string: "Pull to refresh")
        refreshControl.attributedTitle = attributedString
        
        return refreshControl
    }()
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        
       fetchMovies()
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        //self.collectionView.addSubview(self.refreshControl)
        self.collectionView.refreshControl = refreshControl
        
        fetchMovies()
        

        // Do any additional setup after loading the view.
    }
    
    func fetchMovies(){
        
        self.viewModel.fetchMovies { (list, error) in
            
            DispatchQueue.main.async {
                
                if (list.count > 0 && error == nil){
                    self.moviesList.append(contentsOf: list)
                } else if list.count > 0,let newError = error {
                    self.moviesList = list
                    self.showAlert(error: newError)
                    // errorView
                } else{
                    self.viewError.isHidden = false
                }
                self.isLoading = false
            }
        
        }
    }
    
    func showAlert(error:ErrorHandler){
        let alert = MessageAlert.loadNib()
        alert.lblMessage.text = error.localizedDescription
        alert.config(parent: self.view)
        self.view.layoutIfNeeded()
    }
    
    func movieSelected(at indexPath:IndexPath) {
        let movie = self.moviesList[indexPath.row]
        let detailController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MovieDetailViewController") as! MovieDetailViewController
        detailController.movie = movie
        self.present(detailController, animated: true, completion: nil)
        
    }
    
    
    @IBAction func tryAgain(_ sender: Any) {
        self.collectionView.reloadData()
        self.viewError.isHidden = true
        self.fetchMovies()
    }
    
}

extension MovieListViewController:UIScrollViewDelegate{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let threshold   = 100.0 ;
        let contentOffset = scrollView.contentOffset.y;
        let contentHeight = scrollView.contentSize.height;
        let diffHeight = contentHeight - contentOffset;
        let frameHeight = scrollView.bounds.size.height;
        var triggerThreshold  = Float((diffHeight - frameHeight))/Float(threshold);
        triggerThreshold   =  min(triggerThreshold, 0.0)
        let pullRatio  = min(Swift.abs(triggerThreshold), 1.0)
        self.refreshFooter?.setTransform(inTransform: CGAffineTransform.identity, scaleFactor: CGFloat(pullRatio))
        if pullRatio >= 1 {
            self.refreshFooter?.animateFinal()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let contentOffset = scrollView.contentOffset.y;
        let contentHeight = scrollView.contentSize.height;
        let diffHeight = contentHeight - contentOffset;
        let frameHeight = scrollView.bounds.size.height;
        let pullHeight  = Swift.abs(diffHeight - frameHeight)
        if pullHeight == 0.0
        {
            
            if (self.refreshFooter?.isAnimatingFinal)! {
                self.isLoading = true
                self.refreshFooter?.startAnimate()
                fetchMovies()
            }
        }
        
    }
}

extension MovieListViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.moviesList.count > 0 ? self.moviesList.count : 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if (self.moviesList.count == 0) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LoadingCell", for: indexPath)
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCoverCell.reuseIdentifier, for: indexPath) as! MovieCoverCell
        let movie = self.moviesList[indexPath.row]
        cell.setMovie(movie)
        if movie.coverData == nil {
            self.viewModel.downloadCoverMovie(path: movie.coverPath, idMovie:movie.id) { (data) in
                DispatchQueue.main.async {
                    self.moviesList[indexPath.row].coverData = data
                    cell.setMovie(self.moviesList[indexPath.row])
                }
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter {
            let aFooterView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerViewReuseIdentifier, for: indexPath) as! RefreshControlCustom
            self.refreshFooter = aFooterView
            self.refreshFooter?.backgroundColor = UIColor.clear
            return aFooterView
        } else {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerViewReuseIdentifier, for: indexPath)
            return headerView
        }
    }
    
    // MARK - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.movieSelected(at: indexPath)
        
    }
    
    // MARK - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if self.moviesList.count == 0 {
            return CGSize(width: 60, height: 60)
        }
        
        let width = collectionView.bounds.size.width - 30
        return MovieCoverCell.size(for: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if isLoading {
            return CGSize.zero
        }
        return CGSize(width: collectionView.bounds.size.width, height: 126)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        if self.moviesList.count == 0 {
            let left = (self.collectionView.frame.width / 2) - 44
             return UIEdgeInsets(top: 10.0, left: left, bottom: 10.0, right: 0.0)
        }
        
        return UIEdgeInsets(top: 10.0, left: 5.0, bottom: 10.0, right: 5.0)
    }
    
}

