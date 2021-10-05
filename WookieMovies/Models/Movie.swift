//
//  Movie.swift
//  WookieMovie
//
//  Created by Vincent Coetzee on 4/10/21.
//
import UIKit

internal final class Movie:Codable
    {
    private static let kConcurrentQueue = DispatchQueue(label: "com.macsemantics.queue",attributes: .concurrent)
    ///
    ///
    /// Coding keys are used when decoding the irregularly formatted
    /// JSON. These are a standard part of the Encoder amd Decoder
    /// logic.
    ///
    ///
    private enum CodingKeys: String,CodingKey
        {
        case backdrop
        case cast
        case classification
        case director
        case genres
        case id
        case imdbRating
        case length
        case overview
        case poster
        case releasedOn
        case slug
        case title
        }
        
    internal let backdrop: URL
    internal let cast: Array<String>
    internal let classification: String
    internal let director: Array<String>
    internal let genres: Array<String>
    internal let id: String
    internal let imdbRating: Float?
    internal let length: String
    internal let overview: String
    internal let poster: URL
    internal let releasedOn: Date?
    internal let slug: String
    internal let title: String
    internal var posterImage:UIImage?
    internal var backdropImage:UIImage?
    internal var starCount: Int = 0
    internal var isFavourite = false
    ///
    ///
    /// Use a custom decode initializer because the format of the data
    /// is not 100% consistent. The value of the "director" field varies
    /// so this decoding method compensates for that. It uses the default
    /// decoding for the specifid keys where possible.
    ///
    ///
    internal init(from decoder: Decoder) throws
        {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.backdrop = try values.decode(URL.self,forKey: .backdrop)
        self.cast = try values.decode(Array<String>.self,forKey: .cast)
        self.classification = try values.decode(String.self,forKey: .classification)
        do
            {
            let value = try values.decode(String.self,forKey: .director)
            self.director = [value]
            }
        catch
            {
            do
                {
                let values = try values.decode(Array<String>.self,forKey: .director)
                self.director = values
                }
            catch
                {
                self.director = []
                }
            }
        self.genres = try values.decode(Array<String>.self,forKey: .genres)
        self.id = try values.decode(String.self,forKey: .id)
        self.imdbRating = try values.decode(Float?.self,forKey: .imdbRating)
        self.length = try values.decode(String.self,forKey: .length)
        self.overview = try values.decode(String.self,forKey: .overview)
        self.poster = try values.decode(URL.self,forKey: .poster)
        self.releasedOn = try values.decode(Date?.self,forKey: .releasedOn)
        self.slug = try values.decode(String.self,forKey: .slug)
        self.title = try values.decode(String.self,forKey: .title)
        }
    ///
    ///
    /// Asynchronously load the image associated with the movie.
    ///
    ///
    internal func loadPosterImage(_ completion: @escaping (UIImage?) -> Void)
        {
        if let image = self.posterImage
            {
            completion(image)
            return
            }
        Self.kConcurrentQueue.async
            {
            if let data = try? Data(contentsOf: self.poster,options: .alwaysMapped)
                {
                let image = UIImage(data: data)
                self.posterImage = image
                completion(image)
                }
            else
                {
                completion(nil)
                }
            }
        }
    ///
    ///
    /// Asynchronously load the image associated with the movie.
    ///
    ///
    internal func loadBackdropImage(_ completion: @escaping (UIImage?) -> Void)
        {
        if let image = self.backdropImage
            {
            completion(image)
            return
            }
        Self.kConcurrentQueue.async
            {
            if let data = try? Data(contentsOf: self.backdrop,options: .alwaysMapped)
                {
                let image = UIImage(data: data)
                self.backdropImage = image
                completion(image)
                }
            else
                {
                completion(nil)
                }
            }
        }
    }
///
///
/// MovieList is purely used to decode the list of movies coming back from
/// the server. It's a convenience struct and only used in that case
///
///
internal struct MovieList:Codable
    {
    internal let movies: Array<Movie>
    }

///
///
/// Define a typealias that saves us typing out Array<Movie> all the time.
///
internal typealias Movies = Array<Movie>
