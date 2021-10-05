//
//  MovieSource.swift
//  WookieMovie
//
//  Created by Vincent Coetzee on 4/10/21.
//

import Foundation

internal typealias MovieFetchClosure = (Error?,MovieList?) -> Void

internal final class MovieDatabase
    {
    ///
    ///
    /// A cache of the movies is stored here to improve performance
    ///
    private static var cachedMovies = Array<Movie>()
        {
        didSet
            {
            self.moviesByTitle = [:]
            for movie in self.cachedMovies
                {
                self.moviesByTitle[movie.title] = movie
                }
            }
        }
        
    private static var moviesByTitle = Dictionary<String,Movie>()
    ///
    ///
    /// MArk the movie at the specified key (title) as being a favourite or not.
    ///
    internal static func setFavourite(_ isFavourite: Bool,forKey: String)
        {
        if let movie = self.moviesByTitle[forKey]
            {
            movie.isFavourite = isFavourite
            }
        }
        
    internal static func isMovieFavourite(forKey: String) -> Bool
        {
        if let movie = self.moviesByTitle[forKey]
            {
            return(movie.isFavourite)
            }
        return(false)
        }
        
    internal static func cachedMovie(forKey: String) -> Movie?
        {
        if let movie = self.moviesByTitle[forKey]
            {
            return(movie)
            }
        return(nil)
        }
    ///
    ///
    /// Define constants locally so they are close to the point of use
    ///
    ///
    private static let kDatabaseURLString = "https://wookie.codesubmit.io/movies"
    private static let kBearerAuthorizationToken = "Bearer Wookie2019"
    ///
    ///
    /// Define the JSON formatter used to decode the dates in the
    /// Wookie data because it is non standard.
    ///
    private static let jsonDateFormatter:DateFormatter =
        {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
        }()
    ///
    ///
    /// Use this variable to keep a strong reference to the
    /// data task while we are using it. A strong reference to the
    /// enclosing scope is kept by the user of the MovieDatabase class
    /// thus by having a strong refence to the data task here we ensure
    /// it won't go away thile the allMovies code uses it.
    ///
    /// 
    private var dataTask:URLSessionDataTask?
    
    internal func allMovies(_ completion: @escaping MovieFetchClosure)
        {
        let url = URL(string: Self.kDatabaseURLString)!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let token = Self.kBearerAuthorizationToken
        request.addValue(token,forHTTPHeaderField: "Authorization")
        self.dataTask = URLSession.shared.dataTask(with: request)
            {
            data,response,error in
            if error.isNotNil
                {
                print(response as Any)
                print(error as Any)
                completion(error,nil)
                }
            else if let data = data
                {
                do
                    {
                    print(String(decoding: data, as: UTF8.self))
                    let decoder =  JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let formatter = Self.jsonDateFormatter
                    decoder.dateDecodingStrategy = .formatted(formatter)
                    let list = try decoder.decode(MovieList.self, from: data)
                    Self.cachedMovies = list.movies
                    completion(nil,list)
                    }
                catch let error
                    {
                    print(error)
                    completion(error,nil)
                    }
                }
            else
                {
                completion(WookieMovieError.urlResponseReturnedNoDataButNoError,nil)
                }
            self.dataTask = nil
            }
        self.dataTask?.resume()
        }
    ///
    ///
    /// Search the movie database
    ///
    ///
    internal func searchMovies(_ text: String,completion: @escaping (Error?,MovieList?) -> Void)
        {
        if let url = URL(string: "https://wookie.codesubmit.io/movies?q=\(text)")
            {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            let token = Self.kBearerAuthorizationToken
            request.addValue(token,forHTTPHeaderField: "Authorization")
            self.dataTask = URLSession.shared.dataTask(with: request)
                {
                data,response,error in
                if error.isNotNil
                    {
                    print(response as Any)
                    print(error as Any)
                    completion(error,nil)
                    }
                else if let data = data
                    {
                    do
                        {
                        print(String(decoding: data, as: UTF8.self))
                        let decoder =  JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        let formatter = Self.jsonDateFormatter
                        decoder.dateDecodingStrategy = .formatted(formatter)
                        let list = try decoder.decode(MovieList.self, from: data)
                        for movie in list.movies
                            {
                            movie.loadPosterImage
                                {
                                image in
                                print("poster loaded")
                                }
                            }
                        completion(nil,list)
                        }
                    catch let error
                        {
                        print(error)
                        completion(error,nil)
                        }
                    }
                else
                    {
                    completion(WookieMovieError.urlResponseReturnedNoDataButNoError,nil)
                    }
                self.dataTask = nil
                }
            self.dataTask?.resume()
            }
        }
    }
