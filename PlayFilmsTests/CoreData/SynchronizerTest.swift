//
//  SynchronizerTest.swift
//  PlayFilmsTests
//
//  Created by Henrique Pereira de Lima on 10/12/18.
//  Copyright © 2018 Henrique Pereira de Lima. All rights reserved.
//

import UIKit
import Quick
import Nimble
import CoreData

@testable import PlayFilms

class SynchronizerTest: QuickSpec {

    var sync = Synchronizer()
    
    override func spec() {
        describe("SynchronizerTest"){
            it("teste new MovieStore"){
                let movie = self.getMovie()
                 let store = MovieStore(context: self.sync.managedContext, movie: movie)
                expect(store).toNot(beNil())
                expect(store.title).to(equal("Teste1"))
                expect(store.overview).to(equal("Overview1"))
                expect(store.voteCoverage).to(equal(6.5))
            }
        }
    }
    
    func getMovie() -> Movie{
        return Movie(title: "Teste1", id: 1, overview: "Overview1", release: "2015-06-27", path: "path1", avarage: 6.5, coverData: nil)
    }
    
}
