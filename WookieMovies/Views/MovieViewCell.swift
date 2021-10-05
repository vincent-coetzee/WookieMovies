//
//  MovieCollectionViewCell.swift
//  WookieMovies
//
//  Created by Vincent Coetzee on 4/10/21.
//

import UIKit

class MovieViewCell: UICollectionViewCell
    {
    private static let kFontName = "OpenSans-Light"
    private static let kLabelFont = UIFont(name: "OpenSans-Light",size:10)
    
    public static let kSize = CGSize(width: 125,height: 150)
    
    internal var movie: Movie?
        {
        didSet
            {
            if let aMovie = movie
                {
                self.updateCell(from: aMovie)
                }
            }
        }
        
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var labelView: UITextView!
        
    private func updateCell(from movie: Movie)
        {
        self.imageView.image = UIImage(named: "IconImageLoading")!
        self.imageView.tintColor = UIColor.black
        self.imageView.contentMode = .scaleAspectFit
        self.movie?.loadPosterImage
            {
            image in
            DispatchQueue.main.async
                {
                self.imageView.image = image
                self.activityIndicator.stopAnimating()
                self.activityIndicator.removeFromSuperview()
                }
            }
        self.labelView.text = movie.title
        self.labelView.font = Self.kLabelFont
        }
        
    override func awakeFromNib()
        {
        super.awakeFromNib()
        self.labelView.textContainer.lineBreakMode = .byWordWrapping
        self.labelView.textContainer.maximumNumberOfLines = 5
        self.activityIndicator.startAnimating()
        }
    }
