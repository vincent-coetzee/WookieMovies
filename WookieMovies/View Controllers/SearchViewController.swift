//
//  SearchViewController.swift
//  WookieMovies
//
//  Created by Vincent Coetzee on 5/10/21.
//

import UIKit

class SearchViewController: UIViewController
    {
    private static let kMovieDetailControllerName = "movieDetailViewController"
    private static let kTableCellName = "tableCell"
    
    private let movieDatabase = MovieDatabase()
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tableView: UITableView!
    
    private var movies = Movies()
    
    override func viewDidLoad()
        {
        super.viewDidLoad()
        self.searchBar.delegate = self
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.allowsSelection = true
        let recognizer = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        recognizer.cancelsTouchesInView = false
        self.view.addGestureRecognizer(recognizer)
        }

    }

extension SearchViewController: UISearchBarDelegate
    {
    ///
    ///
    /// Handle the text as it changes from the search bar.
    ///
    ///
    public func searchBar(_ searchBar: UISearchBar,textDidChange text: String)
        {
        self.movieDatabase.searchMovies(text)
            {
            error,list in
            if let list = list?.movies,list.count > 0
                {
                self.movies = list.sorted{$0.title < $1.title}
                }
            else
                {
                self.movies = []
                }
            DispatchQueue.main.async
                {
                self.tableView.reloadData()
                }
            }
        }
    }
///
///
///
/// Handle the necessary bits and pieces for a UITableView
///
///
/// 
extension SearchViewController: UITableViewDelegate
    {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
        {
        if let controller = self.storyboard?.instantiateViewController(withIdentifier: Self.kMovieDetailControllerName) as? MovieDetailViewController
            {
            _ = controller.view
            controller.movie = self.movies[indexPath.row]
            self.showDetailViewController(controller, sender: self)
            }
        }
    }
    
extension SearchViewController: UITableViewDataSource
    {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
        {
        return(self.movies.count)
        }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
        {
        if let cell = tableView.dequeueReusableCell(withIdentifier: Self.kTableCellName) as? MovieTableViewCell
            {
            cell.movie = self.movies[indexPath.row]
            return(cell)
            }
        fatalError("Internal inconsistency error.")
        }
    }
