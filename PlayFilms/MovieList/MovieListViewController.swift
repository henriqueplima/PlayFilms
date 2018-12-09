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
    var isLoading = true
    var refreshFooter : RefreshControlCustom?
    let footerViewReuseIdentifier = "RefreshControlCustom"
    var moviesList : [Movie] = [] {
        didSet{
            self.collectionView.reloadData()
            self.isLoading = false
            refreshControl.endRefreshing()
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
        self.viewModel.fetchMovies { (response) in
            DispatchQueue.main.async { self.moviesList.append(contentsOf: response) }
        }
    }
    
    func movieSelected(at indexPath:IndexPath) {
        let movie = self.moviesList[indexPath.row]
        let detailController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MovieDetailViewController") as! MovieDetailViewController
        detailController.movie = movie
        self.present(detailController, animated: true, completion: nil)
        
    }
    
    // MARK - CollectionView DataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.moviesList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCoverCell.reuseIdentifier, for: indexPath) as! MovieCoverCell
        let movie = self.moviesList[indexPath.row]
        cell.setMovie(movie)
        if movie.coverData == nil {
            self.viewModel.downloadCoverMovie(path: movie.coverPath) { (data) in
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
        let width = collectionView.bounds.size.width - 30
        return MovieCoverCell.size(for: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if isLoading {
            return CGSize.zero
        }
        return CGSize(width: collectionView.bounds.size.width, height: 126)
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

extension MovieListViewController:UIScrollViewDelegate{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let threshold   = 100.0 ;
        let contentOffset = scrollView.contentOffset.y;
        let contentHeight = scrollView.contentSize.height;
        let diffHeight = contentHeight - contentOffset;
        let frameHeight = scrollView.bounds.size.height;
        var triggerThreshold  = Float((diffHeight - frameHeight))/Float(threshold);
        triggerThreshold   =  min(triggerThreshold, 0.0)
        let pullRatio  = min(Swift.abs(triggerThreshold), 1.0) //min(fabs(triggerThreshold),1.0);
        self.refreshFooter?.setTransform(inTransform: CGAffineTransform.identity, scaleFactor: CGFloat(pullRatio))
        if pullRatio >= 1 {
            self.refreshFooter?.animateFinal()
        }
        print("pullRation:\(pullRatio)")
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        // Calculate where the collection view should be at the right-hand end item
//        let fullyScrolledContentOffset:CGFloat = self.collectionView.frame.size.height //* CGFloat(self.moviesList.count - 1)
//        var teste = scrollView.contentOffset.y
//        if (scrollView.contentOffset.y > 0) {
//            //fetchMovies()
//            debugPrint("outro aqui")
//        }
        
        let contentOffset = scrollView.contentOffset.y;
        let contentHeight = scrollView.contentSize.height;
        let diffHeight = contentHeight - contentOffset;
        let frameHeight = scrollView.bounds.size.height;
        let pullHeight  = Swift.abs(diffHeight - frameHeight) //fabs(diffHeight - frameHeight);
        print("pullHeight:\(pullHeight)");
        if pullHeight == 0.0
        {
            
            print("chamou aqui");
            if (self.refreshFooter?.isAnimatingFinal)! {
                print("load more trigger")
                self.isLoading = true
                self.refreshFooter?.startAnimate()
                fetchMovies()
//                Timer.scheduledTimer(withTimeInterval: 2, repeats: false, block: { (timer:Timer) in
////                    for i:Int in self.items.count + 1...self.items.count + 25 {
////                        self.items.append(i)
////                    }
////                    self.collectionView.reloadData()
////                    self.isLoading = false
//                })
            }
        }
        
        
        
    }
}

