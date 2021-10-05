//
//  HomeViewController.swift
//  WookieMovies
//
//  Created by Vincent Coetzee on 4/10/21.
//

import UIKit

internal class HomeViewController: UIViewController
    {
    private static let kRowHeight:CGFloat = 192
    private static let kGenreLabelInset:CGFloat =  10
    private static let kGenreItemHeight:CGFloat = 100
    private static let kLightFontName = "OpenSans-Light"
    private static let kLabelFontSize:CGFloat = 28
    private static let kLabelFont = UIFont(name: HomeViewController.kLightFontName,size: HomeViewController.kLabelFontSize)
    private static let kActivityIndicatorScale:CGFloat = 3
    private static let kGenreViewNibName = "GenreView"
    private static let kMovieDetailControllerName = "movieDetailViewController"
    
    @IBOutlet var viewInScroller: UIView!
    @IBOutlet var mainScroller:UIScrollView!
    @IBOutlet var wookieLabel: UILabel!
    @IBOutlet var moviesLabel: UILabel!

    private var genresKeyedByCollectionView = Dictionary<UICollectionView,MovieGenre>()
    private var movieCellNib: UINib!
    private var mainView: UIView!
    private var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad()
        {
        super.viewDidLoad()
        self.initViews()
        }
    ///
    ///
    /// Initializer the views that were not handled as part of the storyboard in
    /// IB. Add the activityIndicator and use a transform to scale the size of
    /// it up because Apple does not et one scale it up. The busy screen
    /// should only be up for an instant since the movies and images load
    /// quite fast.
    ///
    ///
    private func initViews()
        {
        self.view.backgroundColor = UIColor.white
        self.wookieLabel.font = Self.kLabelFont
        self.moviesLabel.font = Self.kLabelFont
        self.wookieLabel.textColor = .black
        self.moviesLabel.textColor = .black
        self.activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0,y: 0,width: 100,height: 100))
        if let indicator = self.activityIndicator
            {
            self.viewInScroller.addSubview(indicator)
            let x = (self.viewInScroller.frame.size.width - 200) / 2
            let y = (self.viewInScroller.frame.size.height - 200) / 2
            indicator.transform = CGAffineTransform.init(scaleX: Self.kActivityIndicatorScale, y: Self.kActivityIndicatorScale)
            indicator.frame = CGRect(x: x,y: y,width: 200,height: 200)
            indicator.startAnimating()
            }
        MovieDatabase().allMovies
            {
            error,list in
            let genres = MovieGenre.categorizeByGenre(list: list!)
            DispatchQueue.main.async
                {
                self.initGenreViews(with: genres)
                }
            }
        }
    ///
    ///
    /// Load and display the detail view controller with the currently selected
    /// movie loaded into it.
    ///
    ///
    internal func displayMovieDetailController(movie: Movie)
        {
        if let controller = self.storyboard?.instantiateViewController(withIdentifier: Self.kMovieDetailControllerName) as? MovieDetailViewController
            {
            _ = controller.view
            controller.movie = movie
            self.showDetailViewController(controller, sender: self)
            }
        }
    ///
    ///
    /// Init all the genre views which will be displayed inside the primary scroll view.
    ///
    /// 
    private func initGenreViews(with genres: MovieGenres)
        {
        let width = self.view.frame.size.width
        let contentView = self.viewInScroller!
        var index:CGFloat = 0
        var lastView: UIView?
        for genre in genres
            {
            let genreView = GenreView.load(from: UINib(nibName: Self.kGenreViewNibName,bundle: nil))
            genreView.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(genreView)
            genreView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
            genreView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
            genreView.topAnchor.constraint(equalTo: self.mainScroller.topAnchor,constant: Self.kRowHeight * index).isActive = true
            genreView.bottomAnchor.constraint(equalTo: self.mainScroller.topAnchor,constant: Self.kRowHeight * (index + 1)).isActive = true
            genreView.homeViewController = self
            genreView.genre = genre
            index += 1
            lastView = genreView
            }
        contentView.frame = CGRect(x:0,y:0,width: width,height: (index+1)*Self.kRowHeight)
        lastView!.bottomAnchor.constraint(equalTo: self.mainScroller.bottomAnchor).isActive = true
        self.mainScroller.contentSize = CGSize(width: width,height: (index+1)*150)
        self.activityIndicator?.stopAnimating()
        self.activityIndicator?.removeFromSuperview()
        self.activityIndicator = nil
        }
    }
