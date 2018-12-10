//
//  MovieListViewControllerTest.swift
//  PlayFilmsTests
//
//  Created by Henrique Pereira de Lima on 10/12/18.
//  Copyright © 2018 Henrique Pereira de Lima. All rights reserved.
//

import UIKit
import Quick
import Nimble
@testable import PlayFilms

class MovieDetailViewControllerTest: QuickSpec {

    var controller : MovieDetailViewController!
    
    override func spec() {
        describe("MovieListViewControllerTest"){
            
            beforeEach {
                self.controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MovieDetailViewController") as! MovieDetailViewController
                let movie = Movie(title: "Teste1", id: 1, overview: "Overview1", release: "2015-06-27", path: "path1", avarage: 6.5, coverData: nil)
                self.controller.movie = movie
                _ = self.controller.view
            }
            
            context("Check correct movie data"){
                it("should data is correct"){
                    expect(self.controller.lblTitle.text).to(equal("Teste1"))
                    expect(self.controller.lblOverview.text).to(equal("Overview1"))
                    expect(self.controller.lblReleaseDate.text).to(equal("premiere: June 27, 2015"))
                    expect(self.controller.lblAvarage.text).to(equal("Avarege 6.5"))
                }
                
            
            }
            
        }
    }
    
    
    
}
