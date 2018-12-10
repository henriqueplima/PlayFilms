//
//  MovieListViewController.swift
//  PlayFilmsTests
//
//  Created by Henrique Pereira de Lima on 10/12/18.
//  Copyright © 2018 Henrique Pereira de Lima. All rights reserved.
//

import UIKit
import Quick
import Nimble
@testable import PlayFilms

class MovieListViewControllerTest: QuickSpec {

    var controller : MovieListViewController!
    
   override func spec() {
        describe("MovieListViewControllerTest"){
            beforeEach {
                self.controller = (UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() as! MovieListViewController)
                _ = self.controller.view
            }
            
            context("When view is loaded"){
                it("test collection view"){
                    expect(self.controller.collectionView).toNot(beNil())
                }
                
                it("test view model"){
                    expect(self.controller.viewModel).toNot(beNil())
                }
                
                it("test isLoading") {
                    expect(self.controller.isLoading).to(beTrue())
                }
                
                it("test footerIdentifier") {
                    expect(self.controller.footerViewReuseIdentifier).to(equal("RefreshControlCustom"))
                }
                
                it("test erorView hidden true"){
                    self.controller.tryAgain(self)
                    expect(self.controller.viewError.isHidden).to(beTrue())
                }
            }
            
            context("CollectionView Cell"){
                it("Teste cell Cover"){
                    let movie = self.getMovie()
                    let indexPath = IndexPath(row: 0, section: 0)
                    let cell = self.controller.collectionView.dequeueReusableCell(withReuseIdentifier: MovieCoverCell.reuseIdentifier, for: indexPath) as! MovieCoverCell
                    cell.setMovie(movie)
                    expect(cell.lblTitle.text).to(equal("Teste1"))
                }
                
            }
        }
    }
    
    func getMovie() -> Movie{
        return Movie(title: "Teste1", id: 1, overview: "Overview1", release: "2015-06-27", path: "path1", avarage: 6.5, coverData: nil)
    }
    
}
