//
//  MovieCategory.swift
//  WookieMovie
//
//  Created by Vincent Coetzee on 4/10/21.
//

import Foundation

///
///
/// We use the genre of the movies as mechanism of keying a movie into a MovieGenre object.
///
///
internal final class MovieGenre
    {
    ///
    ///
    /// Categorize the passed in list of movies by adding them the the genre objects
    /// that they belong to. A movie may get added to multiple genres if it is marked as
    /// belonging to multiple genres.
    ///
    ///
    internal static func categorizeByGenre(list: MovieList) -> Array<MovieGenre>
        {
        var genresByName: Dictionary<String,MovieGenre> = [:]
        for movie in list.movies
            {
            let genres = movie.genres
            for genreName in genres
                {
                if let genre = genresByName[genreName]
                    {
                    genre.addMovie(movie)
                    }
                else
                    {
                    let genre = MovieGenre(name: genreName)
                    genre.addMovie(movie)
                    genresByName[genreName] = genre
                    }
                }
            }
        return(Array(genresByName.values).sorted{$0.name<$1.name})
        }
        
    internal var moviesInGenre: Array<Movie>
        {
        return(self.movies.sorted{$0.title < $1.title})
        }
        
    private var movies = Array<Movie>()
    internal let name: String
    
    internal init(name: String)
        {
        self.name = name
        }
        
    internal func addMovie(_ movie: Movie)
        {
        self.movies.append(movie)
        }
        
    internal func duplicateMovies(by count: Int)
        {
        for _ in 0..<count
            {
            self.movies.append(self.movies[0])
            }
        }
    }
    
internal typealias MovieGenres = Array<MovieGenre>
