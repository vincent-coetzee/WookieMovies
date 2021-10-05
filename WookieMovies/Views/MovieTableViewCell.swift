//
//  MovieTableViewCell.swift
//  WookieMovies
//
//  Created by Vincent Coetzee on 5/10/21.
//

import UIKit

class MovieTableViewCell: UITableViewCell
    {
    private static let kDefaultSelectionColor = UIColor.orange
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var blurbLabel: UILabel!
    @IBOutlet var iconView: UIImageView!
    @IBOutlet var favouriteView: FavouriteView!
    
    internal var movie: Movie?
        {
        didSet
            {
            if let movie = self.movie
                {
                self.favouriteView.isSelected = MovieDatabase.isMovieFavourite(forKey: movie.title)
                self.titleLabel.text = movie.title
                self.blurbLabel.text = movie.overview
                self.blurbLabel.sizeToFit()
                movie.loadPosterImage
                    {
                    image in
                    DispatchQueue.main.async
                        {
                        self.iconView.image = image
                        }
                    }
                }
            }
        }
        
    override func awakeFromNib()
        {
        super.awakeFromNib()
        self.blurbLabel.numberOfLines = 0
        self.blurbLabel.lineBreakMode = .byWordWrapping
        self.favouriteView.tintColor = Self.kDefaultSelectionColor
        self.favouriteView.delegate = self
        }

    override func setSelected(_ selected: Bool, animated: Bool)
        {
        super.setSelected(selected, animated: animated)
        self.contentView.backgroundColor = selected ? Self.kDefaultSelectionColor : UIColor.clear
        }
        
    internal override func prepareForReuse()
        {
        self.titleLabel.text = nil
        self.blurbLabel.text = nil
        self.iconView.image = nil
        self.movie = nil
        self.favouriteView.isSelected = false
        super.prepareForReuse()
        }
    }

extension MovieTableViewCell: FavouriteViewDelegate
    {
    public func favouriteView(_ view: FavouriteView,isFavourite: Bool)
        {
        if let title = movie?.title
            {
            MovieDatabase.setFavourite(isFavourite, forKey: title)
            }
        }
    }
