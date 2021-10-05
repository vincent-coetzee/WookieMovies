//
//  GenreView.swift
//  WookieMovies
//
//  Created by Vincent Coetzee on 4/10/21.
//

import UIKit

internal class GenreView: UIView
    {
    private static let kIndentFromView:CGFloat = 10
    private static let kLabelFont = UIFont(name:"OpenSans-Bold",size:16)!
    private static let kMovieCellNibName = "MovieViewCell"
    private static let kMovieCellIdentifier = "com.macsemantics.movieViewCell"
    
    internal static func load(from: UINib) -> GenreView
        {
        let array = from.instantiate(withOwner: nil, options: [:])
        if let view = array.compactMap({$0 as?UIView}).first as? GenreView
            {
            return(view)
            }
        fatalError("GenreView should have loaded from nib but did not.")
        }
        
    internal var genre: MovieGenre?
        {
        didSet
            {
            if let genre = self.genre
                {
                self.labelView.text = genre.name
                self.loadMovies(from: genre.moviesInGenre)
                }
            }
        }
        
    @IBOutlet var labelView: UILabel!
    @IBOutlet var collectionView: UICollectionView!
    
    internal var homeViewController: HomeViewController!
    internal var leading: CGFloat = 0
    
    internal override func awakeFromNib()
        {
        super.awakeFromNib()
        self.collectionView.register(UINib(nibName: Self.kMovieCellNibName,bundle: nil),forCellWithReuseIdentifier: Self.kMovieCellIdentifier)
        (self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout).scrollDirection = .horizontal
        self.collectionView.allowsSelection = true
        }
        
    private func loadMovieCell(from: UINib) -> MovieViewCell
        {
        let array = from.instantiate(withOwner: nil, options: [:])
        if let view = array.compactMap({$0 as?UIView}).first as? MovieViewCell
            {
            return(view)
            }
        fatalError("MovieViewCell should have loaded from nib but did not.")
        }
        
    private func loadMovies(from movies: Movies)
        {
        self.labelView.text = self.genre!.name
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.reloadData()
        }
    }

extension GenreView: UICollectionViewDelegate
    {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
        {
        let movie = self.genre!.moviesInGenre[indexPath.row]
        self.homeViewController.displayMovieDetailController(movie: movie)
        }
    }
    
extension GenreView:UICollectionViewDataSource
    {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
        {
        if let genre = self.genre
            {
            return(genre.moviesInGenre.count)
            }
        return(0)
        }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
        {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Self.kMovieCellIdentifier, for: indexPath) as? MovieViewCell
            {
            cell.movie = self.genre!.moviesInGenre[indexPath.row]
            return(cell)
            }
        fatalError("Internal consistency error")
        }
    
    }
