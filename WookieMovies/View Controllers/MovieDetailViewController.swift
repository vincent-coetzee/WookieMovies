//
//  MovieDetailViewController.swift
//  WookieMovies
//
//  Created by Vincent Coetzee on 5/10/21.
//

import UIKit

class MovieDetailViewController: UIViewController
    {
    internal var movie: Movie?
        {
        didSet
            {
            if let movie = self.movie
                {
                self.update(from: movie)
                }
            }
        }
        
    @IBOutlet var backdropImageView: UIImageView!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var starsView: StarsView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var yearLabel: UILabel!
    @IBOutlet var lengthLabel: UILabel!
    @IBOutlet var directorLabel: UILabel!
    @IBOutlet var castLabel: UILabel!
    @IBOutlet var blurbLabel: UILabel!
    
    override func viewDidLoad()
        {
        super.viewDidLoad()
        }
    ///
    ///
    ///
    /// Update the receiver's outlets from the movie
    /// which was set for this detail view.
    ///
    /// 
    private func update(from movie: Movie)
        {
        movie.loadBackdropImage
            {
            image in
            DispatchQueue.main.async
                {
                self.backdropImageView.image = image
                self.backdropImageView.contentMode = .scaleAspectFit
                }
            }
        movie.loadPosterImage
            {
            image in
            DispatchQueue.main.async
                {
                self.imageView.image = image
                self.imageView.contentMode = .scaleAspectFit
                }
            }
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year],from: movie.releasedOn ?? Date())
        let rating = movie.imdbRating.isNil ? "" : " (imdb \(movie.imdbRating!))"
        self.titleLabel.text = "\(movie.title)\(rating)"
        self.titleLabel.textColor = .white
        self.yearLabel.text = "\(dateComponents.year!)"
        self.lengthLabel.text = movie.length
        self.castLabel.text = movie.cast.joined(separator: ", ")
        self.castLabel.numberOfLines = 0
        self.castLabel.sizeToFit()
        self.blurbLabel.text = movie.overview
        self.blurbLabel.numberOfLines = 0
        self.blurbLabel.sizeToFit()
        self.directorLabel.text = movie.director.joined(separator: ",")
        self.starsView.movie = movie
        }
        
    @IBAction func onCancelTapped(_ sender: Any?)
        {
        self.dismiss(animated: true, completion: nil)
        }
    }
