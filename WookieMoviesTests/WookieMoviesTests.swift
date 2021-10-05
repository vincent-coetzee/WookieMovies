//
//  WookieMoviesTests.swift
//  WookieMoviesTests
//
//  Created by Vincent Coetzee on 4/10/21.
//

import XCTest
@testable import WookieMovies

class WookieMoviesTests: XCTestCase
    {
    override func setUpWithError() throws
        {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        }

    override func tearDownWithError() throws
        {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        }

    func testMovieDatabaseAllMovies() throws
        {
        let expectation = expectation(description: "\(#function) \(#line)")
        let database = MovieDatabase()
        database.allMovies
            {
            error,list in
            XCTAssertNotNil(list,"List from MovieDatabase.allMovies should not be nil.")
            XCTAssertNil(error,"Error from MovieDatabase.allMovies should be nil")
            XCTAssert((list?.movies.count ?? 0) > 0,"List of movies from MovieDatabase.allMovies should be > 0")
            expectation.fulfill()
            }
        waitForExpectations(timeout: 60, handler: nil)
        }
        
    func testMoviesCategorizeAppropriately()
        {
        let expectation = expectation(description: "\(#function) \(#line)")
        let database = MovieDatabase()
        database.allMovies
            {
            error,list in
            XCTAssertNotNil(list,"List from MovieDatabase.allMovies should not be nil.")
            if let list = list
                {
                let genres = MovieGenre.categorizeByGenre(list: list)
                for genre in genres
                    {
                    XCTAssert(genre.moviesInGenre.count > 0,"Movies in genre should be > 0 and is not")
                    let movies = genre.moviesInGenre
                    if let firstMovie = movies.first
                        {
                        XCTAssert(firstMovie.genres.contains(genre.name),"firstMovie.genres does not contain(MovieGenre.name), and it should.")
                        }
                    else
                        {
                        XCTFail("firstMovie of MovieGenre.movies is nil and should not be.")
                        }
                    }
                }
            expectation.fulfill()
            }
        waitForExpectations(timeout: 60, handler: nil)
        }
        
    func testCachedMovies()
        {
        let expectation = expectation(description: "\(#function) \(#line)")
        let database = MovieDatabase()
        database.allMovies
            {
            error,list in
            XCTAssertNotNil(list,"List from MovieDatabase.allMovies should not be nil.")
            expectation.fulfill()
            }
        waitForExpectations(timeout: 60, handler: nil)
        let movie = MovieDatabase.cachedMovie(forKey: "Room")
        XCTAssertNotNil(movie,"Movie with name 'Room' should not be nil")
        let movie1 = MovieDatabase.cachedMovie(forKey: "JunkityJunk")
        XCTAssertNil(movie1,"Movie with name 'JunkityJunk' should be nil")
        MovieDatabase.setFavourite(true, forKey: "Room")
        let isFavourite = MovieDatabase.isMovieFavourite(forKey: "Room")
        XCTAssertTrue(isFavourite,"Value should be true for 'Room' but is not.")
        MovieDatabase.setFavourite(false, forKey: "Room")
        let isFavourite1 = MovieDatabase.isMovieFavourite(forKey: "Room")
        XCTAssertFalse(isFavourite1,"Value should be false for 'Room' but is not.")
        }
        
    func testPosterLoading()
        {
        let expectation = expectation(description: "\(#function) \(#line)")
        let database = MovieDatabase()
        database.allMovies
            {
            error,list in
            print(list)
            expectation.fulfill()
            }
        waitForExpectations(timeout: 60, handler: nil)
        let movie = MovieDatabase.cachedMovie(forKey: "Room")
        XCTAssertNotNil(movie,"Movie at 'Room' should not be nil.")
        let expectation2 = self.expectation(description: "")
        movie?.loadPosterImage
            {
            image in
            expectation2.fulfill()
            }
        waitForExpectations(timeout: 60, handler: nil)
        }
    }
